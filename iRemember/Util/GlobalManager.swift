//
//  GlobalManager.swift
//  iRemember
//
//  Created by Privat on 28.09.23.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class GlobalManager {
	
	@ObservationIgnored public static let shared = GlobalManager()
	
	var context: ModelContext!
	var navigationPath = NavigationPath()
		
	private init() {}
	
	func fetch<T: PersistentModel>(using predicate: Predicate<T>? = nil, sortBy sortion: [SortDescriptor<T>] = []) -> [T] {
		(try? context.fetch(FetchDescriptor(predicate: predicate, sortBy: sortion))) ?? []
	}
	
}
