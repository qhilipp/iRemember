//
//  LibraryLandingPageViewModel.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import Foundation
import SwiftData

@Observable
class LibraryLandingPageViewModel {
	
	var allLearnlists: [Learnlist] = []
	var showAddLearnlist = false
	
	var learnNow: [Learnlist] {
		allLearnlists
	}
	
	var forYou: [Learnlist] {
		allLearnlists
	}
	
	var favorites: [Learnlist] {
		allLearnlists
	}
	
	var dueSoon: [Learnlist] {
		allLearnlists
	}
	
	var aLotToDo: [Learnlist] {
		allLearnlists
	}
	
	var all: [Learnlist] {
		allLearnlists
	}
	
	init() {}
	
	func fetch() {
		allLearnlists = (try? GlobalManager.shared.context.fetch(FetchDescriptor<Learnlist>())) ?? []
	}
	
}
