//
//  TaskCell.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 7.03.26.
//

import UIKit

class TaskCell: UITableViewCell {
	static let identifier = "TaskCell"
	
	private let titleLabel = UILabel()
	private let subtitleLabel = UILabel()
	private let dateLabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		selectionStyle = .none
		contentView.backgroundColor = .black
		checkmarkButton.contentMode = .scaleAspectFit
		titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
		titleLabel.textColor = .white
		subtitleLabel.font = .systemFont(ofSize: 14)
		subtitleLabel.textColor = .lightGray
		subtitleLabel.numberOfLines = 2
		dateLabel.font = .systemFont(ofSize: 12)
		dateLabel.textColor = .systemGray2
		
		let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, dateLabel])
		textStack.axis = .vertical
		textStack.spacing = 4
		
		let mainStack = UIStackView(arrangedSubviews: [checkmarkButton, textStack])
		mainStack.axis = .horizontal
		mainStack.spacing = 12
		mainStack.alignment = .top
		
		contentView.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
			mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
			checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
			checkmarkButton.heightAnchor.constraint(equalToConstant: 24)
		])
	}
	
	private lazy var checkmarkButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "circle"), for: .normal)
		button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
		button.tintColor = .systemGray
		button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
		return button
	}()

	var onCheckmarkTapped: (() -> Void)?

	@objc private func checkmarkTapped() {
		onCheckmarkTapped?()
	}
	
	func configure(with task: ListModel) {
		subtitleLabel.text = task.description ?? "Описание задачи"
		dateLabel.text = "02/10/24"
		
		checkmarkButton.isSelected = task.completed
		checkmarkButton.tintColor = task.completed ? .systemYellow : .systemGray
		
		if task.completed {
			let attributed = NSMutableAttributedString(string: task.todo)
			attributed.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: task.todo.count))
			titleLabel.attributedText = attributed
			titleLabel.textColor = .lightGray
		} else {
			titleLabel.attributedText = nil
			titleLabel.text = task.todo
			titleLabel.textColor = .white
		}
	}
}
