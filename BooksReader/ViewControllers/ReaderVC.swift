//
//  ReaderVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit
import KUIPopOver
import VerticalSlider
import AnimatedCollectionViewLayout


protocol ReaderViewControllerDelegate {
    func chosenMode()
    func seekToChapter(_ index: Int)
}


class ReaderVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewSliderStatus: UILabel!
    @IBOutlet weak var slider: VerticalSlider!
    @IBOutlet weak var horzSlider: UISlider!
    
    
    override var prefersStatusBarHidden: Bool {
        return (SettingManager.readMode == .fullscreen ? true : false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add navigation buttons
        let listBtn = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(navBtnListTapped(_:)))
        let settingBtn = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(navBtnSettingTapped(_:)))
        
        navigationItem.leftBarButtonItem = listBtn
        navigationItem.rightBarButtonItem = settingBtn
        
        // init tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        slider.maximumValue = Float(ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1))
        slider.minimumValue = 1
        
        horzSlider.maximumValue = Float(ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1))
        horzSlider.minimumValue = 1
        
        setStatusView(0)
        
        viewSliderStatus.rounded(radius: 10)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configUI()
    }
    
    
    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = SettingManager.bkColor
        
        if let v = viewStatus.viewWithTag(100) as? UILabel {
            v.textColor = SettingManager.txtColor
            viewStatus.backgroundColor = SettingManager.bkColor
        }
        
        slider.maximumTrackTintColor = UIColor(hex: "#A8A8A8FF")
        slider.minimumTrackTintColor = SettingManager.toolColor
        slider.slider.setThumbImage(createThumbImage(), for: .normal)
        slider.maximumValue = Float(ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1))
        
        horzSlider.maximumTrackTintColor = UIColor(hex: "#A8A8A8FF")
        horzSlider.minimumTrackTintColor = SettingManager.toolColor
        horzSlider.setThumbImage(createThumbImage(), for: .normal)
        horzSlider.maximumValue = Float(ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1))
        
        viewSliderStatus.textColor = .white
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        if SettingManager.scrollMode == .vert {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            collectionView.collectionViewLayout = layout
            collectionView.isPagingEnabled = false
            collectionView.showsVerticalScrollIndicator = false
            
            slider.isHidden = false
            horzSlider.isHidden = true
            
        } else {
            let layout = AnimatedCollectionViewLayout()
            layout.animator = PagniationAttributesAnimator()
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            
            slider.isHidden = true
            horzSlider.isHidden = false
        }
        
        collectionView.reloadData()
    }
    
    
    func createThumbImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 8, height: 8))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(SettingManager.toolColor.cgColor)
        context?.fillEllipse(in: CGRect(x: 0, y: 0, width: 8, height: 8))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    

    // MARK: actions
    
    @objc func navBtnListTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ListVC") as? ListVC else { return }
        
        vc.delegate = self
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @objc func navBtnSettingTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC else { return }
        vc.delegate = self
        vc.showPopoverWithNavigationController(barButtonItem: sender, shouldDismissOnTap: true)
    }
    
    
    @objc func tapGestureHandler(_ sender: Any) {
        changeReadMode()
    }

    
    @IBAction func sliderValueChanged(_ sender: Any) {
//        print("value changed slider: page = \(page)")
        var page = 0
        if SettingManager.scrollMode == .vert {
            page = Int(slider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            slider.value = Float(page)
        }
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page - 1)
        collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: (SettingManager.scrollMode == .vert ? .top : .left), animated: false)
        setStatusView(page)
    }
    
    
    @IBAction func sliderDragEnter(_ sender: Any) {
//        print("enter to slider drag: page = \(page)")
        var page = 0
        if SettingManager.scrollMode == .vert {
            page = Int(slider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            slider.value = Float(page)
        }
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page)
        collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: (SettingManager.scrollMode == .vert ? .top : .left), animated: false)
        setStatusView(page)
        
        if viewSliderStatus.isHidden == false {
            return
        }
        
        viewSliderStatus.isHidden = false
        viewSliderStatus.alpha = 0.0
        UIView.animate(withDuration: 0.1) {
            self.viewSliderStatus.alpha = 1.0
        }
    }
    
    
    @IBAction func sliderDragExit(_ sender: Any) {
        var page = 0
        if SettingManager.scrollMode == .vert {
            page = Int(slider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            slider.value = Float(page)
        }
//        print("exit from slider drag: page = \(page)")
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page)
        collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: (SettingManager.scrollMode == .vert ? .top : .left), animated: false)
        setStatusView(page)
        
        if viewSliderStatus.isHidden == true {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.viewSliderStatus.alpha = 0.0
        } completion: { (flage) in
            self.viewSliderStatus.isHidden = true
        }
    }
    
    
    // MARK: methods
    
    func changeReadMode() {
        if SettingManager.changeReadMode() == .fullscreen {
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 0.0
                self.viewStatus.alpha = 0
                self.viewSliderStatus.alpha = 0
                
                if SettingManager.scrollMode == .vert {
                    self.slider.alpha = 0
                }
                
            } completion: { (finished) in
                self.navigationController?.navigationBar.isHidden = true
                self.viewStatus.isHidden = true
                self.viewSliderStatus.isHidden = true
                
                if SettingManager.scrollMode == .vert {
                    self.slider.isHidden = true
                }
                
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
        } else {
            navigationController?.navigationBar.alpha = 0.0
            self.viewStatus.alpha = 0
            self.viewSliderStatus.alpha = 0
            
            if SettingManager.scrollMode == .vert {
                self.slider.alpha = 0
            }
            
            navigationController?.navigationBar.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 1.0
                self.viewStatus.alpha = 1.0
                self.viewSliderStatus.alpha = 0.0
                
                if SettingManager.scrollMode == .vert {
                    self.slider.alpha = 1.0
                }
                
            } completion: { (finished) in
                self.navigationController?.navigationBar.alpha = 1.0
                self.navigationController?.navigationBar.isHidden = false
                self.viewStatus.isHidden = false
                self.viewSliderStatus.isHidden = true
                
                if SettingManager.scrollMode == .vert {
                    self.slider.isHidden = false
                }
                
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    
    func setStatusView(_ page: Int) {
        let max = ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1)
        let pageNum = page + 1
        
        if let v = viewStatus.viewWithTag(100) as? UILabel {
            v.text = "\(pageNum) of \(max)"
        }
    }
    
    
    //func showSliderStatus
}


// MARK: - UICollectionView data source & delegate
extension ReaderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func heightOfString(_ indexPath: IndexPath) -> CGFloat {
        let w = collectionView.frame.width // width of title label
        let str = ContentManager.shared.attributString(indexPath)
        return str.sizeFittingWidth(w).height
//        let constBox = CGSize(width: w, height: .greatestFiniteMagnitude)
//        let rt = str.boundingRect(with: constBox, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).integral
//        return rt.height + 50
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ContentManager.shared.contents.count * (SettingManager.languageMode == .both ? 2 : 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCVCell", for: indexPath) as! PageCVCell
        
        let text = ContentManager.shared.attributString(indexPath)
        
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("didEndDecelerating collectionView")
        
        let indices = collectionView.indexPathsForVisibleItems
        if let page = indices.first {
            setStatusView(page.row)
            slider.value = Float(page.row + 1)
            horzSlider.value = Float(page.row + 1)
        } else {
            setStatusView(0)
            slider.value = 1
            horzSlider.value = 0
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("didEndDragging collectionView")
        
        let indices = collectionView.indexPathsForVisibleItems
        if let page = indices.first {
            setStatusView(page.row)
            slider.value = Float(page.row + 1)
        } else {
            setStatusView(0)
            slider.value = 1
        }
    }
    
}


// MARK: - ReaderViewController delegate
extension ReaderVC: ReaderViewControllerDelegate {
    
    func chosenMode() {
        configUI()
    }
    
    
    func seekToChapter(_ index: Int) {
//        print("choose to \(index)th page")
        
        //tableView.layoutIfNeeded()
        DispatchQueue.main.async { [self] in
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: (SettingManager.scrollMode == .vert ? .top : .left), animated: true)
        }
        slider.value = Float(index + 1)
        setStatusView(index)
        //sliderValueChanged(slider as Any)
    }
    
}
