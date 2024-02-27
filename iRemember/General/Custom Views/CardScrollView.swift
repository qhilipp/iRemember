//
//  CardScrollView.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import Foundation
import SwiftUI

struct CardScrollView<Content: View, Title: View>: View {
	
	let content: () -> Content
	let title: () -> Title
	
	init(@ViewBuilder title: @escaping () -> Title, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.content = content
	}
	
	init(_ title: String = "", @ViewBuilder content: @escaping () -> Content) where Title == Text {
		self.init(title: { Text(title).font(.title) }, content: content)
	}
	
	init(@ViewBuilder content: @escaping () -> Content) where Title == EmptyView {
		self.init(title: { EmptyView() }, content: content)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			title()
			ScrollView(.horizontal) {
				HStack {
					content()
				}
				.scrollTargetLayout()
			}
			.scrollTargetBehavior(.viewAligned)
			.scrollIndicators(.hidden)
		}
	}
	
}
