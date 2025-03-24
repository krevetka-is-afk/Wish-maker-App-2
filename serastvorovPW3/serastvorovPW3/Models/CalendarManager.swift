//
//  CalendarManager.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 9/12/24.
//

import EventKit
import Foundation

class CalendarManager {
    private let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting calendar access: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(granted)
            }
        }
    }
    
    func addEvent(from wish: WishEventModel, completion: @escaping (Bool) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = wish.title
        event.notes = wish.description
        event.startDate = wish.startDate
        event.endDate = wish.endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true)
        } catch {
            print("Error saving event: \(error.localizedDescription)")
            completion(false)
        }
    }
}
