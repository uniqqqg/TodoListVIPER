//
//  TodoResponse.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 5.03.26.
//

import Foundation

struct TodoResponse: Decodable {
	let todos: [ListModel]
	let total: Int
	let skip: Int
	let limit: Int
}
