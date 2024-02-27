//
//  LearnlistRow.swift
//  iRemember
//
//  Created by Privat on 01.10.23.
//

import SwiftUI

struct LearnlistRow: View {
	
	let title: String
	let learnlists: [Learnlist]
	
    var body: some View {
		CardScrollView(title) {
			ForEach(learnlists) { learnlist in
				NavigationLink(value: learnlist) {
					VStack(alignment: .leading) {
						Group {
							if let image = learnlist.image {
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
							} else {
								Text("No Image")
							}
						}
						.frame(width: 200, height: 200)
						.clipShape(.rect(cornerRadius: 10))
						Text(learnlist.name)
							.lineLimit(1)
							.font(.headline)
						Text(learnlist.detail)
							.lineLimit(1)
							.font(.footnote)
							.foregroundStyle(.secondary)
					}
					.frame(width: 200)
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
    }
}
