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

	@Relationship var front: IndexCardPage! = nil
	@Relationship var back: IndexCardPage! = nil
	
	init() {}
	
}

@Model
class IndexCardPage {
	
	var text: String
	
	@ImageCache
	@Attribute(.externalStorage) var imageData: Data?
	
	var hasInformation: Bool {
		!text.isEmpty || imageData != nil
	}
	
	init(text: String = "", imageData: Data? = nil) {
		self.text = text
		self.imageData = imageData
	}
	
}
