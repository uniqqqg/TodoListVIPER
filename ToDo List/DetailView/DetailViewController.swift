//
//  DetailViewController.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 7.03.26.
//

import UIKit

final class DetailViewController: UIViewController {

	private var task: ListModel
	var onTaskUpdated: ((ListModel) -> Void)?

	private let titleTextField = UITextField()
	private let dateLabel = UILabel()
	private let descriptionTextView = UITextView()

	init(task: ListModel) {
		self.task = task
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupBackButton()
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		task.todo = titleTextField.text ?? task.todo
		task.description = descriptionTextView.text
		onTaskUpdated?(task)
	}

	private func setupBackButton() {
		navigationController?.navigationBar.isHidden = false
		navigationController?.navigationBar.tintColor = .systemYellow
		navigationItem.rightBarButtonItem?.tintColor = .systemYellow
	}

	private func setupUI() {
		titleTextField.text = task.todo
		titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
		titleTextField.textColor = .white
		titleTextField.backgroundColor = .black
		titleTextField.borderStyle = .none

		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yy"
		dateLabel.text = formatter.string(from: Date()) 
		dateLabel.font = .systemFont(ofSize: 14)
		dateLabel.textColor = .systemGray

		descriptionTextView.text = task.description ?? "Описание задачи"
		descriptionTextView.font = .systemFont(ofSize: 16)
		descriptionTextView.textColor = .white
		descriptionTextView.backgroundColor = .black

		let stack = UIStackView(arrangedSubviews: [titleTextField, dateLabel, descriptionTextView])
		stack.axis = .vertical
		stack.spacing = 8

		view.addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
		])
	}
}
