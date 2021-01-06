//
//  ScrollModeVC.swift
//  BooksReader
//
//  Created by com on 1/6/21.
//

import UIKit

class ScrollModeVC: UICollectionViewController {
    
    var readerDelegate: ReaderViewControllerDelegate?
    

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
        collectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .top, animated: false)
    }
    
}


// MARK: - UICollectionView data source & delegate
extension ScrollModeVC: UICollectionViewDelegateFlowLayout {
    
    func heightOfString(_ indexPath: IndexPath) -> CGFloat {
        let w = collectionView.frame.width // width of title label
        let str = ContentManager.shared.attributContents(indexPath.row)
        return str.sizeFittingWidth(w).height
//        let constBox = CGSize(width: w, height: .greatestFiniteMagnitude)
//        let rt = str.boundingRect(with: constBox, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral
//        return rt.height + 50
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCVCell", for: indexPath) as! PageCVCell
        
        let text = ContentManager.shared.attributContents(indexPath.row)
        
        cell.lblText.attributedText = text
        cell.lblText.numberOfLines = Int(heightOfString(indexPath)) / Int(SettingManager.fontSize)
        
        cell.backgroundColor = SettingManager.bkColor
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = heightOfString(indexPath) + 50
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
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("didEndDecelerating collectionView")

        let indices = collectionView.indexPathsForVisibleItems
        if let page = indices.last {
            readerDelegate?.didScroll(page.row)
//            setStatusView(page.row)
//            slider.value = Float(page.row + 1)
//            horzSlider.value = Float(page.row + 1)
        } else {
            readerDelegate?.didScroll(0)
//            setStatusView(0)
//            slider.value = 1
//            horzSlider.value = 0
        }
    }


    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("didEndDragging collectionView")

        let indices = collectionView.indexPathsForVisibleItems
        if let page = indices.last {
            readerDelegate?.didScroll(page.row)
        } else {
            readerDelegate?.didScroll(0)
        }
    }
    
}
