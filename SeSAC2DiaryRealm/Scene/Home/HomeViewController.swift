//
//  HomeViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift //Realm 1. import
import FSCalendar


class HomeViewController: BaseViewController {
    
    let repository = UserDiaryRepository()
    // repository를 새로 만들어줌으로 이제 localRealm을 여기서 선언해 줄 필요가 없음
    //let localRealm = try! Realm() // Realm 2. Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근
    
    lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }() //즉시 실행 클로저
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    var tasks: Results<UserDiary>! {
        didSet {
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        let tasks = repository.localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)

        fetchDocumentZipFile()



    }
    
    override func configure() {
        view.addSubview(tableView)
        view.addSubview(calendar)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    override func setCanstants() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.bottom.equalTo(0)
            
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        fetchRealm()
        //화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        //present, overCurrentContext, overFullScreen > viewWillApear X
        tasks = repository.localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
        
    }
    
    func fetchRealm() {
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        tasks = repository.fetch()
    }

    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .presentFullNavigation)
    }
    
    @objc func sortButtonClicked() {
        tasks = repository.fetchSort("regdate")
    }
    
    //realm filter query, NSPredicate
    @objc func filterButtonClicked() {
        tasks = repository.fetchFilter()
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
        
        cell.setData(data: tasks[indexPath.row])
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        return cell
    }
    
    //참고. TableView Editing Mode
    //테이블뷰 셀 높이가 작을 경우, 이미지가 없을 때, 시스템 이미지가 아닌 경우
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            
            //realm data update
            self.repository.updateFavorite(item: self.tasks[indexPath.row])
            self.fetchRealm()
            
        }
        //realm 데이터 기준
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            
            self.repository.deleteItem(item: self.tasks[indexPath.row])
            self.fetchRealm()
        }
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchDate(date: date).count
    }
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "새싹"
//    }
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }
    //100 -> 25일 3 -> 3
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }
}
