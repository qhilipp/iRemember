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
	var learnlist: Learnlist?
	var scrollProxy: ScrollViewProxy!
	@ObservationIgnored var delegate: ExerciseEditorDelegate?
	var missingInformationErrorMessage: String?
	var navigationPath = NavigationPath()
	
	var isInCreationMode: Bool {
		learnlist != nil
	}
	
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
	
	init(exercise: Exercise?, learnlist: Learnlist?) {
		self.exercise = exercise ?? Exercise()
		self.learnlist = learnlist
	}
	
	func setup() {
		if !isInCreationMode {
			navigationPath.append(exercise.type)
		}
	}
	
	func complete() {
		guard delegate?.hasMissingInformation() == false else { return }
		delegate?.onComplete()
		learnlist?.exercises.append(exercise)
	}
	
	func scrollTo<H: Hashable>(_ id: H, anchor: UnitPoint? = nil) {
		scrollProxy.scrollTo(id, anchor: anchor)
	}
	
	func canNavigate(to type: ExerciseType) -> Bool {
		canNavigate && (isInCreationMode || exercise.type == type)
	}
	
}

protocol ExerciseEditorDelegate {
	
	var vm: ExerciseEditorViewModel { get }
	func onComplete()
	func hasMissingInformation() -> Bool
	func setup()
	
}

extension ExerciseEditorDelegate {
	
	func setup() {
		vm.delegate = self
	}
	
}
