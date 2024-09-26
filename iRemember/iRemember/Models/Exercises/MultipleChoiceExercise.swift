//
//  MultipleChoiceExercise.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
class MultipleChoiceExercise {
	
	var question: String
	@Relationship var exercise: Exercise
	@Relationship var answers: [MultipleChoiceAnswer] = []
	@Relationship var statistics: [MultipleChoiceStatistic] = []
	@Attribute(.externalStorage) var imageData: Data? = nil
	@Transient var lastHash: Int = 0
	@Transient private var imageCache: Image? = nil
	
	var image: Image? {
		get {
			if let imageData {
				if imageData.hashValue != lastHash {
					imageCache = imageData.image
					lastHash = imageData.hashValue
				}
				return imageCache
			}
			return nil
		}
	}
	
	init(exercise: Exercise, question: String) {
		self.exercise = exercise
		self.question = question
	}
	
}

@Model
class MultipleChoiceAnswer {
	
	var id: UUID
	var text: String
	var explanation: String
	var isCorrect: Bool
	var imageData: Data?
	@Transient private var lastHash: Int = 0
	@Transient private var imageCache: Image?
	
	var image: Image? {
		get {
			if let imageData {
				if imageData.hashValue != lastHash {
					imageCache = imageData.image
					lastHash = imageData.hashValue
				}
				return imageCache
			}
			return nil
		}
	}
	
	init(text: String = "", explanation: String = "", isCorrect: Bool = false, imageData: Data? = nil) {
		self.id = UUID()
		self.text = text
		self.explanation = explanation
		self.isCorrect = isCorrect
		self.imageData = imageData
	}
	
}
