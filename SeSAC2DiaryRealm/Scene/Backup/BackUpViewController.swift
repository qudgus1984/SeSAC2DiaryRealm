//
//  BackUpViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/24.
//

import UIKit
import RealmSwift
import SnapKit
import Zip

class BackUpViewController: BaseViewController {
    
    let mainview = BackUpView()
    let mainviewCell = BackUpTableViewCell()
    
    override func loadView() {
        super.view = mainview
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainview.tableView.dataSource = self
        mainview.tableView.delegate = self
        
        self.navigationItem.title = "백업 / 복구"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
    override func configure() {
        mainview.backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        mainview.restorationButton.addTarget(self, action: #selector(restorationButtonClick), for: .touchUpInside)
    }
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    @objc func backupButtonClicked() {
        var urlPaths = [URL]()
        
        //도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let realmFile = path.appendingPathComponent("default.realm") //도큐먼트 안의 default.realm 까지 접근
        //appendingPathComponent("default.realm")의 의미는 /default.realm 를 의미함
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        //백업 파일을 압축: URL
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1")
            print("Archive Location: \(zipFilePath)")
            showActivityViewController()
        } catch {
            showAlertMessage(title: "압축을 실패했습니다.")
        }
        
        func showActivityViewController() {
            
            //도큐먼트 위치에 백업 파일 확인
            guard let path = documentDirectoryPath() else {
                showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
                return
            }
            
            let backUpFileURL = path.appendingPathComponent("SeSACDiary_1.zip") //도큐먼트 안의 default.realm 까지 접근
            
            let vc = UIActivityViewController(activityItems: [backUpFileURL], applicationActivities: [])
            self.present(vc, animated: true)
        }
    
    }
    
    @objc func restorationButtonClick() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)

    }
}

extension BackUpViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        //도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        //lastPathComponent ex) a/b/c.zip -> c.zip 만 가져오는 것!
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        } else {
            
            do {
                //파일 앱의 zip -> 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                // 폴더 생성, 폴더 안에 파일 저장
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
