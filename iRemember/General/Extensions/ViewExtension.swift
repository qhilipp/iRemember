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
		self.listRowInsets(EdgeInsets()).background(Color.systemGroupedBackground)
	}
	
	@ViewBuilder
	func exerciseSelectorSheet(isPresented: Binding<Bool>, selection: Binding<[Exercise]>) -> some View {
		self
			.sheet(isPresented: isPresented) {
				ExerciseSelectorView(selection: selection)
			}
	}
	
	@ViewBuilder
	func learnlistInfoSheet(isPresented: Binding<Bool>, learnlist: Learnlist) -> some View {
		self
			.sheet(isPresented: isPresented) {
				NavigationStack {
					LearnlistInfoView(for: learnlist)
				}
			}
	}
	
	func exerciseEditorSheet(isPresented: Binding<Bool>, for exercise: Exercise) -> some View {
		self
			.sheet(isPresented: isPresented) {
				ExerciseEditorView(exercise: exercise)
			}
	}
	
	func exerciseEditorSheet(isPresented: Binding<Bool>, in learnlist: Learnlist) -> some View {
		self
			.sheet(isPresented: isPresented) {
				ExerciseEditorView(in: learnlist)
			}
	}
	
	func learnlistEditorSheet(isPresented: Binding<Bool>, for learnlist: Learnlist? = nil, dismissAction: (() -> Void)? = nil) -> some View {
		self
			.sheet(isPresented: isPresented) {
				dismissAction?()
			} content: {
				LearnlistEditorView(learnlist: learnlist)
			}
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

