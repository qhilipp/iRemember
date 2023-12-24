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
	
}
