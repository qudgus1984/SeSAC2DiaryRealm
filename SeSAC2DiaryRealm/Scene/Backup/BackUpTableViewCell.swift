//
//  BackUpTableViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/24.
//

import UIKit

class BackUpTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    let cellInImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .black
        view.image = UIImage(systemName: "doc")
        return view
    }()
    
    let cellInTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "SeSACDiary_1"
        return label
    }()
    
    func addContentView() {
        [cellInImageView, cellInTitleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        
        
        cellInImageView.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            $0.width.equalTo(40)
        }
        
        cellInTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(cellInImageView.snp.trailing)
            $0.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            
        }
    }
}
