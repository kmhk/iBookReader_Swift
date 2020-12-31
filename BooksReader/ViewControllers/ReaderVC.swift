//
//  ReaderVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit
import KUIPopOver


protocol ReaderViewControllerDelegate {
    func chosenMode()
}


class ReaderVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configUI()
    }
    
    
    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        tableView.reloadData()
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
    
    
    @objc func navBtnSettingTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC else { return }
        vc.delegate = self
        vc.showPopoverWithNavigationController(barButtonItem: sender, shouldDismissOnTap: true)
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


// MARK: - UITableView data source & delegate
extension ReaderVC: UITableViewDataSource, UITableViewDelegate {
    
    func heightOfString(_ indexPath: IndexPath) -> CGFloat {
        let w = tableView.frame.width // width of title label
        let str = ContentManager.shared.attributString(indexPath)
        return str.sizeFittingWidth(w).height
//        let constBox = CGSize(width: w, height: .greatestFiniteMagnitude)
//        let rt = str.boundingRect(with: constBox, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral
//        return rt.height + 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReaderTVCell", for: indexPath)
        
        let text = ContentManager.shared.attributString(indexPath)
        
        cell.textLabel?.attributedText = text
        cell.textLabel?.numberOfLines = Int(heightOfString(indexPath)) / Int(SettingManager.fontSize)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfString(indexPath) + 50
    }
}


// MARK: - ReaderViewController delegate
extension ReaderVC: ReaderViewControllerDelegate {
    
    func chosenMode() {
        configUI()
    }
    
}
