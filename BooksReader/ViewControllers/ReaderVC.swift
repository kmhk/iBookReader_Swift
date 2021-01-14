//
//  ReaderVC.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import UIKit
import KUIPopOver
import VerticalSlider


protocol ReaderViewControllerDelegate {
    func chosenMode()
    func seekToPage(_ page: Int)
    func didScroll(_ page: Int)
    func didPage(_ page: Int)
}


class ReaderVC: UIViewController {
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewSliderStatus: UILabel!
    @IBOutlet weak var vertSlider: VerticalSlider!
    @IBOutlet weak var horzSlider: UISlider!
    
    @IBOutlet weak var scrollModeView: UIView!
    var scrollModeVC: ScrollModeVC?
    
    @IBOutlet weak var pageModeView: UIView!
    var pageModeVC: PageModeVC?
    
    
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
        
        vertSlider.maximumValue = Float(ContentManager.shared.contents.count - 1)
        vertSlider.minimumValue = 1
        
        horzSlider.maximumValue = Float(ContentManager.shared.contents.count - 1)
        horzSlider.minimumValue = 1
        
        setStatusView(0)
        
        viewSliderStatus.rounded(radius: 10)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configUI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageModeVC {
            pageModeVC = vc
            pageModeVC?.readerDelegate = self
            return
        } else if let vc = segue.destination as? ScrollModeVC {
            scrollModeVC = vc
            scrollModeVC?.readerDelegate = self
            return
        }
    }
    
    
    // MARK: config methods
    
    func configUI() {
        navigationController?.navigationBar.barTintColor = SettingManager.bkColor
        navigationController?.navigationBar.tintColor = SettingManager.toolColor
        //navigationController?.navigationBar.isTranslucent = false
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        view.backgroundColor = SettingManager.bkColor
        
        if let v = viewStatus.viewWithTag(100) as? UILabel {
            v.textColor = SettingManager.txtColor
            viewStatus.backgroundColor = SettingManager.bkColor
        }
        
        vertSlider.maximumTrackTintColor = UIColor(hex: "#A8A8A8FF")
        vertSlider.minimumTrackTintColor = SettingManager.toolColor
        vertSlider.slider.setThumbImage(createThumbImage(), for: .normal)
        vertSlider.slider.setMinimumTrackImage(createTrackImage(), for: .normal)
        vertSlider.slider.setMaximumTrackImage(createTrackImage(), for: .normal)
        vertSlider.maximumValue = Float(ContentManager.shared.contents.count - 1)
        
        horzSlider.maximumTrackTintColor = UIColor(hex: "#A8A8A8FF")
        horzSlider.minimumTrackTintColor = SettingManager.toolColor
        horzSlider.setThumbImage(createThumbImage(), for: .normal)
        horzSlider.setMinimumTrackImage(createTrackImage(), for: .normal)
        horzSlider.setMaximumTrackImage(createTrackImage(), for: .normal)
        horzSlider.maximumValue = Float(ContentManager.shared.contents.count - 1)
        //horzSlider.transform = horzSlider.transform.rotated(by: (SettingManager.languageMode == .hebrew ? CGFloat.pi : 0))
        horzSlider.transform = (SettingManager.languageMode == .english ? CGAffineTransform.identity : CGAffineTransform.identity.rotated(by: CGFloat.pi))
        
        viewSliderStatus.textColor = .white
        
        scrollModeView.isHidden = (SettingManager.scrollMode == .horz)
        vertSlider.isHidden = (SettingManager.scrollMode == .horz)
        
        pageModeView.isHidden = (SettingManager.scrollMode == .vert)
        horzSlider.isHidden = (SettingManager.scrollMode == .vert)
        
        self.pageModeView.frame = (SettingManager.readMode == .normal ?
                                    CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.minX,
                                    y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                    width: self.view.safeAreaLayoutGuide.layoutFrame.width,
                                    height: view.bounds.height - self.view.safeAreaLayoutGuide.layoutFrame.minY - viewStatus.frame.height)
                                    :
                                    view.bounds)
        self.scrollModeView.frame = (SettingManager.readMode == .normal ?
                                        CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.minX,
                                        y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                        width: self.view.safeAreaLayoutGuide.layoutFrame.width,
                                        height: view.bounds.height - self.view.safeAreaLayoutGuide.layoutFrame.minY - viewStatus.frame.height)
                                        :
                                        view.bounds)
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
    
    
    func createTrackImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 2, height: 2))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.lightGray.cgColor)
        context?.fillEllipse(in: CGRect(x: 0, y: 0, width: 2, height: 2))
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
//        changeReadMode()
        changeScreenMode()
    }

    
    @IBAction func sliderValueChanged(_ sender: Any) {
//        print("value changed slider: page = \(page)")
        var page = 0
        if SettingManager.scrollMode == .vert {
            page = Int(vertSlider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            vertSlider.value = Float(page)
        }
        
        pageModeVC?.pageTo(page - 1)
        scrollModeVC?.scrollTo(page - 1)
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page - 1)
        setStatusView(page - 1)
    }
    
    
    @IBAction func sliderDragEnter(_ sender: Any) {
//        print("enter to slider drag: page = \(page)")
        var page = 0
        if SettingManager.scrollMode == .vert {
            page = Int(vertSlider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            vertSlider.value = Float(page)
        }
        
        pageModeVC?.pageTo(page - 1)
        scrollModeVC?.scrollTo(page - 1)
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page)
        setStatusView(page - 1)
        
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
            page = Int(vertSlider.value)
            horzSlider.value = Float(page)
        } else {
            page = Int(horzSlider.value)
            vertSlider.value = Float(page)
        }
//        print("exit from slider drag: page = \(page)")
        
        viewSliderStatus.text = ContentManager.shared.stringTitle(page)
        setStatusView(page - 1)
        
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
    
    func changeScreenMode() {
        if SettingManager.changeReadMode() == .fullscreen {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
            
            UIView.animate(withDuration: 0.2) {
                self.viewStatus.alpha = 0
                self.viewSliderStatus.alpha = 0
                
                self.pageModeView.frame = self.view.bounds
                self.scrollModeView.frame = self.view.bounds
                
                if SettingManager.scrollMode == .vert {
                    self.vertSlider.alpha = 0
                }
            } completion: { (flat) in
                self.viewStatus.isHidden = true
                self.viewSliderStatus.isHidden = true
                
                if SettingManager.scrollMode == .vert {
                    self.vertSlider.isHidden = true
                }
            }
            
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.setNeedsStatusBarAppearanceUpdate()
            
            self.viewStatus.isHidden = false
            self.viewStatus.alpha = 0
            
            self.viewSliderStatus.isHidden = false
            self.viewSliderStatus.alpha = 0
            
            if SettingManager.scrollMode == .vert {
                self.vertSlider.isHidden = false
                self.vertSlider.alpha = 0
            }
            
            UIView.animate(withDuration: 0.2) {
                self.viewStatus.alpha = 1.0
                self.viewSliderStatus.alpha = 0.0
                
                if SettingManager.scrollMode == .vert {
                    self.vertSlider.alpha = 1.0
                }
                
                self.pageModeView.frame = CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.minX,
                                                 y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                                 width: self.view.safeAreaLayoutGuide.layoutFrame.width,
                                                 height: self.view.bounds.height - self.view.safeAreaLayoutGuide.layoutFrame.minY - self.viewStatus.frame.height)
                self.scrollModeView.frame = CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.minX,
                                                 y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                                 width: self.view.safeAreaLayoutGuide.layoutFrame.width,
                                                 height: self.view.bounds.height - self.view.safeAreaLayoutGuide.layoutFrame.minY - self.viewStatus.frame.height)
                
            } completion: { (flag) in
                
            }
        }
    }
    
    
    func setStatusView(_ page: Int) {
        let max = ContentManager.shared.contents.count - 1
        let pageNum = page + 1
        
        if let v = viewStatus.viewWithTag(100) as? UILabel {
            v.text = "\(pageNum) of \(max)"
        }
    }
    
    
    //func showSliderStatus
}


// MARK: - ReaderViewController delegate
extension ReaderVC: ReaderViewControllerDelegate {
    
    func chosenMode() {
        configUI()
        scrollModeVC?.configUI()
        pageModeVC?.configUI()
    }
    
    
    func didScroll(_ page: Int) {
        guard pageModeVC!.curPage != page else { return }
        
        vertSlider.value = Float(page + 1)
        horzSlider.value = Float(page + 1)
        setStatusView(page)
        pageModeVC?.pageTo(page)
    }
    
    
    func didPage(_ page: Int) {
        guard scrollModeVC!.curPage != page else { return }
        
        vertSlider.value = Float(page + 1)
        horzSlider.value = Float(page + 1)
        setStatusView(page)
        scrollModeVC?.scrollTo(page)
    }
    
    
    func seekToPage(_ page: Int) {
//        print("choose to \(index)th page")
        vertSlider.value = Float(page + 1)
        horzSlider.value = Float(page + 1)
        setStatusView(page)
        scrollModeVC?.scrollTo(page)
        pageModeVC?.pageTo(page)
        
        //tableView.layoutIfNeeded()
//        DispatchQueue.main.async { [self] in
//            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: (SettingManager.scrollMode == .vert ? .top : .left), animated: true)
//        }
        
    }

}
