//
//  Router.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 6.03.26.
//

import UIKit

class TodoListRouter: TodoListRouterInput {
	
	weak var controller: UIViewController?
	
	func navigateDetailView(for list: ListModel, onUpdate: ((ListModel) -> Void)? = nil) {
		let detailVC = DetailViewController(task: list)
		detailVC.onTaskUpdated = onUpdate
		controller?.navigationController?.pushViewController(detailVC, animated: true)
	}
}
