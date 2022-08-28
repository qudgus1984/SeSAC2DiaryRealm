//
//  TabBarController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/28.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let vc1 = DiaryViewController()
        let vc2 = HomeViewController()
        let vc3 = WriteViewController()
        
        vc1.title = "Diary"
        vc2.title = "Search"
        vc3.title = "Setting"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        setViewControllers([nav1, nav2, nav3], animated: false)
        
        
    }
}
