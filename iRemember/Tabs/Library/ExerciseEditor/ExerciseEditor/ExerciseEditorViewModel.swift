//
//  ExerciseEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 27.08.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ExerciseEditorViewModel {
	
	var exercise: Exercise
	let learnlist: Learnlist
	var dismissAction: DismissAction!
	var scrollProxy: ScrollViewProxy!
	@ObservationIgnored var delegate: ExerciseEditorDelegate?
	var missingInformationErrorMessage: String?
	var showSettings = false
	
	var canNavigate: Bool {
		!exercise.name.isEmpty
	}
	
	var canContinue: Bool {
		delegate?.hasMissingInformation() == false
	}
	
	var showMissingInformationError: Bool {
		get {
			missingInformationErrorMessage != nil
		}
		
		set {
			missingInformationErrorMessage = newValue ? "Some information is missing" : nil
		}
	}
	
	init(exercise: Exercise, in learnlist: Learnlist) {
		self.exercise = exercise
		self.learnlist = learnlist
	}
	
	func setup() {
		self.learnlist.sortedExercises.append(self.exercise)
	}
	
	func add() {
		guard delegate?.hasMissingInformation() == false else { return }
		delegate?.add()
		learnlist.sortedExercises.append(exercise)
		dismissAction()
	}
	
	func navigatToSettings() {
		if canContinue {
			withAnimation {
				showSettings = true
			}
		} else {
			showMissingInformationError = true
		}
	}
	
	func scrollTo<H: Hashable>(_ id: H, anchor: UnitPoint? = nil) {
		scrollProxy.scrollTo(id, anchor: anchor)
	}
	
}

protocol ExerciseEditorDelegate {
	
	func add()
	func hasMissingInformation() -> Bool
	
}
