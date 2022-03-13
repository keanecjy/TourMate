//
//  FirebasePersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase

struct FirebasePersistenceManager<T: FirebaseAdaptedData>: PersistenceManager {
    let collectionId: String

    private let db = Firestore.firestore()

    @MainActor
    func fetchItems(field: String, id: String) async -> (items: [T], errorMessage: String) {
        var items: [T] = []
        var errorMessage = ""

        do {
            let query = db.collection(collectionId).whereField(field, arrayContains: id)
            let documents = try await query.getDocuments().documents
            items = documents.compactMap({ try? $0.data(as: T.self) })
        } catch {
            errorMessage = "Error fetching \(T.self): \(error)"
        }

        return (items, errorMessage)
    }

    @MainActor
    func addItem(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String) {
        var hasAddedItem = false
        var errorMessage = ""

        do {
            let newItemRef = db.collection(collectionId).document(id)
            try newItemRef.setData(from: item)
            hasAddedItem = true
            print("[FirebasePersistenceManager] Added \(T.self): \(newItemRef)")
        } catch {
            errorMessage = "[FirebasePersistenceManager] Error adding \(T.self): \(error)"
        }

        return (hasAddedItem, errorMessage)
    }

    @MainActor
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String) {
        var hasDeletedItem = false
        var errorMessage: String = ""

        do {
            let deletedItemRef = db.collection(collectionId).document(id)
            try await deletedItemRef.delete()
            hasDeletedItem = true
            print("[FirebasePersistenceManager] Deleted \(T.self): \(deletedItemRef)")
        } catch {
            errorMessage = "[FirebasePersistenceManager] Error deleting \(T.self): \(error)"
        }

        return (hasDeletedItem, errorMessage)
    }

    @MainActor
    func updateItem(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String) {
        let (hasAddedItem, errorMessage) = await addItem(id: id, item: item)
        return (hasAddedItem, errorMessage)
    }
}
