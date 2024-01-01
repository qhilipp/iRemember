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
	var showAddExercise = false
	var showSelectExercises = false
	var showEdit = false
	var showInfo = false
	var showConfirmDelete = false
	var indexSetToDelte: IndexSet?
	
	var exerciseResults: [Exercise] {
		if searchTerm == "" {
			return learnlist.sortedExercises
		}
		return learnlist.sortedExercises.filter { $0.name.contains(searchTerm) }
	}
	
	var formattedTimeLimitation: String? {
		if learnlist.hasTimeLimitation {
			let formatter = DateComponentsFormatter()
			return formatter.string(from: learnlist.timeLimitation)
		}
		return nil
	}
	
	init(learnlist: Learnlist) {
		self.learnlist = learnlist
	}
	
	func confirmDelete(indexSet: IndexSet) {
		showConfirmDelete = true
		indexSetToDelte = indexSet
	}
	
	func remove(andDelete delete: Bool) {
		guard let indexSetToDelte else { return }
		if delete {
			for index in indexSetToDelte {
				GlobalManager.shared.context.delete(learnlist.exercises[index])
			}
		}
		learnlist.exercises.remove(atOffsets: indexSetToDelte)
		self.indexSetToDelte = nil
	}
	
}
