//
//  Statistic.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import Foundation
import SwiftData

@Model
class Statistic: Identifiable, Hashable {
	
	@Attribute(.unique) var id: UUID
	@Relationship var exercise: Exercise
	var date: Date
	var time: TimeInterval
	@Relationship var mcStatistic: MultipleChoiceStatistic? = nil
	
	var score: Double {
		time
	}
	
	init(for exercise: Exercise, startedOn startDate: Date) {
		self.id = UUID()
		self.exercise = exercise
		self.date = .now
		self.time = Date.now.timeIntervalSince(startDate)
	}
	
}

extension Statistic {
	
	var statisticType: StatisticType {
		get {
			if let mcStatistic {
				return .multipleChoice(mcStatistic)
			} else {
				return .none
			}
		}
		
		set {
			mcStatistic = nil
			switch newValue {
			case .multipleChoice(let mcStatistic):
				self.mcStatistic = mcStatistic
			default: break
			}
		}
	}
	
}

enum StatisticType: Hashable, CustomStringConvertible {
	
	case multipleChoice(MultipleChoiceStatistic)
	case indexCard
	case number
	case vocabulary
	case location
	case none
	
	var description: String {
		switch self {
		case .multipleChoice: "Multiple Choice"
		case .indexCard: "Index Card"
		case .number: "Number"
		case .vocabulary: "Vocabulary"
		case .location: "Location"
		case .none: "None"
		}
	}
	
}
