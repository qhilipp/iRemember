//
//  ExerciseEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 25.07.23.
//

import Foundation
import SwiftData

@Observable
class ExerciseEditorViewModel {
	
	var exercise: Exercise = Exercise(name: "")
	
	init(learnlist: Learnlist) {
		learnlist.exercises.append(exercise)
	}
	
}
