//
//  BackUpButtonUI.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/24.
//

import UIKit

class BackUpButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonUI() {
        self.layer.cornerRadius = 8
        self.setTitleColor(.systemGray, for: .normal)
        self.layer.borderWidth = 2
        self.layer.backgroundColor = UIColor.systemGray5.cgColor
        self.layer.borderColor = UIColor.black.cgColor
    }
}
