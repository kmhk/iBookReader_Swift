//
//  ListVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit

class ListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        
        let backBtn = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(navBtnBackTapped(_:)))
        navigationItem.rightBarButtonItem = backBtn
        
        configUI()
    }
    

    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
    }
    
    
    // MARK: actions
    
    @objc func navBtnBackTapped(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }

}
