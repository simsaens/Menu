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
    public let textColor = UIColor(red: 13/255.0, green: 51/255.0, blue: 48/255.0, alpha: 1.0)
    public let brightTintColor = UIColor.white
    public let darkTintColor = UIColor.black
    public let highlightedTextColor = UIColor.white
    public let highlightedBackgroundColor = UIColor(red: 55/255.0, green: 188/255.0, blue: 174/255.0, alpha: 1.0)
    public let backgroundTint = UIColor(red: 25/255.0, green: 149/255.0, blue: 125/255.0, alpha: 0.11)
    public let gestureBarTint = UIColor(red: 13/255.0, green: 51/255.0, blue: 48/255.0, alpha: 0.17)
    public let blurEffect = UIBlurEffect(style: .light)
    public let shadowColor = UIColor(red: 103/255.0, green: 165/255.0, blue: 162/255.0, alpha: 1.0)
    public let shadowOpacity: Float = 1.0
    public let shadowRadius: CGFloat = 7.0
    public let separatorColor = UIColor(white: 0, alpha: 0.1)
    
    public init() {}
}
