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
	var searchTerm = ""
	
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
	
	func delete(indexSet: IndexSet) {
		for index in indexSet {
			GlobalManager.shared.context.delete(learnlists[index])
		}
		for index in indexSet {
			learnlists.remove(at: index)
		}
	}
	
}
