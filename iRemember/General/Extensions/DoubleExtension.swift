//
//  DoubleExtension.swift
//  iRemember
//
//  Created by Privat on 11.08.23.
//

import Foundation

extension Double {
	
	func rounded(to digits: Int) -> Double {
		let p = NSDecimalNumber(decimal: pow(10, digits)).doubleValue
		return (self * p).rounded() / p
	}
	
	var rating: Rating {
		switch self {
		case Rating.wrong.interval: .wrong
		case Rating.ok.interval: .ok
		case Rating.good.interval: .good
		case Rating.correct.interval: .correct
		default: .wrong
		}
	}
	
}
