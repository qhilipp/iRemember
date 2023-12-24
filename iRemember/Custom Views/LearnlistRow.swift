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
		CardScrollView(title, navigationItem: learnlists) {
			ForEach(learnlists) { learnlist in
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
						.font(.headline)
					Text(learnlist.detail)
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
		}
    }
}
