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
    func addItem(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        
        do {
            let itemRef = db.collection(collectionId).document(id)
            try itemRef.setData(from: item)

            print("[FirebasePersistenceManager] Added \(T.self): \(itemRef)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error adding \(T.self): \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func fetchItem(id: String) async -> (item: T?, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }
        
        do {
            let itemRef = db.collection(collectionId).document(id)
            let item = try await itemRef.getDocument().data(as: T.self)

            print("[FirebasePersistenceManager] Fetched \(T.self): \(itemRef)")

            return (item, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching \(T.self): \(error)"
            return (nil, errorMessage)
        }
    }

    @MainActor
    func fetchItems(field: String, arrayContains id: String) async -> (items: [T], errorMessage: String) {
        let query = db.collection(collectionId).whereField(field, arrayContains: id)
        return await fetchItems(from: query)
    }

    @MainActor
    func fetchItems(field: String, isEqualTo id: String) async -> (items: [T], errorMessage: String) {
        let query = db.collection(collectionId).whereField(field, isEqualTo: id)
        return await fetchItems(from: query)
    }

    @MainActor
    private func fetchItems(from query: Query) async -> (items: [T], errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        do {
            let documents = try await query.getDocuments().documents
            let items = documents.compactMap({ try? $0.data(as: T.self) })

            print("[FirebasePersistenceManager] Fetched \(T.self): \(query)")

            return (items, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching \(T.self): \(error)"
            return ([], errorMessage)
        }
    }

    @MainActor
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        
        do {
            let deletedItemRef = db.collection(collectionId).document(id)
            try await deletedItemRef.delete()

            print("[FirebasePersistenceManager] Deleted \(T.self): \(deletedItemRef)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error deleting \(T.self): \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func updateItem(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String) {
        let (hasAddedItem, errorMessage) = await addItem(id: id, item: item)
        return (hasAddedItem, errorMessage)
    }
}
