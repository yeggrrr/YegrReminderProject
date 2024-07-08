//
//  TodoRepository.swift
//  YegrReminderProject
//
//  Created by YJ on 7/8/24.
//

import RealmSwift

class TodoRepository {
    static let shared = TodoRepository()
    
    private let realm = try! Realm()
    
    func findFilePath() {
        print(realm.configuration.fileURL ?? "-")
    }
    
    func fetch() -> [TodoTable] {
        return Array(realm.objects(TodoTable.self))
    }
    
    func add(todo: TodoTable) {
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch {
            print(error, "Add Failed")
        }
    }
    
    func update(todo: TodoTable) {
        do {
            try realm.write {
                realm.add(todo, update: .modified)
            }
        } catch {
            print(error, "Update Failed")
        }
    }
    
    func delete(todo: TodoTable) {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print(error, "Delete Failed")
        }
    }
    
    func setValue(result: TodoTable, key: String) {
        do {
            switch result.isDone {
            case true:
                try realm.write {
                    result.setValue(false, forKey: key)
                }
            case false:
                try realm.write {
                    result.setValue(true, forKey: key)
                }
            }
        } catch {
            print(error)
        }
    }
}
