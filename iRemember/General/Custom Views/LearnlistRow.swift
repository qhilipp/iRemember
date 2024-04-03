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
					LabeledImage(learnlist.image, aspectRatio: 1) {
						Text(learnlist.name)
							.lineLimit(1)
							.font(.headline)
						Text(learnlist.detail)
							.lineLimit(1)
							.font(.footnote)
							.foregroundStyle(.secondary)
					}
					.frame(width: 250)
					.foregroundStyle(.white)
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
    }
}
