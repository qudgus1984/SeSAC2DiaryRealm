//
//  BackUpViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/24.
//

import UIKit
import RealmSwift
import SnapKit

class BackUpViewController: UIViewController {
    
    let mainview = BackUpView()
    
    override func loadView() {
        super.view = mainview
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainview.tableView.dataSource = self
        mainview.tableView.delegate = self
        
        self.navigationItem.title = "백업 / 복구"
    }
}

