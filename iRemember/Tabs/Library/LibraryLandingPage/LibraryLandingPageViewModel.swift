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
	
	let allLearnlists: [Learnlist]
	
	var learnNow: [Learnlist] {
		allLearnlists
	}
	
	var lastAdded: [Learnlist] {
		Array(allLearnlists.sorted {
			$0.creationDate < $1.creationDate
		}.prefix(through: 10))
	}
	
	
	
	init() {
		allLearnlists = (try? GlobalManager.shared.context.fetch(FetchDescriptor<Learnlist>())) ?? []
	}
	
}
