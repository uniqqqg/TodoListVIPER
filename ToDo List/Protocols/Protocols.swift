//
//  Protocols.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 6.03.26.
//

import Foundation

protocol TodoListViewInput: AnyObject  {
	func showTasks(for todos: [ListModel])
}

protocol TodoListViewOutput {
	func fetchTasks()
	func navigateToDetailView(todos: ListModel, onUpdate: ((ListModel) -> Void)?)
}

protocol TodoListInteractorInput {
	func request()
}

protocol TodoInteractorOutput: AnyObject {
	func getTasks(todos: [ListModel])

}

protocol TodoListRouterInput {
	func navigateDetailView(for list: ListModel, onUpdate: ((ListModel) -> Void)?)
}
