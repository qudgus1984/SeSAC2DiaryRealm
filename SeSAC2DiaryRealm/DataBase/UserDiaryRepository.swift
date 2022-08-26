//
//  UserDiaryRepository.swift
//  SeSAC2DiaryRealm
//
//  Created by 이병현 on 2022/08/26.
//

import Foundation
import RealmSwift

// 여러개의 테이블 => CRUD
// 제네릭을 사용하면 다른 파일에서도 사용할 수 있게 변환 가능
protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary>
    func fetchSort(_ sort: String) -> Results<UserDiary>
    func fetchFilter() -> Results<UserDiary>
    func fetchDate(date: Date) -> Results<UserDiary>
    func deleteItem(item: UserDiary)
    func addItem(item: UserDiary)
}

class UserDiaryRepository: UserDiaryRepositoryType {
    func fetchDate(date: Date) -> Results<UserDiary> {
        
        
        return localRealm.objects(UserDiary.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date)) //NSPredicate
    }
    
    func addItem(item: UserDiary) {
        
    }
    
    let localRealm = try! Realm() //구조체에 singleton이 안되는 이유 struct => realm이 결국 구조체로 이루어진 하나의 데이터 집합
    
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] 'a'")
        //대소문자 여부
        //.filter("diaryTitle = '오늘의 일기36'")
    }
    func updateFavorite(item: UserDiary) {
        try! localRealm.write {
            //하나의 레코드에서 특정 컬럼 하나만 변경
            item.favorite.toggle()
            
            //item.favorite.toggle() == item.favorite = !item.favorite 같은 기능임!
            
            //하나의 테이블에 특정 컬럼 전체 값을 변경
            //self.tasks.setValue(true, forKey: "favorite")
            
            //하나의 레코드에서 여러 칼럼들이 변경
            //self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
            
            print("Realm Update Succeed")
        }
    }
    
    func deleteItem(item: UserDiary) {
        try! localRealm.write {
            localRealm.delete(item)
        }
        removeImageFromDocument(fileName: "\(item.objectId).jpg")
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
