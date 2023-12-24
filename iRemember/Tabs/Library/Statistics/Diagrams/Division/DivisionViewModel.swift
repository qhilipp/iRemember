//
//  DivisionViewModel.swift
//  iRemember
//
//  Created by Privat on 24.09.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class DivisionViewModel {
	
	@ObservationIgnored let title: String
	@ObservationIgnored let practiceSession: PracticeSession
	@ObservationIgnored let generateValue: ([Statistic]) -> Double
	
	var completedChartData: [DivisionPart] {
		CorrectnessType.allCases.map { correctnessType in
			DivisionPart(
				title: correctnessType.rawValue,
				value: generateValue(practiceSession.sortedStatistics.filter { $0.correctnessType == correctnessType })
			)
		}
	}
	
	var completedChartForegroundStyleScale: KeyValuePairs<String, Color> {
		[
			CorrectnessType.correct.rawValue: Color.green,
			CorrectnessType.partiallyCorrect.rawValue: Color.orange,
			CorrectnessType.incorrect.rawValue: Color.red
		]
	}
	
	init(title: String, practiceSession: PracticeSession, generateValue: @escaping ([Statistic]) -> Double) {
		self.title = title
		self.practiceSession = practiceSession
		self.generateValue = generateValue
	}
	
}

struct DivisionPart: Identifiable {
	var id: String { title }
	
	let title: String
	let value: Double
}
