//
//  IndexCardPracticeViewModel.swift
//  iRemember
//
//  Created by Privat on 24.12.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class IndexCardPracticeViewModel: ExercisePracticeDelegate {
	
	var indexCard: IndexCard
	var vm: ExercisePracticeViewModel
	var frontRotation = 0.0
	var backRotation = 90.0
	var rating: Rating? = nil
	private let durationAndDelay = 0.25
	
	init(indexCard: IndexCard, vm: ExercisePracticeViewModel) {
		self._indexCard = indexCard
		self._vm = vm
		self.vm.delegate = self
	}
	
	func flipAnimation() {
		withAnimation(.linear(duration: durationAndDelay)) {
			frontRotation = vm.isRevealed ? -90 : 0
		}
		withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
			backRotation = vm.isRevealed ? 0 : 90
		}
	}
	
	func attachSpecificStatistic(to statistic: Statistic) {
		
	}
	
	func evaluateCorrectness() -> Double {
		rating?.correctness ?? 0
	}
	
}
