//
//  NetworkService.swift
//  ToDo List
//
//  Created by Глеб Моргунов on 5.03.26.
//

import Foundation

class NetworkService {
	
	static let shared = NetworkService()
	
	func request(url: String, completion: @escaping (TodoResponse?) -> Void) {
		guard let url = URL(string: url) else {
			completion(nil)
			return
		}
		URLSession.shared.dataTask(with: url) { data, _, error in
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let decoded = try decoder.decode(TodoResponse.self, from: data)
				completion(decoded)
			} catch {
				print("error \(error)")
			}
			
		} .resume()
	}
	
}
