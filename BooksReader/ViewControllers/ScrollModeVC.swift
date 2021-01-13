//
//  ScrollModeVC.swift
//  BooksReader
//
//  Created by com on 1/6/21.
//

import UIKit

class ScrollModeVC: UICollectionViewController {
    
    var readerDelegate: ReaderViewControllerDelegate?
    
    var curPage: Int = 0
    var isScrolled: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.showsVerticalScrollIndicator = false
    }

    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        collectionView.reloadData()
    }
    
    
    func scrollTo(_ page: Int) {
        curPage = page
        isScrolled = false
        
        collectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .top, animated: false)
    }
    
}


// MARK: - UICollectionView data source & delegate
extension ScrollModeVC: UICollectionViewDelegateFlowLayout {
    
    func heightOfString(_ indexPath: IndexPath) -> CGFloat {
        let w = collectionView.frame.width - 45 // width of title label
        let str = ContentManager.shared.attributContents(indexPath.row)
        return str.sizeFittingWidth(w).height
//        let constBox = CGSize(width: w, height: .greatestFiniteMagnitude)
//        let rt = str.boundingRect(with: constBox, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral
//        return rt.height + 50
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count - 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCVCell", for: indexPath) as! PageCVCell
        
        let text = ContentManager.shared.attributContents(indexPath.row)
        
        cell.lblText.attributedText = text
        cell.lblText.numberOfLines = Int(heightOfString(indexPath)) / Int(SettingManager.fontSize)
//        cell.lblText.layer.borderColor = UIColor.blue.cgColor
//        cell.lblText.layer.borderWidth = 1
        
        cell.backgroundColor = SettingManager.bkColor
        
//        print("cell index: \(indexPath.row)\ntext:\n\(text.string)")
//
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = heightOfString(indexPath) + 20
        return CGSize(width: collectionView.frame.width, height: h)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrolled == false {
            isScrolled = true
            return
        }
        
        let indices = collectionView.indexPathsForVisibleItems
        if indices.count == 1 {
            let page = indices[0]
            curPage = page.row
            readerDelegate?.didScroll(page.row)
            
        } else if indices.count > 1 {
            var a1: Int = 0
            var y1: CGFloat = 0
            for i in 0..<indices.count {
                let indexPath = indices[i]
                let orgRect = collectionView.layoutAttributesForItem(at: indexPath)!.frame
                let scnRect = collectionView.convert(orgRect, to: collectionView.superview)
                
                if scnRect.minY < collectionView.frame.midY && (y1 < scnRect.minY || y1 == 0) && scnRect.maxY > 0 {
                    y1 = scnRect.minY
                    a1 = i
                }
                
//                print("showing index: \(indexPath.row), minY: \(scnRect.minY) ----- midY: \(collectionView.frame.midY)")
            }
            
            let page = indices[a1]
            curPage = page.row
            readerDelegate?.didScroll(page.row)
            
        } else {
            print("*** Logic Error for scrolling...")
            curPage = 0
            readerDelegate?.didScroll(0)
        }
    }
    
}
