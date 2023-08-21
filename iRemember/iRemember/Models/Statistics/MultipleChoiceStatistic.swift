//
//  MultipleChoiceStatistic.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import Foundation
import SwiftData

@Model
class MultipleChoiceStatistic {
	
	@Relationship var mcExercise: MultipleChoiceExercise!
	var map: [UUID: Bool] = [:]
	
	init() {}
	
}
