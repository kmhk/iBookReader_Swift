//
//  PageModeVC.swift
//  BooksReader
//
//  Created by com on 1/6/21.
//

import UIKit

class PageModeVC: UIPageViewController {
    
    var readerDelegate: ReaderViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        let vc = PageVC()
        vc.pageNum = 0
        vc.attrTxt = ContentManager.shared.attributContents(vc.pageNum)
        vc.lines = Int(ContentManager.shared.heightOfString(vc.pageNum, w: view.frame.width)) / Int(SettingManager.fontSize)
        
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    
    func configUI() {
        view.backgroundColor = SettingManager.bkColor
        
        if let vcs = viewControllers as? [PageVC] {
            for vc in vcs {
                vc.configUI()
            }
        }
    }
    
    
    func pageTo(_ page: Int) {
        let vc = PageVC()
        vc.pageNum = page
        vc.attrTxt = ContentManager.shared.attributContents(vc.pageNum)
        vc.lines = Int(ContentManager.shared.heightOfString(vc.pageNum, w: view.frame.width)) / Int(SettingManager.fontSize)
        
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func getPrevPage(_ cur: PageVC) -> PageVC? {
        guard cur.pageNum > 0 else { return nil }
        
        let vc = PageVC()
        vc.pageNum = cur.pageNum - 1
        vc.attrTxt = ContentManager.shared.attributContents(vc.pageNum)
        vc.lines = Int(ContentManager.shared.heightOfString(vc.pageNum, w: view.frame.width)) / Int(SettingManager.fontSize)
        
        readerDelegate?.didPage(vc.pageNum)
        
        return vc
    }
    
    
    private func getNextPage(_ cur: PageVC) -> PageVC? {
        guard cur.pageNum < ContentManager.shared.contents.count - 1 else { return nil }
        
        let vc = PageVC()
        vc.pageNum = cur.pageNum + 1
        vc.attrTxt = ContentManager.shared.attributContents(vc.pageNum)
        vc.lines = Int(ContentManager.shared.heightOfString(vc.pageNum, w: view.frame.width)) / Int(SettingManager.fontSize)
        
        readerDelegate?.didPage(vc.pageNum)
        
        return vc
    }
    
}


// MARK: - extension UIPageView data source & delegate
extension PageModeVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let cur = viewController as? PageVC else { return nil }
        
        if SettingManager.languageMode == .hebrew {
            guard let vc = getNextPage(cur) else { return nil }
            readerDelegate?.didPage(vc.pageNum)
            return vc
            
        } else {
            guard let vc = getPrevPage(cur) else { return nil }
            readerDelegate?.didPage(vc.pageNum)
            return vc
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let cur = viewController as? PageVC else { return nil }
        
        if SettingManager.languageMode == .hebrew {
            guard let vc = getPrevPage(cur) else { return nil }
            readerDelegate?.didPage(vc.pageNum)
            return vc
            
        } else {
            guard let vc = getNextPage(cur) else { return nil }
            readerDelegate?.didPage(vc.pageNum)
            return vc
        }
    }
    
}
