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
	var exercises: [Exercise]?
	var containmentRule: String = "name == 'Test'"
	var name: String
	var detail: String
	var hasTimeLimitation: Bool
	var isTimeLimitationPerExercise: Bool
	var timeLimitation: TimeInterval
	var creationDate: Date
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
		
	@Transient private var exercisesCache: [Exercise]?
	var sortedExercises: [Exercise] {
		get {
			switch type {
			case .constant: exercises!.sorted(by: { $0.creationDate > $1.creationDate })
			case .dynamic:
				if let exercisesCache {
					exercisesCache
				} else {
					fetchExercises(with: containmentRule)
				}
			}
		}
		
		set {
			self.exercises = newValue
		}
	}
	
	func fetchExercises(with containmentRule: String) -> [Exercise] {
		((try? GlobalManager.shared.context.fetch(FetchDescriptor<Exercise>())) ?? []).filter { NSPredicate(format: containmentRule).evaluate(with: $0) }
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
	}
	
}

enum LearnlistType: Codable {
	case constant
	case dynamic
}
