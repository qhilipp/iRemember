//
//  ListItemView.swift
//  iRemember
//
//  Created by Privat on 27.07.23.
//

import Foundation
import SwiftUI

struct ListItemView: View {
	
	let itemType: ItemType
	
	var body: some View {
		HStack(spacing: 15) {
			switch imageType {
			case .photo(let img):
				img
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 60, height: 60, alignment: .center)
					.aspectRatio(contentMode: .fill)
					.clipShape(.rect(cornerRadius: 5))
			case .icon(let str):
				Image(systemName: str)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 55, height: 55)
					.foregroundStyle(Color.accentColor)
					.padding(.horizontal, 2.5)
			}
			VStack(alignment: .leading) {
				Text(title)
					.font(.system(.title3, design: .rounded, weight: .bold))
				Text(description)
					.foregroundStyle(.secondary)
			}
		}
	}
	
	var title: String {
		switch itemType {
		case .exercise(let exercise): return exercise.name
		case .learnlist(let learnlist): return learnlist.name
		}
	}
	
	var description: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		
		switch itemType {
		case .exercise(let exercise): return formatter.string(from: exercise.creationDate)
		case .learnlist(let learnlist): return formatter.string(from: learnlist.creationDate)
		}
	}
	
	var imageType: ImageType {
		if case .exercise(let exercise) = itemType {
			switch exercise.exerciseType {
			case .multipleChoice: return .icon("questionmark.app.dashed")
			case .indexCard: return .icon("square.text.square")
			case .number: return .icon("number")
			case .vocabulary: return .icon("character.book.closed")
			case .location: return .icon("map")
			case .none: return .icon("questionmark")
			}
		} else if case .learnlist(let learnlist) = itemType {
			if let image = learnlist.image {
				return .photo(image)
			}
		}
		return .icon("list.bullet")
	}
	
	enum ItemType {
		case exercise(_: Exercise)
		case learnlist(_: Learnlist)
	}
	
	enum ImageType {
		case photo(_: Image)
		case icon(_: String)
	}
	
}
