//
//  ContentManager.swift
//  BooksReader
//
//  Created by com on 12/31/20.
//

import Foundation
import UIKit


typealias ContentNode = [String: String]


class ContentManager {
    
    static var shared = ContentManager()
    
    var contents = [ContentNode]()
    
    
    init() {
        if let url = Bundle.main.url(forResource: "tehillim", withExtension: "json"),
           let data = try? Data(contentsOf: url)
        {
            if let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
               let contentDict = dict["data"]
            {
                contents = contentDict as! [ContentNode]
            }
        }
    }
    
    
    func stringTitle(_ indexPath: Int) -> String {
        let index = (SettingManager.languageMode == .both ? indexPath / 2 : indexPath)
        
        let dict = ContentManager.shared.contents[index]
        
        var title = ""
        
        if SettingManager.languageMode == .hebrew {
            title = dict["hebrew_chapter"] ?? ""
        } else if SettingManager.languageMode == .english {
            title = dict["english_chapter"] ?? ""
        } else if SettingManager.languageMode == .both {
            if indexPath % 2 == 0 {
                title = dict["hebrew_chapter"] ?? ""
            } else {
                title = dict["english_chapter"] ?? ""
            }
        }
        
        return title
    }
    
    
    func attributString(_ indexPath: IndexPath) -> NSAttributedString {
        let index = (SettingManager.languageMode == .both ? indexPath.row / 2 : indexPath.row)
        
        //print("getting \(SettingManager.languageMode.rawValue) text for \(index)th contents")
        
        let dict = ContentManager.shared.contents[index]
        
        var title = ""
        var content = ""
        var contentParagraph = SettingManager.hebrewParagraphStyle
        
        if SettingManager.languageMode == .hebrew {
            title = dict["hebrew_chapter"] ?? ""
            content = dict["hebrew_content"] ?? ""
            contentParagraph = SettingManager.hebrewParagraphStyle
        } else if SettingManager.languageMode == .english {
            title = dict["english_chapter"] ?? ""
            content = dict["english_content"] ?? ""
            contentParagraph = SettingManager.engParagraphStyle
        } else if SettingManager.languageMode == .both {
            if indexPath.row % 2 == 0 {
                title = dict["hebrew_chapter"] ?? ""
                content = dict["hebrew_content"] ?? ""
                contentParagraph = SettingManager.hebrewParagraphStyle
            } else {
                title = dict["english_chapter"] ?? ""
                content = dict["english_content"] ?? ""
                contentParagraph = SettingManager.engParagraphStyle
            }
        }
        
        if content.contains("א") {
            let filteringText = "׃" // filtering text
            content = content.replacingOccurrences(of: filteringText, with: ":\n\n", options: [.regularExpression, .caseInsensitive])
            
        } else {
            let filteringText = "@" // filtering text
            content = content.replacingOccurrences(of: filteringText, with: "\n\n", options: [.regularExpression, .caseInsensitive])
        }
        
        let a1 = NSAttributedString(string: title + "\n\n",
                                    attributes: [NSAttributedString.Key.font: UIFont(name: SettingManager.fontName.rawValue, size: SettingManager.fontSize * 1.5)!,
                                             NSAttributedString.Key.foregroundColor: SettingManager.txtColor,
                                             NSAttributedString.Key.paragraphStyle: SettingManager.titleParagraphStyle])
        let a2 = NSAttributedString(string: content + "",
                                attributes: [NSAttributedString.Key.font: UIFont(name: SettingManager.fontName.rawValue, size: SettingManager.fontSize)!,
                                             NSAttributedString.Key.foregroundColor: SettingManager.txtColor,
                                             NSAttributedString.Key.paragraphStyle:contentParagraph])
        
        let result = NSMutableAttributedString(attributedString: a1)
        result.append(a2)
        
        return result
    }
    
}
