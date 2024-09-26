//
//  StructureItem.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable, Hashable {
		
	@Attribute(.unique) var id: UUID
	var name: String
	var creationDate: Date
	@Relationship var mcExercise: MultipleChoiceExercise?

	var exerciseType: ExerciseType {
		get {
			if let mcExercise {
				return .multipleChoice(mcExercise)
			} else {
				return .none
			}
		}
		
		set {
			mcExercise = nil
			switch newValue {
			case .multipleChoice(let mcExercise):
				self.mcExercise = mcExercise
			default: break
			}
		}
	}
	
	init(name: String) {
		self.id = UUID()
		self.name = name
		self.creationDate = .now
	}
	
}

enum ExerciseType: Hashable, CustomStringConvertible {
	
	case multipleChoice(MultipleChoiceExercise)
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
