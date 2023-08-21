//
//  SessionStatisticsViewModel.swift
//  iRemember
//
//  Created by Privat on 08.08.23.
//

import Foundation
import SwiftData

@Observable
class SessionStatisticsViewModel {
	
	var sessionStatistic: SessionStatistic
	
	var scoreTableData: [TableData<Double>] {
		[
			.init(name: "min", result: 12, improvement: 35),
			.init(name: "avg", result: 34, improvement: 34),
			.init(name: "max", result: 52, improvement: -4),
			.init(name: "first", result: 13, improvement: 86),
			.init(name: "last", result: 52, improvement: -4)
		]
	}
	
	init(for sessionStatistic: SessionStatistic) {
		self.sessionStatistic = sessionStatistic
	}
	
}

struct TableData<Data: CustomStringConvertible>: Identifiable {
	
	public var id: String { name }
	let name: String
	let result: Data
	let improvement: Int
	
}
