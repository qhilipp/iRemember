//
//  LearnlistEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import Foundation
import SwiftData

@Observable
class LearnlistEditorViewModel {
	
	var learnlist = Learnlist(name: "")
	var context: ModelContext!
	
	var canAdd: Bool {
		learnlist.name != ""
	}
	
	init() {
		
	}
	
	func addLearnlist() {
		context.insert(learnlist)
	}
	
}
