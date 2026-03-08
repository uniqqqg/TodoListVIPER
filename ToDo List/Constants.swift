//
//  Constants.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 7.03.26.
//

import UIKit

final class Constants {
	private init() {}
	
	struct Titles {
		static let tasks = "Задачи"
		static let addTask = "Добавить задачу"
	}
	
	struct Placeholders {
		static let search = "Search"
		static let title = "Заголовок"
		static let description = "Описание"
	}
	
	struct Buttons {
		static let save = "Сохранить"
		static let cancel = "Отмена"
		static let edit = "Редактировать"
		static let share = "Поделиться"
		static let delete = "Удалить"
	}
	
	struct Messages {
		static let error = "Произошла ошибка"
		static let emptyList = "Список пуст"
	}
}
