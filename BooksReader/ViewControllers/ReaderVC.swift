//
//  ReaderVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit

class ReaderVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return (SettingManager.readMode == .fullscreen ? true : false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add navigation buttons
        let listBtn = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(navBtnListTapped(_:)))
        let settingBtn = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(navBtnSettingTapped(_:)))
        
        navigationItem.leftBarButtonItem = listBtn
        navigationItem.rightBarButtonItem = settingBtn
        
        // init tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // more config
        configUI()
    }
    
    
    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.txtColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
    }
    

    // MARK: actions
    
    @objc func navBtnListTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ListVC") as? ListVC else { return }
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @objc func navBtnSettingTapped(_ sender: Any) {
        
    }
    
    
    @objc func tapGestureHandler(_ sender: Any) {
        changeReadMode()
    }

    
    // MARK: methods
    
    func changeReadMode() {
        if SettingManager.changeReadMode() == .fullscreen {
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 0.0
                self.setNeedsStatusBarAppearanceUpdate()
                
            } completion: { (finished) in
                self.navigationController?.navigationBar.isHidden = true
            }
            
        } else {
            navigationController?.navigationBar.alpha = 0.0
            navigationController?.navigationBar.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 1.0
                self.setNeedsStatusBarAppearanceUpdate()
                
            } completion: { (finished) in
                self.navigationController?.navigationBar.alpha = 1.0
                self.navigationController?.navigationBar.isHidden = false
            }
        }
    }
    
}
