//
//  Rating.swift
//  iRemember
//
//  Created by Privat on 26.12.23.
//

import Foundation
import SwiftUI

enum Rating: String, CaseIterable, Identifiable, Hashable {
	
	case wrong
	case ok
	case good
	case correct
	
	var id: Self { self }
	
	var color: Color {
		switch self {
		case .wrong: .red
		case .ok: .orange
		case .good: .yellow
		case .correct: .green
		}
	}
	
	var interval: Range<Double> {
		switch self {
		case .wrong: 0.0..<0.5
		case .ok: 0.5..<0.75
		case .good: 0.75..<0.99
		case .correct: 0.99..<1.1
		}
	}
	
	var correctness: Double {
		switch self {
		case .wrong: 0
		case .ok: 0.5
		case .good: 0.75
		case .correct: 1
		}
	}
	
}
