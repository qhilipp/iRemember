//
//  StatisticsCard.swift
//  iRemember
//
//  Created by Privat on 25.09.23.
//

import SwiftUI

struct StatisticsCard<Header: View, Content: View>: View {
	
	private let title: String
	private let content: () -> Content
	private let header: () -> Header
	
	init(_ title: String, @ViewBuilder header: @escaping () -> Header = { Spacer() }, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.header = header
		self.content = content
	}
	
    var body: some View {
		Section {
			GroupBox {
				VStack {
					HStack(alignment: .firstTextBaseline) {
						Text(title)
							.lineLimit(3)
							.font(.system(.largeTitle, design: .rounded, weight: .bold))
						header()
					}
					content()
				}
			}
			.ignoreCell()
			.backgroundStyle(Color(.secondarySystemGroupedBackground))
			.padding(.horizontal)
			.containerRelativeFrame(.horizontal)
			.navigationBarTitleDisplayMode(.inline)
			.background(Color(.systemGroupedBackground))
		}
    }
}
