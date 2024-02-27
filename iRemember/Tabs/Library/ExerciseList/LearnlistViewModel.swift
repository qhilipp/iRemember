//
//  LearnlistViewModel.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class LearnlistViewModel {
	
	var learnlist: Learnlist
	var searchTerm: String = ""
	var showAddExercise = false
	var editExercise: Exercise?
	var showSelectExercises = false
	var showEdit = false
	var showInfo = false
	var showConfirmDelete = false
	var indexSetToDelte: IndexSet?
	
	var exerciseResults: [Exercise] {
		if searchTerm == "" {
			learnlist.sortedExercises
		} else {
			learnlist.sortedExercises
				.filter { $0.matches(searchTerm: searchTerm) }
		}
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
	
	func confirmDelete(for exercise: Exercise) {
		guard let index = learnlist.exercises.firstIndex(of: exercise) else { return }
		confirmDelete(indexSet: IndexSet(integer: index))
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
