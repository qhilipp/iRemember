//
//  ViewExtension.swift
//  iRemember
//
//  Created by Privat on 26.07.23.
//

import Foundation
import SwiftUI

extension View {
	
	@ViewBuilder
	func optionalModifier<Content: View>(_ condition: Bool, body: (Self) -> Content, other: ((Self) -> Content)? = nil) -> some View {
		if condition {
			body(self)
		} else if let other {
			other(self)
		} else {
			self
		}
	}
	
	@ViewBuilder
	public func gradientForeground() -> some View {
		overlay {
			LinearGradient(colors: [.pink, .accentColor], startPoint: .leading, endPoint: .trailing)
				.mask(self)
		}
	}
	
	@ViewBuilder
	public func rounded() -> some View {
		self.clipShape(.rect(cornerRadius: 10))
	}
	
	@ViewBuilder
	public func ignoreCell() -> some View {
		self.listRowInsets(EdgeInsets()).background(Color(.systemGroupedBackground))
	}
	
}

extension Text {
	
	@ViewBuilder
	func highlighted() -> some View {
		self
			.font(.customSubTitle)
			.gradientForeground()
	}
	
}

extension TextField {
	
	public func important() -> some View {
		self
			.multilineTextAlignment(.center)
			.font(.title)
			.fontWeight(.heavy)
			.fontDesign(.rounded)
			.padding()
	}
	
}

