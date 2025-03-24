//
//  WishViewModel.swift
//  serastvorovPW3
//
//  Created by Сергей Растворов on 3/24/25.
//

import Foundation

class WishViewModel {
    private var wishes: [WishEventModel] = []
    private let calendarManager = CalendarManager()
    var onWishesUpdate: (() -> Void)?
    var onCalendarAccessRequested: ((Bool) -> Void)?
    
    private let maxWishes = 10
    
    init() {
        loadWishes()
    }
    
    func getWishes() -> [WishEventModel] {
        return wishes
    }
    
    func canAddMoreWishes() -> Bool {
        return wishes.count < maxWishes
    }
    
    func getRemainingWishSlots() -> Int {
        return maxWishes - wishes.count
    }
    
    func addWish(_ wish: WishEventModel) {
        wishes.append(wish)
        saveWishes()
        onWishesUpdate?()
    }
    
    func addWish(title: String, description: String, startDate: Date = Date(), endDate: Date = Date()) {
        let wish = WishEventModel(title: title, description: description, startDate: startDate, endDate: endDate)
        addWish(wish)
    }
    
    func updateWish(_ updatedWish: WishEventModel) {
        if let index = wishes.firstIndex(where: { $0.id == updatedWish.id }) {
            wishes[index] = updatedWish
            saveWishes()
            onWishesUpdate?()
        }
    }
    
    func deleteWish(at index: Int) {
        guard index >= 0 && index < wishes.count else { return }
        wishes.remove(at: index)
        saveWishes()
        onWishesUpdate?()
    }
    
    func requestCalendarAccess() {
        calendarManager.requestAccess { [weak self] granted in
            self?.onCalendarAccessRequested?(granted)
        }
    }
    
    func addWishToCalendar(_ wish: WishEventModel, completion: @escaping (Bool) -> Void) {
        calendarManager.addEvent(from: wish) { success in
            completion(success)
        }
    }
    
    private func saveWishes() {
        if let encoded = try? JSONEncoder().encode(wishes) {
            UserDefaults.standard.set(encoded, forKey: "savedWishes")
        }
    }
    
    private func loadWishes() {
        if let data = UserDefaults.standard.data(forKey: "savedWishes"),
           let decoded = try? JSONDecoder().decode([WishEventModel].self, from: data) {
            wishes = decoded
        }
    }
} 
