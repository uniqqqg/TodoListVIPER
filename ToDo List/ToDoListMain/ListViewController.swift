//
//  ListViewController.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 4.03.26.
//

import UIKit
import Speech

class ListViewController: UIViewController, TodoListViewInput {
	
	let tableView = UITableView()
	let searchBar = UISearchBar()
	private var todosArray: [ListModel] = []
	private var originalArray: [ListModel] = []
	private var titleLabel = UILabel()
	var output: TodoListViewOutput
	
	init(output: TodoListViewOutput) {
		self.output = output
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	convenience init(sampleTodos: [ListModel]) {
		let mockOutput = MockPresenter()
		self.init(output: mockOutput)
		self.todosArray = sampleTodos
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupNavigationBar()
		setupTabelView()
		setupToolbar()
		output.fetchTasks()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
	}
		
	func setupTabelView() {
		view.addSubview(searchBar)
		view.addSubview(tableView)
		searchBar.delegate = self
		tableView.backgroundColor = .black
		tableView.separatorColor = .darkGray
		tableView.dataSource = self
		tableView.delegate = self
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
		
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.barTintColor = .black
		searchBar.placeholder = "Search"
		searchBar.searchTextField.backgroundColor = UIColor(white: 0.15, alpha: 1)
		searchBar.searchTextField.textColor = .gray
		searchBar.showsBookmarkButton = false
		
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
	func showTasks(for todos: [ListModel]) {
		DispatchQueue.main.async {
			guard self.todosArray.isEmpty else { return }
			self.todosArray = todos
			self.originalArray = todos
			self.tableView.reloadData()
			self.toolbarItems?.first?.title = "\(todos.count) Задач"
		}
	}
	
	func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = true
		
		titleLabel.text = "Задачи"
		titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
		titleLabel.textColor = .white
		
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
		])
	}
	
	func setupToolbar() {
			let countLabel = UIBarButtonItem(title: "\(todosArray.count) Задач", style: .plain, target: nil, action: nil)
		let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addTask))
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbarItems = [countLabel, spacer, addButton]
		navigationController?.isToolbarHidden = false
	}
	
	@objc func addTask() {
		let newTask = ListModel(id: todosArray.count + 1, todo: "", completed: false, userId: 1)
		todosArray.insert(newTask, at: 0)
		originalArray.insert(newTask, at: 0)
		tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		output.navigateToDetailView(todos: newTask) { [weak self] updatedTask in
			self?.todosArray[0] = updatedTask
			self?.originalArray[0] = updatedTask
			self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
			self?.toolbarItems?.first?.title = "\(self?.todosArray.count ?? 0) Задач"
			CoreDataManager.shared.saveTask(newTask)
		}
	}


}
#Preview(traits: .portrait) {
	ListViewController(sampleTodos: [
		ListModel(id: 1, todo: "Купить кофе", completed: false, userId: 1),
		ListModel(id: 2, todo: "Ответить на письма", completed: true, userId: 1),
		ListModel(id: 3, todo: "Прогулка 30 минут", completed: false, userId: 1),
		ListModel(id: 4, todo: "Дочитать книгу", completed: false, userId: 1)
	])
}

class MockPresenter: TodoListViewOutput {
	func navigateToDetailView(todos: ListModel, onUpdate: ((ListModel) -> Void)?) {
		
	}
	
	func fetchTasks() { }

}
extension ListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("numberOfRows: \(todosArray.count)")
		return todosArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else { return UITableViewCell() }
			cell.configure(with: todosArray[indexPath.row])
		
		cell.onCheckmarkTapped = { [weak self] in
			guard let self else { return }
			self.todosArray[indexPath.row].completed.toggle()
			self.originalArray[indexPath.row].completed.toggle()
			self.tableView.reloadRows(at: [indexPath], with: .automatic)
			CoreDataManager.shared.updateTask(self.todosArray[indexPath.row])
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		output.navigateToDetailView(todos: todosArray[indexPath.row]) { [weak self] updatedTask in
			guard let self else { return }
			self.todosArray[indexPath.row] = updatedTask
			self.originalArray[indexPath.row] = updatedTask
			CoreDataManager.shared.updateTask(updatedTask)
			self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}

	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
			let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				CoreDataManager.shared.deleteTask(id: self.todosArray[indexPath.row].id)
				self.todosArray.remove(at: indexPath.row)
				self.originalArray.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .automatic)
				self.toolbarItems?.first?.title = "\(self.todosArray.count) Задач"
			}
			let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
				self.output.navigateToDetailView(todos: self.todosArray[indexPath.row]) { [weak self] updatedTask in
					guard let self else { return }
					self.todosArray[indexPath.row] = updatedTask
					self.originalArray[indexPath.row] = updatedTask
					CoreDataManager.shared.saveTask(updatedTask)
					self.tableView.reloadRows(at: [indexPath], with: .automatic)
				}
			}
			return UIMenu(children: [edit, delete])
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			guard !searchText.isEmpty else {
				todosArray = originalArray
				tableView.reloadData()
				return
			}
			todosArray = originalArray.filter { $0.todo.lowercased().contains(searchText.lowercased()) }
			tableView.reloadData()
		}
	
	func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
		// можно дополнительно реализовать работу с голосовым вводом
	}
	
	}
