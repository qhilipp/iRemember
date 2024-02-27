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
	
	@Relationship var multipleChoice: MultipleChoice! = nil
	var map: [UUID: Bool] = [:]
	
	init() {}
	
}
