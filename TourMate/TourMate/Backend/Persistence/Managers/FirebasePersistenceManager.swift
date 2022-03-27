//
//  FirebasePersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase

struct FirebasePersistenceManager: PersistenceManager {
    let collectionId: String

    private let db = Firestore.firestore()

    @MainActor
    func addItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let itemRef = db.collection(collectionId).document(id)
            let any = AnyFirebaseAdaptedData(item)
            try itemRef.setData(from: any)

            print("[FirebasePersistenceManager] Added or Updated \(T.self): \(id)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error adding \(T.self): \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func fetchItem(id: String) async -> (item: FirebaseAdaptedData?, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        do {
            let itemRef = db.collection(collectionId).document(id)
            let item = try await itemRef.getDocument().data(as: AnyFirebaseAdaptedData.self).map { $0.base }

            print("[FirebasePersistenceManager] Fetched Item: \(id)")

            return (item, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching: \(error)"
            return (nil, errorMessage)
        }
    }

    @MainActor
    func fetchItems(field: String, arrayContains id: String) async -> (items: [FirebaseAdaptedData],
                                                                            errorMessage: String) {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), arrayContains: id)

        print("[FirebasePersistenceManager] Fetched Items with Field: \(field), arrayContains: \(id)")

        return await fetchItems(from: query)
    }

    @MainActor
    func fetchItems(field: String, isEqualTo id: String) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), isEqualTo: id)

        print("[FirebasePersistenceManager] Fetched Items with Field: \(field), isEqualTo: \(id)")

        return await fetchItems(from: query)
    }

    @MainActor
    private func fetchItems(from query: Query) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        do {
            let documents = try await query.getDocuments().documents
            let items = documents.compactMap({ try? $0.data(as: AnyFirebaseAdaptedData.self) }).map { $0.base }

            print("[FirebasePersistenceManager] Fetched Items: \(documents)")

            return (items, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching: \(error)"
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

            print("[FirebasePersistenceManager] Deleted \(FirebaseAdaptedData.self): \(id)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error deleting: \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String) {
        let (hasAddedItem, errorMessage) = await addItem(id: id, item: item)
        return (hasAddedItem, errorMessage)
    }
}