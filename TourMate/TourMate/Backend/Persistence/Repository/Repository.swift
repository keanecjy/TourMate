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

    func fetchItemsAndListen(field: String, arrayContains id: String) async

    func fetchItemsAndListen(field: String, isEqualTo id: String) async

    func fetchItemsAndListen(field1: String, isEqualTo id1: String, field2: String, isEqualTo id2: Int) async

    func fetchItemAndListen(id: String) async

    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String)

    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String)

    var eventDelegate: FirebaseEventDelegate? { get set }

    func detachListener()
}
