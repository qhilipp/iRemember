//
//  Styles.swift
//  iRemember
//
//  Created by Privat on 05.09.23.
//

import Foundation
import SwiftUI

class Styles {
	
	static let positiveRatingColors: [Color] = [.red, .yellow, .green]
	static let negativeRatingColors: [Color] = Styles.positiveRatingColors.reversed()
	
	static func ratingColors(using greaterIsBetter: Bool) -> [Color] {
		greaterIsBetter ? positiveRatingColors : negativeRatingColors
	}
	
}
