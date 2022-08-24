//
//  HomeTableViewCell.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/23.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {
    
    let diaryImageView: DiaryImageView = {
        let view = DiaryImageView(frame: .zero)
        return view
    }()
    
    let titleLabel: UILabel = {
       let view = UILabel()
        view.textColor = Constants.BaseColor.text
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let dateLabel: UILabel = {
       let view = UILabel()
        view.textColor = Constants.BaseColor.text
        view.font = .boldSystemFont(ofSize: 13)
        return view
    }()
    
    let contentLabel: UILabel = {
       let view = UILabel()
        view.textColor = Constants.BaseColor.text
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .fillEqually
        view.spacing = 2
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: UserDiary) {
        titleLabel.text = data.diaryTitle
        dateLabel.text = data.diaryDate.formatted()
        contentLabel.text = data.diaryContent
    }
    
    override func configure() {
        backgroundColor = Constants.BaseColor.background
        [diaryImageView, stackView].forEach {
            contentView.addSubview($0)
        }
        
        [titleLabel, dateLabel, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        let spacing = 8
        
        diaryImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView).inset(spacing)
            make.width.equalTo(diaryImageView.snp.height)
            make.centerY.equalTo(contentView)
            make.trailingMargin.equalTo(-spacing)
        }
        
        stackView.snp.makeConstraints { make in
            make.leadingMargin.top.equalTo(spacing)
            make.bottom.equalTo(-spacing)
            make.trailing.equalTo(diaryImageView.snp.leading).offset(-spacing)
        }
    }
    

    
    
}
