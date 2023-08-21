//
//  ExerciseListViewModel.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ExerciseListViewModel {
	
	var learnlist: Learnlist
	var searchTerm: String = ""
	var sortBy: SortBy = .date
	var ordering: Ordering = .ascending
	var context: ModelContext!
	var showAddExercise = false
	var showEdit = false
	
	var filteredExercises: [Exercise] {
		if searchTerm == "" {
			return learnlist.exercises
		}
		return learnlist.exercises.filter { $0.name.contains(searchTerm) }
	}
	
	init(learnlist: Learnlist) {
		self.learnlist = learnlist
	}
	
	func delete(indexSet: IndexSet) {
		for index in indexSet {
			learnlist.exercises.remove(at: index)
		}
	}
	
}
