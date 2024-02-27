//
//  MultipleChoice.swift
//  iRemember
//
//  Created by Privat on 24.07.23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine
import ImageCacheMacro

@Model
final class MultipleChoice {
	
	var question: String = ""
	@Relationship var answers: [MultipleChoiceAnswer] = []
	@Relationship var statistics: [MultipleChoiceStatistic] = []
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
	
	init() {}
	
}

@Model
class MultipleChoiceAnswer {
	
	@Attribute(.unique) var id: UUID
	var text: String
	var explanation: String
	var isCorrect: Bool
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
	
	init(text: String = "", explanation: String = "", isCorrect: Bool = false, imageData: Data? = nil) {
		self.id = UUID()
		self.text = text
		self.explanation = explanation
		self.isCorrect = isCorrect
		self.imageData = imageData
	}
	
}
