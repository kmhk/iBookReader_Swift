//
//  SettingManager.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import Foundation
import UIKit


enum ThemeStyle: Int {
    case theme1 = 0
    case theme2
    case theme3
    case theme4
}


enum ReadMode: Int {
    case fullscreen = 0
    case normal
}


enum ScrollMode: Int {
    case vert = 0
    case horz
}


enum LanguageMode: String, CaseIterable {
    case hebrew = "Hebrew"
    case english = "English"
    case both = "Hebrew / English"
}


enum FontName: String, CaseIterable {
    case helvetica = "Helvetica"
    case avenir = "Avenir"
    case charter = "Charter"
    case georgia = "Georgia"
    case palatino = "Palatino"
    case roman = "Times New Roman"
}


class SettingManager {
    
    static var shared = SettingManager()
    
    static var theme: ThemeStyle = .theme1
    
    static var bkColor = UIColor.white
    static var toolColor = UIColor.black
    static var txtColor = UIColor.black
    
    static var readMode: ReadMode = .normal
    
    static var scrollMode: ScrollMode = .vert
    
    static var languageMode: LanguageMode = .english
    
    static var fontSize: CGFloat = 21
    static var fontName: FontName = .helvetica
    
    static var titleParagraphStyle: NSMutableParagraphStyle = {
        let p = NSMutableParagraphStyle()
        p.alignment = .center
        p.lineBreakMode = .byWordWrapping
        p.lineSpacing = 2
        return p
    }()
    
    static var hebrewParagraphStyle: NSMutableParagraphStyle = {
        let p = NSMutableParagraphStyle()
        p.alignment = .right
        p.lineBreakMode = .byWordWrapping
        p.lineSpacing = 2
        return p
    }()
    
    static var engParagraphStyle: NSMutableParagraphStyle = {
        let p = NSMutableParagraphStyle()
        p.alignment = .left
        p.lineBreakMode = .byWordWrapping
        p.lineSpacing = 2
        return p
    }()
    
    
    static func changeReadMode() -> ReadMode {
        if readMode == .normal {
            readMode = .fullscreen
        } else {
            readMode = .normal
        }
        
        return readMode
    }
    
    
    static func changeTheme(_ new: ThemeStyle) {
        theme = new
        
        switch theme {
        case .theme1:
            bkColor = .white
            toolColor = .black
            txtColor = .black
            
        case .theme2:
            bkColor = UIColor(hex: "#fff9ecff")!
            toolColor = UIColor(hex: "#c79832ff")!
            txtColor = .black
            
        case .theme3:
            bkColor = UIColor(hex: "#4d4d4fff")!
            toolColor = .white
            txtColor = .white
            
        case .theme4:
            bkColor = .black
            toolColor = .white
            txtColor = .white
        }
    }
    
}

