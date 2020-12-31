//
//  NSAttributedString.swift
//  BooksReader
//
//  Created by com on 12/31/20.
//

import Foundation
import UIKit


extension NSAttributedString {

    func sizeFittingWidth(_ w: CGFloat) -> CGSize {
//        let textStorage = NSTextStorage(attributedString: self)
//        let size = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
//        let boundingRect = CGRect(origin: .zero, size: size)
//
//        let textContainer = NSTextContainer(size: size)
//        textContainer.lineFragmentPadding = 0
//
//        let layoutManager = NSLayoutManager()
//        layoutManager.addTextContainer(textContainer)
//
//        textStorage.addLayoutManager(layoutManager)
//
//        layoutManager.glyphRange(forBoundingRect: boundingRect, in: textContainer)
//
//        let rect = layoutManager.usedRect(for: textContainer)
//
//        return rect.integral.size
        
        
        let ts = NSTextStorage(attributedString: self)

        let size = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)

        let tc = NSTextContainer(size: size)
        tc.lineFragmentPadding = 0.0

        let lm = NSLayoutManager()
        lm.addTextContainer(tc)

        ts.addLayoutManager(lm)
        lm.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: tc)

        let rect = lm.usedRect(for: tc)

        return rect.integral.size
    }
    
}

