//
//  LearnlistViewModel.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class LearnlistViewModel {
	
	var learnlists: [Learnlist] = []
	var context: ModelContext!
	var showAddLearnlist = false
	var showError = false
	var searchTerm = ""
	
	var filteredLearnlists: [Learnlist] {
		if searchTerm == "" {
			return learnlists
		}
		return learnlists.filter { learnlist in
			learnlist.name.contains(searchTerm)
		}
	}
	
	func save() {
		do {
			try context.save()
		} catch {
			showError = true
		}
	}
	
	func update() {
		let descriptor = FetchDescriptor<Learnlist>(
			predicate: #Predicate { learnlist in
				true
			},
			sortBy: [SortDescriptor(\Learnlist.name)]
		)
		withAnimation {
			learnlists = ((try? context.fetch(descriptor)) ?? [])
		}
	}
	
	func delete(indexSet: IndexSet) {
		for index in indexSet {
			context.delete(learnlists[index])
			learnlists.remove(at: index)
		}
		save()
	}
	
}
