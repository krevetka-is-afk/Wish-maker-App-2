//
//  WishEventModel.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 9/12/24.
//

import Foundation

struct WishEventModel: Codable {
    let id: UUID
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    
    init(id: UUID = UUID(), title: String, description: String, startDate: Date = Date(), endDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: startDate)
    }

    var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: endDate)
    }
    
    static func sortByStartDate(events: [WishEventModel]) -> [WishEventModel] {
        return events.sorted { $0.startDate < $1.startDate }
    }
}

