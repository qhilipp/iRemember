//
//  FloatingPointExtension.swift
//  iRemember
//
//  Created by Privat on 05.09.23.
//

extension FloatingPoint {
	
	func map(fromLowerBound: Self, fromUpperBound: Self, toLowerBound: Self, toUpperBound: Self) -> Self {
		let positionInRange = (self - fromLowerBound) / (fromUpperBound - fromLowerBound)
		return (positionInRange * (toUpperBound - toLowerBound)) + toLowerBound
	}
	
	func map(from: ClosedRange<Self>, to: ClosedRange<Self>) -> Self {
		map(fromLowerBound: from.lowerBound, fromUpperBound: from.upperBound, toLowerBound: to.lowerBound, toUpperBound: to.upperBound)
	}
}
