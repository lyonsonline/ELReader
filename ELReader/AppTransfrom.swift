//
//  AppTransfrom.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/4/5.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import UIKit

final class AppTransform {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController: UINavigationController
    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        let vc = navigationController.viewControllers[0] as! ViewController
        vc.didSelect = showNovel
    }
    func showNovel(_ book: Book) {
        let novelVC = storyboard.instantiateViewController(withIdentifier: "NovelVC") as! NovelViewController
        novelVC.book = book
        novelVC.didTapClose = {
            self.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(novelVC, animated: true)
    }
}
