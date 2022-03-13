//
//  PersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

protocol PersistenceManager {
    associatedtype T: Codable

    func fetchItems(field: String, id: String) async -> (trips: [T], errorMessage: String)
    func addItem(item: T) async -> (hasAddedItem: Bool, errorMessage: String)
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String)
    func updateItem(item: T) async -> (hasUpdatedItem: Bool, errorMessage: String)
}
