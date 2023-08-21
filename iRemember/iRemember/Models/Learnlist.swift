//
//  Learnlist.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Learnlist {
	
	@Attribute(.unique) var id: UUID
	var name: String
	var detail: String
	@Attribute(.externalStorage) var imageData: Data?
	var creationDate: Date
	@Relationship var exercises: [Exercise] = []
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
	
	init(name: String, detail: String = "", imageData: Data? = nil) {
		self.id = UUID()
		self.name = name
		self.detail = detail
		self.imageData = imageData
		self.creationDate = .now
	}
	
	public static var dummy: Learnlist {
		Learnlist(name: "Learnlist Test", detail: "This is a dummy Learnlist :)")
	}
	
}
