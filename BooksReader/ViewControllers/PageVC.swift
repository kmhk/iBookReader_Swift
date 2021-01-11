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
    var lblText: UILabel?
    var scrollView: UIScrollView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: view.frame.height))
        scrollView?.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        scrollView?.showsVerticalScrollIndicator = false
        view.addSubview(scrollView!)
        
        let h = ContentManager.shared.heightOfString(attrTxt, index: 0, w: scrollView!.frame.width)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: h)
        
        lblText = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView!.frame.width, height: h))
        lblText?.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        scrollView!.addSubview(lblText!)
        
        lblText?.attributedText = attrTxt
        lblText?.numberOfLines = Int(h / SettingManager.fontSize)
        
        view.backgroundColor = SettingManager.bkColor
    }
    
    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        lblText?.textColor = SettingManager.txtColor
        
        attrTxt = ContentManager.shared.attributContents(pageNum)
        lblText?.attributedText = attrTxt
        
        let lines = Int(ContentManager.shared.heightOfString(attrTxt, index: 0, w: view.frame.width)) / Int(SettingManager.fontSize)
        lblText?.numberOfLines = lines
    }
    
}
