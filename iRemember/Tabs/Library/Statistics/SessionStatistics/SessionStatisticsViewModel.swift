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
	
	var practiceSession: PracticeSession
	
	var historicSessions: [PracticeSession] {
		let descriptor = FetchDescriptor<PracticeSession>()
		return ((try? GlobalManager.shared.context.fetch(descriptor)) ?? []).filter {
			guard case .learnlist(let ownLearnlist) = practiceSession.type else { return false }
			if case .learnlist(let learnlist) = $0.type {
				return learnlist == ownLearnlist
			}
			return false
		}
	}
	
	init(for practiceSession: PracticeSession) {
		self.practiceSession = practiceSession
	}
	
}
