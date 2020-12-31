//
//  SettingVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit
import KUIPopOver

class SettingVC: UIViewController, KUIPopOverUsable {
    
    @IBOutlet weak var langNote: UILabel!
    @IBOutlet weak var langValue: UILabel!
    @IBOutlet weak var langMark: UIImageView!
    @IBOutlet weak var btnLanguage: UIButton!
    
    @IBOutlet weak var btnFontSmall: UIButton!
    @IBOutlet weak var btnFontLarge: UIButton!
    
    @IBOutlet weak var fontNote: UILabel!
    @IBOutlet weak var fontValue: UILabel!
    @IBOutlet weak var fontMark: UIImageView!
    @IBOutlet weak var btnFont: UIButton!
    
    @IBOutlet var btnThemes: [UIButton]!
    
    var delegate: ReaderViewControllerDelegate?
    
    
    var contentSize: CGSize {
        return CGSize(width: 250, height: 190)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        configUI()
    }
    
    
    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
        
        langNote.textColor = SettingManager.txtColor
        langValue.textColor = SettingManager.txtColor
        langValue.text = SettingManager.languageMode.rawValue
        langMark.tintColor = SettingManager.txtColor
        
        btnFontSmall.tintColor = SettingManager.txtColor
        btnFontLarge.tintColor = SettingManager.txtColor
        
        fontNote.textColor = SettingManager.txtColor
        fontValue.textColor = SettingManager.txtColor
        fontValue.text = SettingManager.fontName.rawValue
        fontMark.tintColor = SettingManager.txtColor
        
        for btn in btnThemes {
            if btn.tag == SettingManager.theme.rawValue {
                btn.rounded(borderColor: SettingManager.txtColor, borderWidth: 1.0)
            } else {
                btn.rounded()
            }
        }
    }

    
    // MARK: actions
    
    @IBAction func btnFontSmallTapped(_ sender: Any) {
        if SettingManager.fontSize > 12 {
            SettingManager.fontSize -= 2
        }
        
        delegate?.chosenMode()
    }
    
    
    @IBAction func btnFontLargeTapped(_ sender: Any) {
        if SettingManager.fontSize < 36 {
            SettingManager.fontSize += 2
        }
        
        delegate?.chosenMode()
    }
    
    
    @IBAction func btnFontListTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "FontListVC") as? FontListVC else { return }
        vc.type = .font
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnLanguageListTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "FontListVC") as? FontListVC else { return }
        vc.type = .language
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnThemeTapped(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        
        SettingManager.changeTheme(ThemeStyle(rawValue: tag)!)
        configUI()
        
        delegate?.chosenMode()
    }
    
}
