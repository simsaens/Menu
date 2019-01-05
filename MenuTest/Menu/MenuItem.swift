//
//  MenuItem.swift
//  Menus
//
//  Created by Simeon on 6/6/18.
//  Copyright © 2018 Two Lives Left. All rights reserved.
//

import UIKit

public protocol MenuItem {
    typealias MenuViewType = (UIView & MenuThemeable & MenuItemView)
    
    var view: MenuViewType { get }
    
    func performAction()
}

public struct SeparatorMenuItem: Equatable, MenuItem {
    
    public var view: MenuItem.MenuViewType {
        return SeparatorMenuItemView()
    }
    
    public init() {}
    
    public static func == (lhs: SeparatorMenuItem, rhs: SeparatorMenuItem) -> Bool {
        return true
    }
    
    public func performAction() {}
}

public extension UIKeyModifierFlags {
    public var symbols: [String] {
        var result: [String] = []
        
        if contains(.alternate) {
            result.append("⌥")
        }
        
        if contains(.control) {
            result.append("⌃")
        }
        
        if contains(.shift) {
            result.append("⇧")
        }
        
        if contains(.command) {
            result.append("⌘")
        }
        
        return result
    }
}

public struct ShortcutMenuItem: Equatable, MenuItem {
    public static var displayShortcuts: Bool = true
    
    public struct Shortcut: Equatable {
        public let modifiers: UIKeyModifierFlags
        public let key: String
        public let title: String
    }
    
    public var action: () -> Void = {}
    
    public let name: String
    public let shortcut: Shortcut?
    
    public init(name: String, shortcut: (UIKeyModifierFlags, String)? = nil, action: @escaping () -> Void) {
        self.name = name
        self.action = action
        
        if let (modifiers, key) = shortcut {
            self.shortcut = Shortcut(modifiers: modifiers, key: key, title: name)
        } else {
            self.shortcut = nil
        }
    }
    
    public var view: MenuItem.MenuViewType {
        return ShortcutMenuItemView(item: self)
    }
    
    public static func == (lhs: ShortcutMenuItem, rhs: ShortcutMenuItem) -> Bool {
        return lhs.name == rhs.name && lhs.shortcut == rhs.shortcut
    }
    
    public func performAction() {
        action()
    }
}

public extension ShortcutMenuItem {
    public var keyCommand: UIKeyCommand? {
        //TODO: Needs updating
//        if let shortcut = shortcut {
//            return UIKeyCommand(input: shortcut.key, modifierFlags: shortcut.modifiers, action: action, discoverabilityTitle: shortcut.title)
//        }
        
        return nil
    }
}
