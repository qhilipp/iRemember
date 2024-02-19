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
	
	init(vm: ExerciseEditorViewModel, indexCard: IndexCard) {
		self.vm = vm
		self.indexCard = indexCard
		GlobalManager.shared.context.insert(indexCard)
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
