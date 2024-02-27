//
//  PredicateWrapper.swift
//  iRemember
//
//  Created by Privat on 30.12.23.
//

import Foundation
import SwiftData

struct PredicateWrapper<T: PersistentModel>: Hashable {
	
	static var all: PredicateWrapper<T> { return PredicateWrapper(#Predicate<T> { _ in true }) }
	
	var id = UUID()
	var predicate: Predicate<T>
	
	init(_ predicate: Predicate<T>) {
		self.predicate = predicate
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: PredicateWrapper, rhs: PredicateWrapper) -> Bool {
		lhs.id == rhs.id
	}

}
