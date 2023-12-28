//
//  LearnlistViewModel.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import Foundation
import SwiftData

@Observable
class LearnlistViewModel {
	
	var learnlists: [Learnlist] = []
	var showAddLearnlist = false
	var showError = false
	var showConfirmDelete = false
	var searchTerm = ""
	var indexSetToDelete: IndexSet?
	
	var filteredLearnlists: [Learnlist] {
		if searchTerm == "" {
			return learnlists
		}
		return learnlists.filter { learnlist in
			learnlist.name.contains(searchTerm)
		}
	}
	
	func update() {
		let descriptor = FetchDescriptor<Learnlist>()
		learnlists = ((try? GlobalManager.shared.context.fetch(descriptor)) ?? [])
	}
	
	func confirmDelete(indexSet: IndexSet) {
		showConfirmDelete = true
		self.indexSetToDelete = indexSet
	}
	
	func delete(recursive: Bool) {
		guard let indexSetToDelete else { return }
		if recursive {
			for index in indexSetToDelete {
				for exercise in learnlists[index].exercises {
					GlobalManager.shared.context.delete(exercise)
				}
			}
		}
		learnlists.remove(atOffsets: indexSetToDelete)
	}
	
}
