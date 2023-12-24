//
//  TimeSelector.swift
//  iRemember
//
//  Created by Privat on 28.08.23.
//

import SwiftUI

struct TimeSelector: View {
	
	@Binding var time: TimeInterval
	@State private var hours: Int = 0
	@State private var minutes: Int = 0
	@State private var seconds: Int = 0
	
	init(time: Binding<TimeInterval>) {
		self._time = time
	}
	
    var body: some View {
		HStack {
			column(title: "Hours", $hours, range: 0..<10)
			column(title: "Minutes", $minutes, range: 0..<60)
			column(title: "Seconds", $seconds, range: 0..<60)
		}
		.onAppear {
			var totalTime = Int(self.time)
			hours = totalTime / 3600
			totalTime %= 3600
			minutes = totalTime / 60
			totalTime %= 60
			seconds = totalTime
		}
    }
	
	@ViewBuilder
	func column(title: String, _ value: Binding<Int>, range: Range<Int>) -> some View {
		VStack(spacing: 0) {
			Text(title)
			Picker("", selection: value) {
				ForEach(range) { i in
					Text("\(i)")
						.tag(i)
				}
			}
			.pickerStyle(.wheel)
		}
		.onChange(of: value.wrappedValue) { _, _ in
			calculateTime()
		}
	}
	
	func calculateTime() {
		time = TimeInterval(hours * 360 + minutes * 60 + seconds)
	}
	
}
