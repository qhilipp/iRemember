//
//  LearnlistStatisticsViewModel.swift
//  iRemember
//
//  Created by Privat on 27.09.23.
//

import Foundation
import SwiftData

@Observable
class LearnlistStatisticsViewModel {
	
	@ObservationIgnored let learnlist: Learnlist
	var sessions: [PracticeSession] = []
	var searchTerm: String = ""
	var showAllStatistics = false
	
	var filteredSessions: [PracticeSession] {
		if searchTerm == "" {
			sessions
		} else {
			sessions.filter {
				if $0.id.uuidString.contains(searchTerm) {
					return true
				}
				return ListItemView.formatter.string(from: $0.date).contains(searchTerm)
			}
		}
	}
	
	init(learnlist: Learnlist) {
		self.learnlist = learnlist
		fetch()
	}
	
	func delete(offsets: IndexSet) {
		for offset in offsets {
			GlobalManager.shared.context.delete(sessions[offset])
		}
		sessions.remove(atOffsets: offsets)
	}
	
	func deleteAll() {
		for session in sessions {
			GlobalManager.shared.context.delete(session)
		}
		sessions.removeAll()
	}
	
	func deleteFiltered() {
		for session in filteredSessions {
			GlobalManager.shared.context.delete(session)
		}
		sessions.removeAll { filteredSessions.contains($0) }
	}
	
	func toggleShowAll() {
		showAllStatistics.toggle()
		fetch()
	}
	
	private func fetch() {
		let descriptor = FetchDescriptor<PracticeSession>()
		sessions = ((try? GlobalManager.shared.context.fetch(descriptor)) ?? []).filter {
			if showAllStatistics {
				return true
			}
			if case .learnlist(let learnlist) = $0.type {
				return learnlist == self.learnlist
			}
			return false
		}.sorted { $0.date < $1.date }
	}
	
}
