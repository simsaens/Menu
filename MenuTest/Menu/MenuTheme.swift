//
//  MenuTheme.swift
//  Menus
//
//  Created by Simeon on 3/6/18.
//  Copyright © 2018 Two Lives Left. All rights reserved.
//

import UIKit

public protocol MenuThemeable {
    func applyTheme(_ theme: MenuTheme)
}

public protocol MenuTheme {
    
    var font: UIFont { get }
    var textColor: UIColor { get }
    var brightTintColor: UIColor { get }
    var darkTintColor: UIColor { get }
    var highlightedTextColor: UIColor { get }
    var highlightedBackgroundColor: UIColor { get }
    var backgroundTint: UIColor { get }
    var gestureBarTint: UIColor { get }
    var blurEffect: UIBlurEffect { get }
    var shadowColor: UIColor { get }
    var shadowOpacity: Float { get }
    var shadowRadius: CGFloat { get }
    var separatorColor: UIColor { get }
    
}

public struct LightMenuTheme: MenuTheme {
    
    public let font = UIFont.systemFont(ofSize: 16, weight: .medium)
    public let textColor = UIColor.black
    public let brightTintColor = UIColor.white
    public let darkTintColor = UIColor.black
    public let highlightedTextColor = UIColor.white
    public let highlightedBackgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
    public let backgroundTint = UIColor(white: 1.0, alpha: 0.15)
    public let gestureBarTint = UIColor(red: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 0.17)
    public let blurEffect = UIBlurEffect(style: .light)
    public let shadowColor = UIColor.black
    public let shadowOpacity: Float = 0.3
    public let shadowRadius: CGFloat = 7.0
    public let separatorColor = UIColor(white: 0, alpha: 0.1)
    
    public init() {}
}
