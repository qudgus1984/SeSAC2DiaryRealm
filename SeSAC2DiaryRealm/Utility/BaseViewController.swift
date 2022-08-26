//
//  BaseViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setCanstants()
    }
    
    
    func configure() {}
    
    func setCanstants() {}
    
    
    func showAlertMessage(title: String, button: String = "확인") { //매개변수 기본값
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}

