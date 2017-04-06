//
//  ViewController.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/3/21.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import UIKit
import Fuzi
import Alamofire
import SVProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: ELSegmentView!
    
    var dataSource:[Book] = []
    var didSelect: (Book) -> () = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        segmentView.titles = ["日排行","周排行","月排行","总排行"]
        segmentView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Alamofire.request(Router.loadDayList).responseHTMLDocument { [weak self] (response) in
            SVProgressHUD.dismiss(withDelay: 0.4)
            switch response.result {
            case .success(let value):
//                print(value)
                self?.dataSource = Book.creatBooks(from: value)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].name + dataSource[indexPath.row].category + dataSource[indexPath.row].author!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(dataSource[indexPath.row])
    }

}

extension ViewController: ELSegmentViewDelegate {
    func segmentView(_ segmentView: ELSegmentView, didSelectRowAt index: Int) {
        SVProgressHUD.show()
        let req: Router
        switch index {
        case 0:
            req = Router.loadDayList
        case 1:
            req = Router.loadWeekList
        case 2:
            req = Router.loadMonthList
        case 3:
            req = Router.loadAllList
        case _:
            req = Router.loadAllList
            print("error selected")
        }
        Alamofire.request(req).responseHTMLDocument { [weak self] (response) in
            SVProgressHUD.dismiss(withDelay: 0.4)
            switch response.result {
            case .success(let value):
                self?.dataSource = Book.creatBooks(from: value)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

