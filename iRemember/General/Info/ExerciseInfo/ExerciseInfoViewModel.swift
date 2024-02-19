//
//  ExerciseInfoViewModel.swift
//  iRemember
//
//  Created by Privat on 05.01.24.
//

import Foundation
import SwiftData

@Observable
class ExerciseInfoViewModel {
	
	var exercise: Exercise
	var showEditSheet = false
	
	init(exercise: Exercise) {
		self.exercise = exercise
	}
	
}
