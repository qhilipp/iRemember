//
//  LearnlistInfoViewModel.swift
//  iRemember
//
//  Created by Privat on 01.01.24.
//

import Foundation
import SwiftData

@Observable
class LearnlistInfoViewModel {
	
	let learnlist: Learnlist
	
	private var exerciseIds: [UUID] { learnlist.exercises.map { $0.id } }
	var predicate: Predicate<Exercise> { #Predicate<Exercise> { exerciseIds.contains($0.id) } }
	
	init(learnlist: Learnlist) {
		self.learnlist = learnlist
	}
	
}
