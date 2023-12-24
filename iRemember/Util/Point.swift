//
//  Point.swift
//  iRemember
//
//  Created by Privat on 29.09.23.
//

import Foundation

struct Point: Identifiable, Hashable {
	
	var id: Point { self }
	let x, y: Double
	
	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
	
}
