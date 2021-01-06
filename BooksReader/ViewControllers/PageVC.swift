//
//  PageVC.swift
//  BooksReader
//
//  Created by com on 1/6/21.
//

import UIKit

class PageVC: UIViewController {
    
    var pageNum: Int = 0
    var attrTxt: NSAttributedString?
    var lines: Int = 0
    var lblText: UILabel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblText = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: view.frame.height))
        lblText?.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        view.addSubview(lblText!)
        
        lblText?.attributedText = attrTxt
        lblText?.numberOfLines = lines
        
        view.backgroundColor = SettingManager.bkColor
    }
    
    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        lblText?.textColor = SettingManager.txtColor
        
        attrTxt = ContentManager.shared.attributContents(pageNum)
        lblText?.attributedText = attrTxt
        
        lines = Int(ContentManager.shared.heightOfString(pageNum, w: view.frame.width)) / Int(SettingManager.fontSize)
        lblText?.numberOfLines = lines
    }
    
}
