//
//  TodoRealmModel.swift
//  YegrReminderProject
//
//  Created by YJ on 7/2/24.
//

import Foundation
import RealmSwift

class TodoTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var memoTitle: String
    @Persisted var content: String?
    @Persisted var deadline: Date?
    @Persisted var tag: String?
    @Persisted var priority: Int?
    @Persisted var image: String?
    @Persisted var isDone: Bool
    
    convenience init(memoTitle: String, Content: String? = nil, deadline: Date? = nil, tag: String? = nil, priority: Int?, image: String? = nil, isDone: Bool) {
        self.init()
        self.memoTitle = memoTitle
        self.content = Content
        self.deadline = deadline
        self.tag = tag
        self.priority = priority
        self.image = image
        self.isDone = false
    }
}
