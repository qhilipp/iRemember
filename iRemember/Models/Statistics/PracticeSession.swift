//
//  PracticeSession.swift
//  iRemember
//
//  Created by Privat on 29.08.23.
//

import Foundation
import SwiftData

@Model
class PracticeSession {
	
	let id: UUID
	@Relationship(.unique, deleteRule: .cascade) private var statistics: [Statistic] = []
	
	private var learnlist: Learnlist?
	private var queue: [Exercise]?
	
	var type: PracticeSessionType {
		get {
			if let learnlist {
				return .learnlist(learnlist)
			} else if let queue {
				return .queue(queue)
			}
			return .queue([])
		}
		
		set {
			switch newValue {
			case .learnlist(let learnlist): self.learnlist = learnlist
			case .queue(let exercises): self.queue = exercises
			}
		}
	}
	
	var exercises: [Exercise] {
		type.exercises
	}
	
	var date: Date? {
		statistics.first?.timeInformation.date
	}
	
	var title: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		
		let date = if let date { formatter.string(from: date) } else { "Unknown" }
		let name = if let learnlist { learnlist.name } else { "Queue" }
		return "\(name) - \(date)"
	}
	
	var sortedStatistics: [Statistic] {
		statistics.sorted(by: { $0.hasChanges == $1.hasChanges/*$0.timeInformation?.date < $1.timeInformation?.date*/ })
	}
	
	init(_ type: PracticeSessionType) {
		self.id = UUID()
		self.type = type
	}
	
	func register(_ statistic: Statistic) {
		statistics.append(statistic)
	}
	
	subscript(_ index: Int) -> Statistic {
		sortedStatistics[index]
	}
	
}

enum PracticeSessionType {
	
	case learnlist(_ learnlist: Learnlist)
	case queue(_ exercises: [Exercise])
	
	var exercises: [Exercise] {
		switch self {
		case .learnlist(let learnlist): learnlist.exercises
		case .queue(let exercises): exercises
		}
	}
	
}
