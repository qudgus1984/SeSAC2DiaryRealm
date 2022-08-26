//
//  BackUpView.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/24.
//

import UIKit
import SnapKit
import RealmSwift

class BackUpView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstants()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 백업 버튼
    let backupButton: UIButton = {
        let button = BackUpButton()
        button.setTitle("백업하시겠습니까?", for: .normal)
        return button
    }()
    
    // 복원 버튼
    let restorationButton: UIButton = {
        let button = BackUpButton()
        button.setTitle("복원하시겠습니까?", for: .normal)
        return button
    }()
    
    // 테이블 뷰
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(BackUpTableViewCell.self, forCellReuseIdentifier: BackUpTableViewCell.reuseIdentifier)
        view.backgroundColor = .systemGray3
        view.rowHeight = 30
        return view
    }()
    

    func configure() {
        [backupButton, restorationButton, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstants() {
        backupButton.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(40)
        }
        
        restorationButton.snp.makeConstraints {
            $0.top.equalTo(backupButton.snp.bottom).offset(8)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(restorationButton.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-20)
        }
    }
}

extension BackUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BackUpTableViewCell.reuseIdentifier, for: indexPath) as! BackUpTableViewCell
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
