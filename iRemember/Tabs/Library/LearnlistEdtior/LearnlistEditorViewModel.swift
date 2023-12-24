//
//  LearnlistEditorViewModel.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class LearnlistEditorViewModel {
	
	var learnlist: Learnlist
	let isCreationMode: Bool
	
	var canAdd: Bool {
		learnlist.name != ""
	}
	
	var ctaText: String {
		isCreationMode ? "Add" : "Done"
	}
	
	var principalText: String {
		isCreationMode ? "Add Learnlist" : "Edit Learnlist"
	}
	
	var isDynamic: Bool {
		get {
			learnlist.type == .dynamic
		}
		
		set {
			learnlist.type = newValue ? .dynamic : .constant
		}
	}
	
	init(_ learnlist: Learnlist?) {
		self.isCreationMode = learnlist == nil
		if let learnlist {
			self.learnlist = learnlist
		} else {
			self.learnlist = Learnlist(name: "")
		}
	}
	
	func addLearnlist() {
		GlobalManager.shared.context.insert(learnlist)
	}
	
}
