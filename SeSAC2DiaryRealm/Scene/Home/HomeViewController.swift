//
//  HomeViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift //Realm 1. import



class HomeViewController: BaseViewController {
    
    let localRealm = try! Realm() // Realm 2. Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        
        return view
    }() //즉시 실행 클로저
    
    var tasks: Results<UserDiary>! {
        didSet {
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        let tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        print(tasks)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")

        fetchDocumentZipFile()
        

    }
    
    override func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        fetchRealm()
        //화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        //present, overCurrentContext, overFullScreen > viewWillApear X
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
    }
    
    func fetchRealm() {
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        let tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
    @objc func sortButtonClicked() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    //realm filter query, NSPredicate
    @objc func filterButtonClicked() {
        tasks = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기'") //대소문자 여부
            //.filter("diaryTitle = '오늘의 일기36'")
    }
    
    @objc func backupButtonClicked() {
        let vc = ViewController()
        transition(vc, transitionStyle: .present)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else { return UITableViewCell() }

        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.setData(data: tasks[indexPath.row])
        return cell
    }
    
    //참고. TableView Editing Mode
    //테이블뷰 셀 높이가 작을 경우, 이미지가 없을 때, 시스템 이미지가 아닌 경우
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
            //realm data update
            try! self.localRealm.write {
                //하나의 레코드에서 특정 컬럼 하나만 변경
                self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite
                
                //하나의 테이블에 특정 컬럼 전체 값을 변경
                //self.tasks.setValue(true, forKey: "favorite")
                
                //하나의 레코드에서 여러 칼럼들이 변경
                //self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
                
                print("Realm Update Succeed")
            }
            // 1.스와이프 셀 하나만 ReloadRows 코드를 구현 => 상대적 효율성
            // 2.데이터가 변경되었으니 다시 realm에서 데이터를 가지고오기 => didSet 일관적 형태로 갱신
//            self.fetchRealm()
            tableView.reloadData()
        }
        
        //realm 데이터 기준
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        

        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    

}
