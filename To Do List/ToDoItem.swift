//
//  ToDoItem.swift
//  To Do List
//
//  Created by Ben Tsai on 3/6/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var completed: Bool
    var notificationID: String? 
}
