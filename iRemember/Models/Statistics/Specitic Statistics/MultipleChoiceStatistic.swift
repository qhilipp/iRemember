//
//  MultipleChoiceStatistic.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import Foundation
import SwiftData

@Model
final class MultipleChoiceStatistic {
	
	@Relationship var multipleChoiceExercise: MultipleChoice! = nil
	var map: [UUID: Bool] = [:]
	
	init() {}
	
}
