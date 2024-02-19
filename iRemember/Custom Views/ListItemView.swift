//
//  ListItemView.swift
//  iRemember
//
//  Created by Privat on 27.07.23.
//

import Foundation
import SwiftUI
import SwiftData

struct ListItemView: View {
	
	let itemType: ItemType
	public static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
	
	init(for model: any PersistentModel) {
		itemType = switch model {
		case let exercise as Exercise: .exercise(exercise)
		case let learnlist as Learnlist: .learnlist(learnlist)
		case let statistic as Statistic: .statistic(statistic)
		case let practiceSession as PracticeSession: .practiceSession(practiceSession)
		default: .unknown(model)
		}
	}
	
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
		case .learnlist(let learnlist): learnlist.exercises.count
		case .statistic: nil
		case .practiceSession(let practiceSession): practiceSession.sortedStatistics.count
		case .unknown: nil
		}
	}
	
	var title: String {
		switch itemType {
		case .exercise(let exercise): exercise.name
		case .learnlist(let learnlist): learnlist.name
		case .statistic(let statistic): statistic.exercise.name
		case .practiceSession(let practiceSession): practiceSession.title
		case .unknown(let model): model.id.hashValue.description
		}
	}
	
	var description: String {
		switch itemType {
		case .exercise(let exercise): Self.formatter.string(from: exercise.creationDate)
		case .learnlist(let learnlist): Self.formatter.string(from: learnlist.creationDate)
		case .statistic(let statistic): Self.formatter.string(from: statistic.timeInformation.date)
		case .practiceSession(let practiceSession): practiceSession.id.uuidString
		case .unknown: ""
		}
	}
	
	var imageType: ImageType {
		switch itemType {
		case .exercise(let exercise):
			image(for: exercise)
		case .learnlist(let learnlist):
			if let image = learnlist.image {
				.photo(image)
			} else {
				.icon("list.bullet")
			}
		case .statistic(let statistic):
			image(for: statistic.exercise)
		case .practiceSession:
			.icon("list.bullet.clipboard")
		case .unknown:
			.icon("nosign")
		}
	}
	
	func image(for exercise: Exercise) -> ImageType {
		switch exercise.type {
		case .multipleChoice: ImageType.icon("questionmark.app.dashed")
		case .indexCard: .icon("square.text.square")
		case .number: .icon("number")
		case .vocabulary: .icon("character.book.closed")
		case .location: .icon("map")
		case .list: .icon("list.bullet.clipboard")
		case .none: .icon("nosign")
		}
	}
	
	enum ItemType {
		case exercise(_: Exercise)
		case learnlist(_: Learnlist)
		case statistic(_: Statistic)
		case practiceSession(_: PracticeSession)
		case unknown(_: any PersistentModel)
	}
	
	enum ImageType {
		case photo(_: Image)
		case icon(_: String)
	}
	
}
