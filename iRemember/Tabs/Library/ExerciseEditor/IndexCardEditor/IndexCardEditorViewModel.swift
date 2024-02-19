//
//  IndexCardEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 14.10.23.
//

import Foundation
import SwiftData

@Observable
class IndexCardEditorViewModel: ExerciseEditorDelegate {
	
	var indexCard: IndexCard = IndexCard()
	var front: IndexCardPage = IndexCardPage()
	var back: IndexCardPage = IndexCardPage()
	var vm: ExerciseEditorViewModel
	var isEditingFront = true
	
	init(vm: ExerciseEditorViewModel) {
		self.vm = vm
		GlobalManager.shared.context.insert(indexCard)
		if let indexCard = vm.exercise.indexCard {
			front = indexCard.front
			back = indexCard.back
		}
	}
	
	func setup() {
		vm.delegate = self
	}
	
	func add() {
		indexCard.front = front
		indexCard.back = back
		vm.exercise.type = .indexCard(indexCard)
	}
	
	func hasMissingInformation() -> Bool {
		!front.hasInformation || !back.hasInformation
	}
	
}
