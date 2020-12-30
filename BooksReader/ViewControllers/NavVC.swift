//
//  NavVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit

class NavVC: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (SettingManager.theme.rawValue > 1 ? .lightContent : .darkContent)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // erase 1 px line under navigation bar
        UIGraphicsBeginImageContext(CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.lightGray.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UINavigationBar.appearance().shadowImage = image
    }

}
