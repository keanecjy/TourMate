//
//  Repository.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

protocol Repository {

    func addItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String)

    func fetchItem(id: String) async -> (item: FirebaseAdaptedData?, errorMessage: String)

    func fetchItems(field: String, isEqualTo id: String) async -> (items: [FirebaseAdaptedData], errorMessage: String)

    func fetchItemsAndListen(field: String, arrayContains id: String,
                             callback: (@escaping ([FirebaseAdaptedData], String) async -> Void)) async

    func fetchItemsAndListen(field: String, isEqualTo id: String,
                             callback: (@escaping ([FirebaseAdaptedData], String) async -> Void)) async

    func fetchItemAndListen(id: String, callback: (@escaping (FirebaseAdaptedData?, String) async -> Void)) async

    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String)

    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String)
}
