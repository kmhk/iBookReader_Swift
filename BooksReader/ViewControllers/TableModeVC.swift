//
//  TableModeVC.swift
//  BooksReader
//
//  Created by com on 1/18/21.
//

import UIKit

class TableModeVC: UITableViewController {
    
    var readerDelegate: ReaderViewControllerDelegate?
    
    var curPage: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        tableView.reloadData()
    }
    
    
    func scrollTo(_ page: Int) {
        curPage = page
//        isScrolled = false
        
        tableView.scrollToRow(at: IndexPath(row: page + 2, section: 0), at: .top, animated: false)
    }
    

    // MARK: - Table view data source
    
    func heightOfString(_ indexPath: IndexPath) -> CGFloat {
        let w = tableView.frame.width - 45 // width of title label
        let str = ContentManager.shared.attributContents(indexPath.row)
        return str.sizeFittingWidth(w).height
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageTVCell", for: indexPath) as! PageTVCell
        
        let text = ContentManager.shared.attributContents(indexPath.row)
        
        cell.lblTxt.attributedText = text
        cell.lblTxt.numberOfLines = Int(heightOfString(indexPath)) / Int(SettingManager.fontSize)
//        cell.lblText.layer.borderColor = UIColor.blue.cgColor
//        cell.lblText.layer.borderWidth = 1
        
        cell.backgroundColor = SettingManager.bkColor
        
//        print("cell index: \(indexPath.row)\ntext:\n\(text.string)")
//
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = heightOfString(indexPath) + 20
        return h
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if isScrolled == false {
//            isScrolled = true
//            return
//        }
        
        guard let indices = tableView.indexPathsForVisibleRows else { return }
        if indices.count == 1 {
            let page = indices[0]
            curPage = page.row
            readerDelegate?.didScroll(page.row)
            
        } else if indices.count > 1 {
            var a1: Int = 0
            var y1: CGFloat = 0
            for i in 0..<indices.count {
                let indexPath = indices[i]
                let orgRect = tableView.rectForRow(at: indexPath)
                let scnRect = tableView.convert(orgRect, to: tableView.superview)
                
                if scnRect.minY < tableView.frame.midY && (y1 < scnRect.minY || y1 == 0) && scnRect.maxY > 0 {
                    y1 = scnRect.minY
                    a1 = i
                }
                
//                print("showing index: \(indexPath.row), minY: \(scnRect.minY) ----- midY: \(collectionView.frame.midY)")
            }
            
            let page = indices[a1]
            curPage = page.row
            readerDelegate?.didScroll(page.row)
            
        }/* else {
            print("*** Logic Error for scrolling...")
            curPage = 0
            readerDelegate?.didScroll(0)
        }*/
    }

}
