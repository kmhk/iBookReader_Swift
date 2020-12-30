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


class SettingManager {
    
    static var shared = SettingManager()
    
    static var theme: ThemeStyle = .theme1
    
    static var bkColor = UIColor.white
    static var txtColor = UIColor.black
    
    static var readMode: ReadMode = .normal
    
    
    static func changeReadMode() -> ReadMode {
        if readMode == .normal {
            readMode = .fullscreen
        } else {
            readMode = .normal
        }
        
        return readMode
    }
    
}

