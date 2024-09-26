//
//  SessionStatistic.swift
//  iRemember
//
//  Created by Privat on 09.08.23.
//

import Foundation
import SwiftData

@Model
class SessionStatistic {
	
	@Relationship var stats: [Statistic] = []
	var time: TimeInterval
	
	var avgScore: Double {
		var avgScore = 0.0
		for stat in stats {
			avgScore += stat.score
		}
		return avgScore / Double(stats.count)
	}
	
	init(time: TimeInterval) {
		self.time = time
	}
	
}
