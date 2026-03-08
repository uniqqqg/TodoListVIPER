//
//  TodoInteractor.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 5.03.26.
//

import Foundation

final class TodoInteractor: TodoListInteractorInput {
	
	weak var presenter: TodoInteractorOutput?
	
	init(presenter: TodoInteractorOutput? = nil) {
		self.presenter = presenter
	}
	
	func request() {
		DispatchQueue.global(qos: .background).async {
			if CoreDataManager.shared.hasTasks() {
				let tasks = CoreDataManager.shared.fetchTasks()
				DispatchQueue.main.async {
					self.presenter?.getTasks(todos: tasks)
				}
			} else {
				NetworkService.shared.request(url: "https://dummyjson.com/todos") { data in
					let todos = data?.todos ?? []
					CoreDataManager.shared.saveTasks(todos)
					DispatchQueue.main.async {
						self.presenter?.getTasks(todos: todos)
					}
				}
			}
		}
	}
}
