//
//  LearnlistManager.swift
//  iRemember
//
//  Created by Privat on 28.07.23.
//

import Foundation
import SwiftUI
import SwiftData

final class LearnlistManager: ObservableObject {
	
	@Published var path = NavigationPath()
	public var context: ModelContext!
	private var exercises: [Exercise] = []
	private var sessionExercises: [Exercise] = []
	private var queue: [Exercise] = []
	private var stats: [Statistic] = []
	private var sessionStart: Date?
	
	public var isEmpty: Bool {
		exercises.isEmpty
	}
	
	public var sessionStatistic: SessionStatistic? {
		if isEmpty {
			let sessionStatistic = SessionStatistic(time: Date.now.timeIntervalSince(sessionStart!))
			
			context.insert(sessionStatistic)
			for stat in stats {
				context.insert(stat)
				sessionStatistic.stats.append(stat)
			}
			
			do {
				try context.save()
			} catch {
				fatalError(error.localizedDescription)
			}
			
			stats = []
			sessionStart = nil
			
			return sessionStatistic
		}
		return nil
	}
	
	public func next(with statistic: Statistic? = nil) -> Exercise? {
		if let statistic {
			stats.append(statistic)
		}
		if !isEmpty {
			return exercises.removeFirst()
		}
		return nil
	}
	
	public func startSession() {
		sessionStart = .now
		exercises = queue
		if let exercise = next() {
			path.append(exercise)
		}
	}
	
	public func startSession(with exercises: [Exercise]) {
		sessionStart = .now
		self.exercises = exercises
		if let exercise = next() {
			path.append(exercise)
		}
	}
	
}

// MARK: Queue
extension LearnlistManager {
	
	public func insert(_ exercise: Exercise) {
		queue.append(exercise)
	}
	
	public func insert(_ exercises: [Exercise]) {
		self.queue.append(contentsOf: exercises)
	}
	
	public func dequeue() -> Exercise {
		queue.removeFirst()
	}
	
	public func clear() {
		queue.removeAll()
	}
	
}
