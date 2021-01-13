//
//  ListVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ReaderViewControllerDelegate?
    
    
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


// MARK: - UITableView data source & delegate
extension ListVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath)
        
        let text = ContentManager.shared.stringTitle(indexPath.row)
        
        cell.textLabel?.text = text
        cell.textLabel?.textColor = SettingManager.txtColor
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navBtnBackTapped(self)
        
        delegate?.seekToPage(indexPath.row)
    }

}
