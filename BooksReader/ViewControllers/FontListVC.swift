//
//  FontListVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit
import KUIPopOver


enum ListType: String {
    case font = "Fonts"
    case language = "Languages"
}


class FontListVC: UIViewController, KUIPopOverUsable {
    
    var type: ListType = .font
    
    
    var contentSize: CGSize {
        return CGSize(width: 250, height: 450)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SettingManager.toolColor]
        navigationItem.title = type.rawValue
    }
    

    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
    }

}
