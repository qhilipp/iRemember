//
//  RollingText.swift
//  iRemember
//
//  Created by Privat on 12.08.23.
//

import Foundation
import SwiftUI

struct RollingText: View {
	
	@Binding var value: String
	@State var digits: [Character] = []
	
	var body: some View {
		HStack(spacing: 1) {
			ForEach(digits.indices, id: \.self) { i in
				Text(getText(at: i))
					.font(.system(.largeTitle, design: .rounded, weight: .bold))
					.optionalModifier(digits[i].isNumber) { view in
						view
							.opacity(0)
							.overlay {
								GeometryReader { proxy in
									VStack(spacing: 0) {
										ForEach(0...9, id: \.self) { digit in
											Text("\(digit)")
												.font(.system(.largeTitle, design: .rounded, weight: .bold))
												.frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
										}
									}
									.offset(y: getOffset(for: digits[i], height: proxy.size.height))
								}
								.clipped()
							}
					}
			}
		}
		.onAppear {
			digits = Array(repeating: "0", count: "\(value)".count)
			updateText()
		}
		.onChange(of: value) { oldValue, newValue in
			let extra = newValue.count - digits.count
			if extra > 0 {
				for _ in 0..<extra {
					digits.append("0")
				}
			} else if extra < 0 {
				for _ in 0..<(-extra) {
					digits.removeLast()
				}
			}
			updateText()
		}
	}
	
	func getText(at: Int) -> String {
		"\(digits[at])"
	}
	
	func updateText() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
			for (i, digit) in zip(0..<value.count, "\(value)") {
				withAnimation(.interpolatingSpring(stiffness: 50, damping: 10).delay(Double(value.count - i - 1) * 0.05)) {
					digits[i] = digit
				}
			}
		}
	}
	
	func getOffset(for char: Character, height: CGFloat) -> CGFloat {
		if char.isNumber {
			return CGFloat(-(Int("\(char)") ?? 0)) * height
		} else {
			return .zero
		}
	}
	
}
