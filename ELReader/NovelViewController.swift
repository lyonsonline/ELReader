//
//  NovelViewController.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/3/31.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NovelViewController: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var topToolBar: UIView!
    @IBOutlet weak var bottomToolBar: UIView!
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("换源")
        case 1:
            print("章节")
        case 2:
            if mode == .day {
                mode = .night
            } else {
                mode = .day
            }
        case 3:
            print("设置")
        default:
            break
        }
    }
    var didTapClose: () -> () = {}
    @IBAction func close(_ sender: Any) {
        didTapClose()
    }
    var mode: ReadMode = .day {
        didSet {
            guard let vc = pageViewController.viewControllers?.first as? NovelDetailViewController else {
                return
            }
            vc.mode = mode
        }
    }
    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = self.view.bounds
        pageViewController.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    var book: Book!
    override func viewDidLoad() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.isNavigationBarHidden = true
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0)
        self.pageViewController.didMove(toParentViewController: self)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundClick(_:))))
        loadCatalogue()
    }
    func backgroundClick(_ sender: Any) {
        self.header.text = self.book.name
        
        self.topToolBar.isHidden = !self.topToolBar.isHidden
        self.bottomToolBar.isHidden = !self.bottomToolBar.isHidden
        // 使状态栏的文字颜色重新刷新
        self.setNeedsStatusBarAppearanceUpdate()
    }
    func loadCatalogue() {
        SVProgressHUD.show()
        var catalogues = [(uri: String, title: String)]()
        Alamofire.request(self.book.catalogueURL(), method: .get).responseHTMLDocument { (response) in
            switch response.result {
            case .success:
                let doc = response.result.value!.firstChild(css: ".mulu_list")!.children
                for children in doc {
                    if let aElement = children.firstChild(tag: "a") {
                        catalogues.append((aElement["href"]!, aElement.stringValue))
                    }
                }
                self.book.catalogues = catalogues
                let vc = NovelDetailViewController(url: self.book.chapterURL(index: 0))
                self.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return self.topToolBar == nil ? true : self.topToolBar.isHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
extension NovelViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.book.currentChapterNumber == 0 {
            return nil
        } else {
            self.book.currentChapterNumber -= 1
        }
        return NovelDetailViewController(url: self.book.chapterURL(), mode: mode)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.book.currentChapterNumber == self.book.catalogues!.count - 1 {
            return nil
        } else {
            self.book.currentChapterNumber += 1
        }
        return NovelDetailViewController(url: self.book.chapterURL(), mode: mode)
    }
}
