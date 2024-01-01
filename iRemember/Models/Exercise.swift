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
	@Relationship(.unique, deleteRule: .cascade) var statistics: [Statistic] = []
	@Relationship var multipleChoice: MultipleChoice?
	@Relationship var indexCard: IndexCard?
	var score: Double = 0
	var hasTimeLimitation: Bool = false
	var timeLimitation: TimeInterval = 60
	
	var type: ExerciseType {
		get {
			if let multipleChoice {
				.multipleChoice(multipleChoice)
			} else if let indexCard {
				.indexCard(indexCard)
			} else {
				.none
			}
		}
		
		set {
			multipleChoice = nil
			switch newValue {
			case .multipleChoice(let multipleChoice):
				self.multipleChoice = multipleChoice
			case .indexCard(let indexCard):
				self.indexCard = indexCard
			default: break
			}
		}
	}
	
	init() {
		self.id = UUID()
		self.creationDate = .now
	}
	
	func matches(searchTerm: String) -> Bool {
		if name.lowercased().contains(searchTerm.lowercased()) ||
			creationDate.description.lowercased().contains(searchTerm.lowercased()) ||
			type.description.lowercased().contains(searchTerm.lowercased())
		{
			true
		} else {
			switch type {
			case .multipleChoice(let multipleChoice):
				multipleChoice!.question.lowercased().contains(searchTerm.lowercased()) ||
				multipleChoice!.answers.first {
					!$0.text.isEmpty && $0.text.lowercased().contains(searchTerm.lowercased())
				} != nil
			case .indexCard(let indexCard):
				indexCard!.front.text.lowercased().contains(searchTerm.lowercased()) ||
				indexCard!.back.text.lowercased().contains(searchTerm.lowercased())
			default: false
			}
		}
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
