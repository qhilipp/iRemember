//
//  ContentView.swift
//  iRemember
//
//  Created by Privat on 22.07.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
		TabView {
			LearnlistListView()
				.tabItem {
					Label("Library", systemImage: "books.vertical.fill")
				}
			Text("Moinsen")
				.tabItem {
					Label("Explore", systemImage: "square.grid.2x2")
				}
			Text("Statistics")
				.tabItem {
					Label("Statistics", systemImage: "chart.bar.fill")
				}
		}
    }

}
