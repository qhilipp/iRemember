//
//  DateExtension.swift
//  iRemember
//
//  Created by Privat on 10.08.23.
//

import Foundation

extension Date {
	
	var startOfDay: Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .weekOfYear, .day], from: self)) else {
			fatalError("Unable to get start date from date")
		}
		return date
	}
	
	var startOfWeek: Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .weekOfYear], from: self)) else {
			fatalError("Unable to get start date from date")
		}
		return date
	}
	
	var startOfMonth: Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
			fatalError("Unable to get start date from date")
		}
		return date
	}
	
	var startOfYear: Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: self)) else {
			fatalError("Unable to get start date from date")
		}
		return date
	}
	
}
