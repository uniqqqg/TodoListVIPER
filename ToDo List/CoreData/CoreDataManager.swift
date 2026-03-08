//
//  CoreDataManager.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 8.03.26.
//

import CoreData
import UIKit

class CoreDataManager {
	static let shared = CoreDataManager()
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { _, error in
			if let error = error {
				print("CoreData error: \(error)")
			}
		}
		return container
	}()
	
	private var context: NSManagedObjectContext {
		persistentContainer.viewContext
	}
	
	// MARK: - Save
	func saveTasks(_ tasks: [ListModel]) {
		let backgroundContext = persistentContainer.newBackgroundContext()
		backgroundContext.perform {
			
			let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoEntity")
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			try? backgroundContext.execute(deleteRequest)
			
			for task in tasks {
				let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: backgroundContext)
				entity.setValue(Int64(task.id), forKey: "id")
				entity.setValue(task.todo, forKey: "todo")
				entity.setValue(task.description, forKey: "desc")
				entity.setValue(task.completed, forKey: "completed")
				entity.setValue(Int64(task.userId), forKey: "userId")
			}
			try? backgroundContext.save()
		}
	}
	
	// MARK: - Fetch
	func fetchTasks() -> [ListModel] {
		let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "TodoEntity")
		let results = (try? context.fetch(fetchRequest)) ?? []
		return results.map {
			ListModel(
				id: Int($0.value(forKey: "id") as? Int64 ?? 0),
				todo: $0.value(forKey: "todo") as? String ?? "",
				completed: $0.value(forKey: "completed") as? Bool ?? false,
				userId: Int($0.value(forKey: "userId") as? Int64 ?? 0),
				description: $0.value(forKey: "desc") as? String
			)
		}
	}
	
	// MARK: - Has Data
	func hasTasks() -> Bool {
		let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "TodoEntity")
		let count = (try? context.count(for: fetchRequest)) ?? 0
		return count > 0
	}
	
	// MARK: - Save single task
	func saveTask(_ task: ListModel) {
		let backgroundContext = persistentContainer.newBackgroundContext()
		backgroundContext.perform {
			let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: backgroundContext)
			entity.setValue(Int64(task.id), forKey: "id")
			entity.setValue(task.todo, forKey: "todo")
			entity.setValue(task.description, forKey: "desc")
			entity.setValue(task.completed, forKey: "completed")
			entity.setValue(Int64(task.userId), forKey: "userId")
			try? backgroundContext.save()
		}
	}

	// MARK: - Update task
	func updateTask(_ task: ListModel) {
		let backgroundContext = persistentContainer.newBackgroundContext()
		backgroundContext.perform {
			let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "TodoEntity")
			fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
			if let entity = try? backgroundContext.fetch(fetchRequest).first {
				entity.setValue(task.todo, forKey: "todo")
				entity.setValue(task.description, forKey: "desc")
				entity.setValue(task.completed, forKey: "completed")
				try? backgroundContext.save()
			}
		}
	}

	// MARK: - Delete task
	func deleteTask(id: Int) {
		let backgroundContext = persistentContainer.newBackgroundContext()
		backgroundContext.perform {
			let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "TodoEntity")
			fetchRequest.predicate = NSPredicate(format: "id == %d", id)
			if let entity = try? backgroundContext.fetch(fetchRequest).first {
				backgroundContext.delete(entity)
				try? backgroundContext.save()
			}
		}
	}
}
