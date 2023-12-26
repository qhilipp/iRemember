//
//  ArrayExtension.swift
//  iRemember
//
//  Created by Privat on 31.08.23.
//

import Foundation
import UIKit
import SwiftUI

extension [Double] {
	
	func avg() -> Double? {
		guard count > 0 else { return nil }
		return reduce(0, +) / Double(count)
	}
	
	var median: Double? {
		guard count > 0 else { return nil }
		let arr = self.sorted()
		if arr.count.isMultiple(of: 2) {
			return [arr[Int(floor(Double(count) / 2.0))], arr[Int(ceil(Double(count) / 2.0))]].avg()
		} else {
			return arr[count/2]
		}
	}
	
}

extension [Color] {
	
	func interpolatedValue(at fraction: Double) -> Color? {
		if let uiColor = map({ UIColor($0) }).interpolateValue(at: fraction) {
			return Color(uiColor)
		}
		return nil
	}
	
}

extension [UIColor] {
	
	func interpolateValue(at fraction: Double) -> UIColor? {
		guard !isEmpty, fraction >= 0, fraction <= 1 else {
			return nil
		}
		
		let index1 = Int(fraction * Double(count - 1))
		
		let index2 = Swift.min(index1 + 1, count - 1)
		
		let fractionBetweenColors = fraction * Double(count - 1) - Double(index1)
		
		let color1 = self[index1]
		let color2 = self[index2]
		
		var red1: CGFloat = 0
		var green1: CGFloat = 0
		var blue1: CGFloat = 0
		var alpha1: CGFloat = 0
		
		var red2: CGFloat = 0
		var green2: CGFloat = 0
		var blue2: CGFloat = 0
		var alpha2: CGFloat = 0
		
		color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
		color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
		
		let interpolatedRed = red1 + CGFloat(fractionBetweenColors) * (red2 - red1)
		let interpolatedGreen = green1 + CGFloat(fractionBetweenColors) * (green2 - green1)
		let interpolatedBlue = blue1 + CGFloat(fractionBetweenColors) * (blue2 - blue1)
		let interpolatedAlpha = alpha1 + CGFloat(fractionBetweenColors) * (alpha2 - alpha1)
		
		return UIColor(red: interpolatedRed, green: interpolatedGreen, blue: interpolatedBlue, alpha: interpolatedAlpha)
	}
	
}

extension [PracticeSession] {
	
	var statistics: [Statistic] {
		reduce([]) { partialResult, practiceSession in
			var copy = partialResult
			copy.append(contentsOf: practiceSession.sortedStatistics)
			return copy
		}
	}
	
}

extension [Rating] {
	
	var colors: [Color] {
		map { $0.color }
	}
	
}
