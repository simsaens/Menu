//
//  ViewController.swift
//  MenuTest
//
//  Created by Simeon Saint-Saens on 3/1/19.
//  Copyright © 2019 Two Lives Left. All rights reserved.
//

import UIKit
import SnapKit
import Menu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuView(title: "Menu", theme: LightMenuTheme()) { () -> [MenuItem] in
            return [
                ShortcutMenuItem(name: "Undo", shortcut: (.command, "Z"), action: {
                    [weak self] in
                    
                    let alert = UIAlertController(title: "Undo Action", message: "You selected undo", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true, completion: nil)
                }),
                
                ShortcutMenuItem(name: "Redo", shortcut: ([.command, .shift], "Z"), action: {}),
                
                SeparatorMenuItem(),
                
                ShortcutMenuItem(name: "Insert Image", shortcut: ([.command, .alternate], "I"), action: {}),
                ShortcutMenuItem(name: "Insert Link", shortcut: ([.command, .alternate], "L"), action: {}),
                
                SeparatorMenuItem(),
                
                ShortcutMenuItem(name: "Help", shortcut: (.command, "?"), action: {}),
            ]
        }
        
        view.addSubview(menu)
        
        menu.tintColor = .black
        
        menu.snp.makeConstraints {
            make in
            
            make.center.equalToSuperview()
            
            //Menus don't have an intrinsic height
            make.height.equalTo(40)
        }
    }


}

