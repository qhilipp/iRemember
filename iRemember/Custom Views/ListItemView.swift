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
	public static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
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
			HStack {
				VStack(alignment: .leading) {
					Text(title)
						.font(.system(.title3, design: .rounded, weight: .bold))
						.lineLimit(1)
						.minimumScaleFactor(0.3)
					Text(description)
						.foregroundStyle(.secondary)
				}
				if let itemCount {
					Spacer()
					Text("\(itemCount)")
						.foregroundStyle(.secondary)
				}
			}
		}
	}
	
	var itemCount: Int? {
		switch itemType {
		case .exercise: nil
		case .learnlist(let learnlist): learnlist.sortedExercises.count
		case .practiceSession(let practiceSession): practiceSession.sortedStatistics.count
		}
	}
	
	var title: String {
		switch itemType {
		case .exercise(let exercise): exercise.name
		case .learnlist(let learnlist): learnlist.name
		case .practiceSession(let practiceSession): practiceSession.title
		}
	}
	
	var description: String {
		switch itemType {
		case .exercise(let exercise): "\(Self.formatter.string(from: exercise.creationDate)) • \(exercise.score)"
		case .learnlist(let learnlist): "\(Self.formatter.string(from: learnlist.creationDate))"
		case .practiceSession(let practiceSession): practiceSession.id.uuidString
		}
	}
	
	var imageType: ImageType {
		if case .exercise(let exercise) = itemType {
			switch exercise.type {
			case .multipleChoice: ImageType.icon("questionmark.app.dashed")
			case .indexCard: .icon("square.text.square")
			case .number: .icon("number")
			case .vocabulary: .icon("character.book.closed")
			case .location: .icon("map")
			case .list: .icon("list.bullet.clipboard")
			case .none: .icon("nosign")
			}
		} else if case .learnlist(let learnlist) = itemType {
			if let image = learnlist.image {
				.photo(image)
			} else {
				.icon("list.bullet")
			}
		} else {
			.icon("nosign")
		}
	}
	
	enum ItemType {
		case exercise(_: Exercise)
		case learnlist(_: Learnlist)
		case practiceSession(_: PracticeSession)
	}
	
	enum ImageType {
		case photo(_: Image)
		case icon(_: String)
	}
	
}
