//
//  Builder.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 6.03.26.
//

import UIKit

class Builder {
	static func createListView() -> UIViewController {
		let presenter = TodoPresenter()
		let view = ListViewController(output: presenter)
		let interactor = TodoInteractor()
		let router = TodoListRouter()
		
		view.output = presenter
		presenter.view = view
		presenter.interactor = interactor
		presenter.router = router
		interactor.presenter = presenter
		router.controller = view
		return view
	}
}
