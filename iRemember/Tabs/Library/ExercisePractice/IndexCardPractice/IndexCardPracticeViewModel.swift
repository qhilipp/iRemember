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
	var rating: Rating? = nil {
		didSet {
			vm.isCtaEnabled = rating != nil || !vm.isRevealed
		}
	}
	let id = UUID()
	private let durationAndDelay = 0.25
	
	init(indexCard: IndexCard, vm: ExercisePracticeViewModel) {
		self.indexCard = indexCard
		self.vm = vm
	}
	
	func ctaAction() {
		if vm.isRevealed {
			vm.isCtaEnabled = false
			withAnimation(.linear(duration: durationAndDelay)) {
				frontRotation = -90
			}
			withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
				backRotation = 0
			}
		}
	}
	
	func attachSpecificStatistic(to statistic: Statistic) {
		
	}
	
	func evaluateCorrectness() -> Double {
		rating?.correctness ?? 0
	}
	
}
