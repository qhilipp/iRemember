//
//  TimeInformation.swift
//  iRemember
//
//  Created by Privat on 15.09.23.
//

import Foundation

struct TimeInformation: Codable, Hashable {
	
	var date: Date
	var actionTimes: [Int: [TimeInterval]] = [:]
	var revealTime: TimeInterval = 0
	var finishTime: TimeInterval = 0
	var alertTime: TimeInterval = 0
	var menuTime: TimeInterval = 0
	var firstActionIndex: Int?
	
	private var lastRegistration: Date = .now
	
	var totalTime: TimeInterval {
		var sum = actionTime
		sum += revealTime
		sum += finishTime
		sum += alertTime
		sum += menuTime
		return sum
	}
	
	var actionTime: TimeInterval {
		var sum: TimeInterval = 0.0
		for list in actionTimes.values {
			sum += list.reduce(0.0, +)
		}
		return sum
	}
	
	var firstActionTime: TimeInterval {
		if let firstActionIndex {
			return actionTimes[firstActionIndex]?[0] ?? 0
		}
		return 0
	}
	
	init() {
		date = .now
	}
	
	mutating func registerActionTime(for index: Int) {
		if firstActionIndex == nil {
			firstActionIndex = index
		}
		if actionTimes[index] == nil {
			actionTimes[index] = []
		}
		actionTimes[index]?.append(Date.now.timeIntervalSince(lastRegistration))
		lastRegistration = .now
	}
	
	mutating func registerRevealTime() {
		revealTime = Date.now.timeIntervalSince(lastRegistration)
		lastRegistration = .now
	}
	
	mutating func registerFinishTime() {
		finishTime = Date.now.timeIntervalSince(lastRegistration)
		lastRegistration = .now
	}
	
//	enum TimeReference: TimeReferenceInformation {
//		case reading = TimeReferenceInformation(title: "Reading", keyPath: \.firstActionTime)
//		
//		
//	}
	struct TimeReferenceInformation {
		var title: String
		var keyPath: KeyPath<TimeInformation, TimeInterval>
	}
	
}
