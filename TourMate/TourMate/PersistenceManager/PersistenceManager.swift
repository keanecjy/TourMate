//
//  PersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

protocol PersistenceManager {

    func addItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String)

    func fetchItem<T: FirebaseAdaptedData>(id: String) async -> (item: T?, errorMessage: String)

    func fetchItems<T: FirebaseAdaptedData>(field: String, arrayContains id: String) async -> (items: [T], errorMessage: String)

    func fetchItems<T: FirebaseAdaptedData>(field: String, isEqualTo id: String) async -> (items: [T], errorMessage: String)

    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String)

    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String)
}
