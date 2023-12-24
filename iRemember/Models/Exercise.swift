//
//  StructureItem.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData

//protocol Exercise: Identifiable, Hashable {
//	
//	var id: UUID { get set }
//	var name: String { get set }
//	var creationDate: Date { get set }
//	var score: Double { get set }
//	var hastTimeLimitation: Bool { get set }
//	var timeLimitation: TimeInterval { get set }
//	
//}
//
//extension Exercise {
//	
//	var type: ExerciseType {
//		if let _ = self as? MultipleChoice {
//			.multipleChoice
//		} else {
//			.indexCard
//		}
//	}
//	
//}

@Model
final class Exercise: Identifiable, Hashable {
		
	@Attribute(.unique) var id: UUID
	var name: String = ""
	var creationDate: Date
	@Relationship var multipleChoiceExercise: MultipleChoice?
	var score: Double = 0
	var hasTimeLimitation: Bool = false
	var timeLimitation: TimeInterval = 60
	
	var type: ExerciseType {
		get {
			if let multipleChoiceExercise {
				return .multipleChoice(multipleChoiceExercise)
			} else {
				return .none
			}
		}
		
		set {
			multipleChoiceExercise = nil
			switch newValue {
			case .multipleChoice(let multipleChoiceExercise):
				self.multipleChoiceExercise = multipleChoiceExercise
			default: break
			}
		}
	}
	
	init() {
		self.id = UUID()
		self.creationDate = .now
	}
	
}

enum ExerciseType: Identifiable, Hashable, CustomStringConvertible, CaseIterable {
	
	case multipleChoice(MultipleChoice!)
	case indexCard(IndexCard!)
	case number
	case vocabulary
	case location
	case list
	case none
	
	static var allCases: [ExerciseType] {
		[
			.multipleChoice(nil),
			.indexCard(nil),
		]
	}
	
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
	
	var id: Self { self }
	
}
