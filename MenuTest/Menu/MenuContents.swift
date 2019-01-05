//
//  MenuContents.swift
//  ToolKit
//
//  Created by Simeon Saint-Saens on 3/12/18.
//  Copyright © 2018 Two Lives Left. All rights reserved.
//

import UIKit
import SnapKit

extension UIScrollView {
    var maxContentOffset: CGPoint {
        return CGPoint(x: contentSize.width - bounds.size.width, y: contentSize.height - bounds.size.height)
    }
}

class MenuContents: UIView {
    
    typealias MenuViewType = MenuItem.MenuViewType
    
    private let maxHeight: CGFloat
    private let shadowView = UIView()
    private let tintView = UIView()
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let scrollContainer = UIView()
    private let scrollView = UIScrollView()
    
    let stackView: UIStackView
    
    private let titleLabel = UILabel()
    
    private let radius: CGFloat
    
    private var edgeScrollTimer: Timer?
    
    private var menuItemViews: [MenuViewType] {
        get {
            return stackView.subviews.compactMap {
                $0 as? MenuViewType
            }
        }
    }
    
    var items: [MenuItem] {
        didSet {
            //Diff the stack view
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var highlightedPosition: CGPoint? {
        didSet {
            let pos = highlightedPosition ?? CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
            updateHighlightedPosition(pos)
        }
    }
    
    var isInteractiveDragActive: Bool = false {
        didSet {
            if isInteractiveDragActive == false {
                edgeScrollTimer?.invalidate()
                edgeScrollTimer = nil
            }
        }
    }
    
    private var isScrollable: Bool {
        return scrollView.contentSize.height > scrollView.bounds.size.height
    }
    
    private func pointIsInsideBottomEdgeScrollingBoundary(_ point: CGPoint) -> Bool {
        return point.y > scrollView.bounds.size.height - 24 && isScrollable
    }
    
    private func pointIsInsideTopEdgeScrollingBoundary(_ point: CGPoint) -> Bool {
        return point.y < scrollView.frame.minY + 40 && isScrollable
    }
    
    private func updateHighlightedPosition(_ point: CGPoint) {
        menuItemViews.forEach {
            var view = $0
            
            let point = convert(point, to: $0)
            let contains = $0.point(inside: point, with: nil)
            
            view.highlighted = contains
            view.highlightPosition = point
        }
        
        let pointInsideBoundary = pointIsInsideTopEdgeScrollingBoundary(point) || pointIsInsideBottomEdgeScrollingBoundary(point)
        
        if pointInsideBoundary && edgeScrollTimer == nil && isInteractiveDragActive {
            edgeScrollTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true, block: {
                [weak self] _ in
                
                guard let self = self else {
                    return
                }
                
                let point = self.highlightedPosition ?? .zero
                let offsetAmount: CGFloat = 2.0
                
                if self.pointIsInsideBottomEdgeScrollingBoundary(point) {
                    var offset = self.scrollView.contentOffset
                    offset.y += offsetAmount
                    
                    let maxOffset = self.scrollView.maxContentOffset
                    
                    if offset.y < maxOffset.y {
                        self.scrollView.contentOffset = offset
                    }
                }
                
                if self.pointIsInsideTopEdgeScrollingBoundary(point) {
                    var offset = self.scrollView.contentOffset
                    offset.y -= offsetAmount
                    
                    let minOffset = -self.scrollView.contentInset.top
                    
                    if offset.y > minOffset {
                        self.scrollView.contentOffset = offset
                    }
                }
                
                self.updateHighlightedPosition(point)
            })
        } else if !pointInsideBoundary {
            edgeScrollTimer?.invalidate()
            edgeScrollTimer = nil
        }
    }
    
    func selectPosition(_ point: CGPoint, completion: @escaping (MenuItem) -> Void) {
        menuItemViews.enumerated().forEach {
            index, view in
            
            let point = convert(point, to: view)
            if view.point(inside: point, with: nil) {
                view.startSelectionAnimation {
                    [weak self] in
                    if let self = self {
                        completion(self.items[index])
                    }
                }
            }
        }
    }
    
    init(name: String, items: [MenuItem], theme: MenuTheme, maxHeight: CGFloat = 300, radius: CGFloat = 8.0) {

        let itemViews: [MenuViewType] = items.map {
            let item = $0.view
            item.applyTheme(theme)
            return item
        }
        
        stackView = UIStackView(arrangedSubviews: itemViews)
        
        self.maxHeight = maxHeight
        self.items = items
        self.radius = radius
        
        super.init(frame: .zero)
        
        titleLabel.text = name
        
        addSubview(shadowView)
        
        shadowView.snp.makeConstraints {
            make in
            
            make.edges.equalToSuperview().inset(-20)
        }
        
        addSubview(effectView)
        
        effectView.snp.makeConstraints {
            make in
            
            make.edges.equalToSuperview()
        }
        
        effectView.contentView.addSubview(tintView)
        effectView.contentView.addSubview(titleLabel)
        effectView.contentView.addSubview(scrollContainer)
        
        scrollContainer.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollContainer.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            make in
            
            make.edges.equalToSuperview()
            make.height.equalTo(maxHeight)
        }
        
        tintView.snp.makeConstraints {
            make in
            
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            make in
            
            make.top.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.left.right.equalTo(scrollView.frameLayoutGuide)
            } else {
                make.left.right.equalTo(self)
            }
        }
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        applyTheme(theme)
    }
    
    private func computePath(withParentView view: UIView, alignment: MenuView.Alignment) -> UIBezierPath {
        let localViewBounds: CGRect
        let lowerRectCorners: UIRectCorner
        
        switch alignment {
        case .center:
            localViewBounds = view.bounds.offsetBy(dx: bounds.size.width/2.0 - view.bounds.size.width/2.0, dy: 0.0)
            lowerRectCorners = .allCorners
        case .right:
            localViewBounds = view.bounds
            lowerRectCorners = [.topRight, .bottomLeft, .bottomRight]
        case .left:
            localViewBounds = view.bounds.offsetBy(dx: bounds.size.width - view.bounds.size.width, dy: 0.0)
            lowerRectCorners = [.topLeft, .bottomLeft, .bottomRight]
        }
        
        let topPath = UIBezierPath(roundedRect: localViewBounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        
        let midPath = UIBezierPath()
        
        switch alignment {
        case .center:
            midPath.move(to: CGPoint(x: localViewBounds.minX, y: localViewBounds.maxY))
            midPath.addLine(to: CGPoint(x: localViewBounds.maxX, y: localViewBounds.maxY))
            midPath.addArc(withCenter: CGPoint(x: localViewBounds.maxX + radius, y: localViewBounds.maxY), radius: radius, startAngle: .pi, endAngle: .pi/2.0, clockwise: false)
            midPath.addLine(to: CGPoint(x: localViewBounds.minX - radius, y: localViewBounds.maxY + radius))
            midPath.addArc(withCenter: CGPoint(x: localViewBounds.minX - radius, y: localViewBounds.maxY), radius: radius, startAngle: .pi/2.0, endAngle: 0.0, clockwise: false)
        case .right:
            midPath.move(to: CGPoint(x: localViewBounds.minX, y: localViewBounds.maxY))
            midPath.addLine(to: CGPoint(x: localViewBounds.maxX, y: localViewBounds.maxY))
            midPath.addArc(withCenter: CGPoint(x: localViewBounds.maxX + radius, y: localViewBounds.maxY), radius: radius, startAngle: .pi, endAngle: .pi/2.0, clockwise: false)
            midPath.addLine(to: CGPoint(x: localViewBounds.minX, y: localViewBounds.maxY + radius))
        case .left:
            midPath.move(to: CGPoint(x: localViewBounds.minX, y: localViewBounds.maxY))
            midPath.addLine(to: CGPoint(x: localViewBounds.maxX, y: localViewBounds.maxY))
            midPath.addLine(to: CGPoint(x: localViewBounds.maxX, y: localViewBounds.maxY + radius))
            midPath.addLine(to: CGPoint(x: localViewBounds.minX - radius, y: localViewBounds.maxY + radius))
            midPath.addArc(withCenter: CGPoint(x: localViewBounds.minX - radius, y: localViewBounds.maxY), radius: radius, startAngle: .pi/2.0, endAngle: 0.0, clockwise: false)
        }
        
        midPath.close()
        
        let yOffset = localViewBounds.maxY + radius
        let bottomPath = UIBezierPath(roundedRect: CGRect(x: 0, y: yOffset, width: bounds.size.width, height: bounds.size.height - yOffset), byRoundingCorners: lowerRectCorners, cornerRadii: CGSize(width: radius, height: radius))
        
        topPath.append(midPath)
        topPath.append(bottomPath)
        
        return topPath
    }
    
    func pointInsideMenuShape(_ point: CGPoint) -> Bool {
        let contentsPoint = convert(point, to: scrollContainer)
        
        return scrollContainer.bounds.contains(contentsPoint)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = superview else {
            return
        }
        
        //We're rendering under the superview, so let's do that
        titleLabel.snp.remakeConstraints {
            make in
            
            make.center.equalTo(superview)
        }
        
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: radius + 6, left: 0, bottom: 6, right: 0)
        scrollView.contentInset = UIEdgeInsets(top: radius + 6, left: 0, bottom: 6, right: 0)
        
        let insetAdjustment = scrollView.contentInset.top + scrollView.contentInset.bottom
        
        scrollContainer.snp.remakeConstraints {
            make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(superview.snp.bottom)
        }
        
        scrollView.snp.remakeConstraints {
            make in
            
            make.width.greaterThanOrEqualTo(superview.snp.width).offset(100)
            make.bottom.equalToSuperview()
            make.height.equalTo(stackView).offset(insetAdjustment).priority(.low)
            make.height.lessThanOrEqualTo(maxHeight).priority(.required)
            make.top.left.right.equalToSuperview()
        }
        
        applyContentMask()
    }
    
    func focusInitialViewIfNecessary() {
        for item in stackView.arrangedSubviews {
            
            if let item = item as? MenuViewType,
                let rect = item.initialFocusedRect {
                
                let updatedRect = item.convert(rect, to: scrollView)
                scrollView.scroll(toVisible: updatedRect, animated: false)
                
                break
            }
            
        }
    }
    
    func generateMaskAndShadow(alignment: MenuView.Alignment) {
        guard let view = superview else {
            return
        }
        
        let path = computePath(withParentView: view, alignment: alignment)
        
        //Mask effect view
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        effectView.layer.mask = shapeMask
        
        //Create inverse mask for shadow layer
        path.apply(CGAffineTransform(translationX: 20, y: 20))
        
        let sublayer = shadowView.layer
        
        sublayer.shadowPath = path.cgPath
        sublayer.shadowOffset = CGSize(width: 0, height: 6)
        
        let imageRenderer = UIGraphicsImageRenderer(size: shadowView.bounds.size)
        
        let shadowMask = imageRenderer.image {
            context in
            
            UIColor.white.setFill()
            context.fill(shadowView.bounds)
            path.fill(with: .clear, alpha: 1.0)
        }
        
        let imageMask = CALayer()
        imageMask.frame = shadowView.bounds
        imageMask.contents = shadowMask.cgImage
        
        sublayer.mask = imageMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: MenuTheme) {
        titleLabel.font = theme.font
        titleLabel.textColor = theme.textColor
        effectView.effect = theme.blurEffect
        tintView.backgroundColor = theme.backgroundTint
        
        shadowView.layer.shadowOpacity = theme.shadowOpacity
        shadowView.layer.shadowRadius = theme.shadowRadius
        shadowView.layer.shadowColor = theme.shadowColor.cgColor
    }
    
    //MARK: - Content Masking
    
    override var frame: CGRect {
        didSet {
            updateContentMask()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateContentMask()
        }
    }
    
    func updateContentMask() {
        if let maskLayer = scrollContainer.layer.mask as? CAGradientLayer {
            maskLayer.frame = bounds
            
            let height = bounds.size.height
            let stop2 = 12 / height
            
            maskLayer.startPoint = CGPoint(x: 0.5, y: 0)
            maskLayer.endPoint = CGPoint(x: 0.5, y: stop2)
        }
    }
    
    private func applyContentMask() {
        let maskLayer = CAGradientLayer()
        
        maskLayer.frame = bounds
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor]
        maskLayer.locations = [0, 0.72, 1.0]
        maskLayer.startPoint = CGPoint(x: 0.5, y: 0)
        maskLayer.endPoint = CGPoint(x: 0.5, y: 0.33)
        
        scrollContainer.layer.mask = maskLayer
    }
}


