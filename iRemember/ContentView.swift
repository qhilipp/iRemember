//
//  ContentView.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
	@Environment(\.modelContext) var context: ModelContext
	
    var body: some View {
		TabView {
			LearnlistListView()
				.tabItem {
					Label("Library", systemImage: "books.vertical.fill")
				}
			Text("Discover")
				.tabItem {
					Label("Explore", systemImage: "square.grid.2x2")
				}
			Text("Statistics")
				.tabItem {
					Label("Profile", systemImage: "person.crop.circle")
				}
			#if DEBUG
			AllModelsView()
				.tabItem {
					Label("Debug", systemImage: "ladybug.circle")
				}
			#endif
		}
		.onAppear {
			GlobalManager.shared.context = context
		}
    }

}
