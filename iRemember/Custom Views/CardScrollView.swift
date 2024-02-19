//
//  CardScrollView.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import Foundation
import SwiftUI

struct CardScrollView<Content: View, NavigationItem: Hashable>: View {
	
	let title: String?
	let navigationItem: NavigationItem?
	let content: () -> Content
	
	init(_ title: String? = nil, navigationItem: NavigationItem? = nil as Int?, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.navigationItem = navigationItem
		self.content = content
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			if let title {
				if let navigationItem {
					NavigationLink(title, value: navigationItem)
						.font(.largeTitle)
				} else {
					Text(title)
						.font(.largeTitle)
				}					
			}
			ScrollView(.horizontal) {
				HStack(spacing: 0) {
					content()
				}
				#if os(iOS)
				.scrollTargetLayout()
				#endif
			}
			#if os(iOS)
			.scrollTargetBehavior(.paging)
			.scrollIndicators(.hidden)
			#endif
		}
	}
	
}
