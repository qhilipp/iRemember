//
//  Statistic.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Statistic: Identifiable, Hashable {
	
	@Transient static let correctnessThreshold = 0.99
	@Transient static let incorrectnessThreshold = 0.4
	
	@Attribute(.unique) var id: UUID
	var exercise: Exercise! = nil
	var timeInformation: TimeInformation
	var correctness: Double = 0
	@Relationship var multipleChoiceStatistic: MultipleChoiceStatistic?
	
	var score: Double? {
		if timeInformation.totalTime == 0 { return nil }
		return correctness * 100.0 / timeInformation.totalTime
	}
	
	var correctnessType: CorrectnessType {
		if correctness < Self.incorrectnessThreshold {
			return .incorrect
		}
		if correctness < Self.correctnessThreshold {
			return .partiallyCorrect
		}
		return .correct
	}
	
	init() {
		self.id = UUID()
		self.timeInformation = TimeInformation()
	}
	
}

enum CorrectnessType: String, CaseIterable {
	case correct = "Correct"
	case partiallyCorrect = "Partially correct"
	case incorrect = "Incorrect"
}

extension Statistic {
	
	var statisticType: StatisticType {
		get {
			if let multipleChoiceStatistic {
				return .multipleChoice(multipleChoiceStatistic)
			} else {
				return .none
			}
		}
		
		set {
			multipleChoiceStatistic = nil
			switch newValue {
			case .multipleChoice(let multipleChoiceStatistic):
				self.multipleChoiceStatistic = multipleChoiceStatistic
			default: break
			}
		}
	}
	
	var isCorrect: Bool {
		correctnessType == .correct
	}
	
	var isParitallyCorrect: Bool {
		correctnessType == .partiallyCorrect
	}
	
	var isIncorrect: Bool {
		correctnessType == .incorrect
	}
	
	var timeOut: Bool {
		exercise.hasTimeLimitation && timeInformation.totalTime > exercise.timeLimitation
	}
	
}

enum StatisticType: Hashable, CustomStringConvertible {
	
	case multipleChoice(MultipleChoiceStatistic)
	case indexCard
	case number
	case vocabulary
	case location
	case list
	case none
	
	var description: String {
		switch self {
		case .multipleChoice: "Multiple Choice"
		case .indexCard: "Index Card"
		case .number: "Number"
		case .vocabulary: "Vocabulary"
		case .location: "Location"
		case .list: "List"
		case .none: "None"
		}
	}
	
}
