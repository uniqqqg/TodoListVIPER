//
//  ListModel.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 5.03.26.
//

import Foundation

struct ListModel: Decodable {
	let id: Int
	var todo: String
	var completed: Bool
	let userId: Int
	
	var description: String?
}
