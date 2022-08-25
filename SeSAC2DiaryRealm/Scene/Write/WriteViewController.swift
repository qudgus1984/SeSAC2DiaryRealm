//
//  WriteViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit
import RealmSwift

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

class WriteViewController: BaseViewController {

    let mainView = WriteView()
    let localRealm = try! Realm() //Realm 테이블에 데이터를 CRUD할 때, Realm테이블 경로에 접근
    
    override func loadView() {
        self.view = mainView
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func configure() {
        mainView.searchImageButton.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        mainView.sampleButton.addTarget(self, action: #selector(sampleButtonClicked), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    // Realm + 이미지 도큐먼트 저장
    @objc func saveButtonClicked() {
        
        guard let title = mainView.titleTextField.text else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        
        let task = UserDiary(diaryTitle: title, diaryContent: mainView.contentTextView.text!, diaryDate: Date(), regdate: Date(), photo: nil)
        
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        
        if let image = mainView.userImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
        }
        
        dismiss(animated: true)
    }
    
    //Realm Create Sample
    @objc func sampleButtonClicked() {
        let task = UserDiary(diaryTitle: "Apple\(Int.random(in: 1...1000))", diaryContent: "일기 테스트 내용", diaryDate: Date(), regdate: Date(), photo: nil) // => Record
        try! localRealm.write {
            localRealm.add(task) //Create
            print("Realm Succeed")
            dismiss(animated: true)
        }
    }
      
    @objc func selectImageButtonClicked() {
        let vc = SearchImageViewController()
        vc.delegate = self
        transition(vc, transitionStyle: .presentFullNavigation)
    }
}

extension WriteViewController: SelectImageDelegate {

    //언제 실행이 되면 될까요?
    func sendImageData(image: UIImage) {
        mainView.userImageView.image = image
        print(#function)
    }
 
}
