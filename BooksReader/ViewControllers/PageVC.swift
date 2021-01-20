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
        
        let w = view.frame.width - 45
        
        scrollView = UIScrollView(frame: CGRect(x: 15, y: 0, width: w, height: view.frame.height))
        scrollView?.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
        scrollView?.showsVerticalScrollIndicator = false
        view.addSubview(scrollView!)
        
        let h = attrTxt!.sizeFittingWidth(w).height
        scrollView?.contentSize = CGSize(width: w, height: h)
        
        lblText = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        scrollView!.addSubview(lblText!)
        
        lblText?.attributedText = attrTxt
        lblText?.numberOfLines = Int(h / SettingManager.fontSize)
        
        view.backgroundColor = SettingManager.bkColor
        
//        scrollView?.layer.borderColor = UIColor.blue.cgColor
//        scrollView?.layer.borderWidth = 1
//        lblText?.layer.borderColor = UIColor.red.cgColor
//        lblText?.layer.borderWidth = 1
    }
    
    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        lblText?.textColor = SettingManager.txtColor
        
        attrTxt = ContentManager.shared.attributContents(pageNum)
        lblText?.attributedText = attrTxt
        
        let w = view.frame.width - 45
        let h = attrTxt!.sizeFittingWidth(w).height
        
        scrollView?.contentSize = CGSize(width: w, height: h)
        
        lblText?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        lblText?.numberOfLines = Int(h / SettingManager.fontSize)
    }
    
}
