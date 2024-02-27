//
//  Learnlist.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData
import SwiftUI
import ImageCacheMacro

struct Test {
	var containmentRule: ((Exercise) -> Bool)?
}

@Model
final class Learnlist {
	
	@Attribute(.unique) var id: UUID
	var type: LearnlistType
	var exercises: [Exercise] = []
	var name: String
	var detail: String
	var hasTimeLimitation: Bool
	var isTimeLimitationPerExercise: Bool
	var timeLimitation: TimeInterval
	var creationDate: Date
	var sortBy: SortBy
	var ordering: Ordering
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
	
	var sortedExercises: [Exercise] {
		exercises
			.sorted {
				switch sortBy {
				case .name:
					$0.name < $1.name
				case .date:
					$0.creationDate < $1.creationDate
				case .score:
					$0.score < $1.score
				}
			}
			.apply([Exercise].reversed(_:), if: ordering == .descending)
	}
	
	init(name: String, detail: String = "", timeLimitation: TimeInterval? = nil, perExercise: Bool = false, imageData: Data? = nil) {
		self.id = UUID()
		self.name = name
		self.detail = detail
		self.hasTimeLimitation = timeLimitation != nil
		self.timeLimitation = timeLimitation ?? 60
		self.isTimeLimitationPerExercise = perExercise
		self.imageData = imageData
		self.creationDate = .now
		self.exercises = []
		self.type = .constant
		self.sortBy = .date
		self.ordering = .ascending
	}
	
}

enum LearnlistType: Codable {
	case constant
	case dynamic
}

enum SortBy: String, Codable, CaseIterable, Identifiable {
	var id: String {
		rawValue
	}
	case name
	case date
	case score
}

enum Ordering: String, Codable, CaseIterable, Identifiable {
	var id: String {
		rawValue
	}
	case ascending
	case descending
}
