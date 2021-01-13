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
        var index = indexPath
        
        if index >= contents.count {
            index = contents.count - 1
        }
        
        let dict = ContentManager.shared.contents[index]
        
        var title = ""
        
        if SettingManager.languageMode == .hebrew {
            title = dict["hebrew_chapter"] ?? ""
        } else if SettingManager.languageMode == .english {
            title = dict["english_chapter"] ?? ""
        } else if SettingManager.languageMode == .both {
            title = (dict["hebrew_chapter"] ?? "") + " " + (dict["english_chapter"] ?? "")
        }
        
        return title
    }
    
    
    func heightOfString(_ attributString: NSAttributedString? = nil, index: Int, w: CGFloat) -> CGFloat {
        var str = attributString
        if str == nil {
            str = ContentManager.shared.attributContents(index)
        }
        return str!.sizeFittingWidth(w).height
    }
    
    
    func attributContents(_ indexPath: Int) -> NSAttributedString {
        let index = indexPath
        
        let dict = ContentManager.shared.contents[index]
        
        var title = ""
        var content = ""
        var contentParagraph = SettingManager.hebrewParagraphStyle
        var result: NSAttributedString?
        
        if SettingManager.languageMode == .hebrew {
            title = dict["hebrew_chapter"] ?? ""
            content = dict["hebrew_content"] ?? ""
            contentParagraph = SettingManager.hebrewParagraphStyle
            result = getAttributeText(title, contentString: content, paragraph: contentParagraph)
            
        } else if SettingManager.languageMode == .english {
            title = dict["english_chapter"] ?? ""
            content = dict["english_content"] ?? ""
            contentParagraph = SettingManager.engParagraphStyle
            result = getAttributeText(title, contentString: content, paragraph: contentParagraph)
            
        } else { // if SettingManager.languageMode == .both
            let title1 = dict["hebrew_chapter"] ?? ""
            let content1 = dict["hebrew_content"] ?? ""
            let contentParagraph1 = SettingManager.hebrewParagraphStyle
            let hebrew = getAttributeText(title1, contentString: content1, paragraph: contentParagraph1)
            
            let title2 = dict["english_chapter"] ?? ""
            let content2 = dict["english_content"] ?? ""
            let contentParagraph2 = SettingManager.engParagraphStyle
            let eng = getAttributeText(title2, contentString: content2, paragraph: contentParagraph2)
            
            let res = NSMutableAttributedString(attributedString: hebrew)
            res.append(eng)
            result = res
        }
        
        if index == ContentManager.shared.contents.count - 2 {
            let lastAttr = attributContents(index + 1)
            
            let res = NSMutableAttributedString(attributedString: result!)
            res.append(lastAttr)
            return res
        }
        
        return result!
    }
    
    
    private func getAttributeText(_ title: String, contentString: String, paragraph: NSParagraphStyle) -> NSAttributedString {
        var content = contentString
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
        let a2 = NSAttributedString(string: content + "\n",
                                attributes: [NSAttributedString.Key.font: UIFont(name: SettingManager.fontName.rawValue, size: SettingManager.fontSize)!,
                                             NSAttributedString.Key.foregroundColor: SettingManager.txtColor,
                                             NSAttributedString.Key.paragraphStyle:paragraph])
        
        let result = NSMutableAttributedString(attributedString: a1)
        result.append(a2)
        
        return result
    }
    
}
