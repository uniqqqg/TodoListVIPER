//
//  TodoPresenter.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 5.03.26.
//

import Foundation

final class TodoPresenter: TodoListViewOutput, TodoInteractorOutput {
	
	weak var view: TodoListViewInput?
	var interactor: TodoListInteractorInput!
	var router: TodoListRouterInput!
	
	func fetchTasks() {
		interactor.request()
	}
	
	func getTasks(todos: [ListModel]) {
		view?.showTasks(for: todos)
	}
	
	func navigateToDetailView(todos: ListModel, onUpdate: ((ListModel) -> Void)?) {
		router.navigateDetailView(for: todos, onUpdate: onUpdate)
	}
	
	
}
