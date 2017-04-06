//
//  NovelDetailViewController.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/4/5.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

enum ReadMode {
    case day
    case night
    case eyes
}
class NovelDetailViewController: UIViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        self.view.addSubview(label)
        return label
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 30, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(textView)
        return textView
    }()
    
    var mode: ReadMode = .day {
        didSet{
            if mode != oldValue {
                switch mode {
                case .day:
                    textView.backgroundColor = UIColor.white
                case .eyes:
                    textView.backgroundColor = UIColor.cyan
                case .night:
                    textView.textColor = UIColor.darkGray
                    textView.backgroundColor = UIColor.black
                }
            }
        }
    }
    
    var url: String!
    convenience init(url: String) {
        self.init()
        self.url = url
    }
    
    override func viewDidLoad() {
        self.label.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(30)
        }
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Alamofire.request(url, method: .get).responseHTMLDocument { (response) in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                if let document = response.result.value {
                    self.label.text = document.xpath(".//*[@id='nr_title']").first!.stringValue
                    self.textView.text = document.firstChild(xpath: ".//*[@id='txt']")!.stringValue
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

