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
    
    @IBOutlet weak var tableView: UITableView!
    
    var type: ListType = .font
    var delegate: ReaderViewControllerDelegate?
    
    var list = [String]()
    
    
    var contentSize: CGSize {
        return CGSize(width: 250, height: 450)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
        
        initData()
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

    
    func initData() {
        if type == .font {
            for i in FontName.allCases {
                list.append(i.rawValue)
            }
        } else {
            for i in LanguageMode.allCases {
                list.append(i.rawValue)
            }
        }
        
        tableView.reloadData()
    }
    
}


// MARK: - UITableView delegate & data source
extension FontListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontListTVCell", for: indexPath)
        
        cell.textLabel?.textColor = SettingManager.txtColor
        cell.textLabel?.text = list[indexPath.row]
        
        if type == .font {
            cell.textLabel?.font = UIFont(name: list[indexPath.row], size: 17)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        
        cell.accessoryView?.tintColor = SettingManager.txtColor
        cell.accessoryType = .none
        
        if type == .font && list[indexPath.row] == SettingManager.fontName.rawValue {
            cell.accessoryType = .checkmark
        } else if type == .language && list[indexPath.row] == SettingManager.languageMode.rawValue {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .font {
            SettingManager.fontName = FontName(rawValue: list[indexPath.row])!
        } else {
            SettingManager.languageMode = LanguageMode(rawValue: list[indexPath.row])!
        }
        
        tableView.reloadData()
        
        delegate?.chosenMode()
    }
    
}
