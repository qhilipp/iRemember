//
//  IndexCard.swift
//  iRemember
//
//  Created by Privat on 03.10.23.
//

import Foundation
import SwiftData
import ImageCacheMacro
import SwiftUI

@Model
class IndexCard {

	@Relationship(.unique) var front: IndexCardPage! = nil
	@Relationship(.unique) var back: IndexCardPage! = nil
	
	init() {}
	
}

@Model
class IndexCardPage {
	
	var text: String
	var explanation: String
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
	
	var hasInformation: Bool {
		!text.isEmpty || imageData != nil
	}
	
	init(text: String = "", explanation: String = "", imageData: Data? = nil) {
		self.text = text
		self.explanation = explanation
		self.imageData = imageData
	}
	
}
