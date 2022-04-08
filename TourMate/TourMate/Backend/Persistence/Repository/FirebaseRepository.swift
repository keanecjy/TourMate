//
//  FirebaseRepository.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase

class FirebaseRepository: Repository {
    private let collectionId: String

    private let db = Firestore.firestore()

    var listener: ListenerRegistration?

    init(collectionId: String) {
        self.collectionId = collectionId
    }

    @MainActor
    func addItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let itemRef = db.collection(collectionId).document(id)
            let any = AnyFirebaseAdaptedData(item)
            try itemRef.setData(from: any)

            print("[FirebaseRepository] Added or Updated \(T.self): \(id)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error adding \(T.self): \(error)"
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

            print("[FirebaseRepository] Fetched \(collectionId): \(id)")

            return (item, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error fetching: \(error)"
            return (nil, errorMessage)
        }
    }

    @MainActor
    func fetchItems(field: String, isEqualTo id: String) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), isEqualTo: id)

        print("[FirebaseRepository] Fetched \(collectionId) with Field: \(field), isEqualTo: \(id)")

        return await fetchItems(from: query)
    }

    @MainActor
    func fetchItemsAndListen(field: String, arrayContains id: String,
                             callback: (@escaping ([FirebaseAdaptedData], String) async -> Void)) async {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), arrayContains: id)

        fetchItemsAndListen(from: query, callback: callback)
    }

    @MainActor
    func fetchItemsAndListen(field: String, isEqualTo id: String,
                             callback: (@escaping ([FirebaseAdaptedData], String) async -> Void)) async {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), isEqualTo: id)

        fetchItemsAndListen(from: query, callback: callback)
    }

    @MainActor
    func fetchItemAndListen(id: String, callback: (@escaping (FirebaseAdaptedData?, String) async -> Void)) async {
        let itemRef = db.collection(collectionId).document(id)

        fetchItemAndListen(from: itemRef, callback: callback)
    }

    func detachListener() {
        guard listener != nil else {
            print("[FirebaseRepository] Listener on \(collectionId) is nil, unable to detach")
            return
        }

        self.listener?.remove()
        self.listener = nil

        print("[FirebaseRepository]: Successfully removed listener on \(collectionId)")
    }

    @MainActor
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let deletedItemRef = db.collection(collectionId).document(id)
            try await deletedItemRef.delete()

            print("[FirebaseRepository] Deleted \(collectionId): \(id)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error deleting \(collectionId): \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String) {
        let (hasAddedItem, errorMessage) = await addItem(id: id, item: item)
        return (hasAddedItem, errorMessage)
    }

}

// MARK: - Helper Methods
extension FirebaseRepository {
    @MainActor
    private func fetchItems(from query: Query) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        do {
            let documents = try await query.getDocuments().documents
            let items = documents.compactMap({ try? $0.data(as: AnyFirebaseAdaptedData.self) }).map { $0.base }

            return (items, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error fetching \(collectionId): \(error)"
            return ([], errorMessage)
        }
    }

    @MainActor
    private func fetchItemsAndListen(from query: Query, callback: (@escaping ([FirebaseAdaptedData], String) async -> Void)) {
        guard Auth.auth().currentUser != nil else {
            print("Unable to listen", Constants.messageUserNotLoggedIn)
            return
        }

        listener = query.addSnapshotListener({ querySnapshot, error in
            Task {
                guard let documents = querySnapshot?.documents,
                      error == nil
                else {
                    let errorMessage = "[FirebaseRepository] Error fetching \(self.collectionId): \(String(describing: error))"
                    await callback([], errorMessage)
                    return
                }
                let items = documents.compactMap({ try? $0.data(as: AnyFirebaseAdaptedData.self) }).map { $0.base }
                await callback(items, "")
            }
        })
    }

    @MainActor
    private func fetchItemAndListen(from document: DocumentReference, callback: (@escaping (FirebaseAdaptedData?, String) async -> Void)) {
        guard Auth.auth().currentUser != nil else {
            print("Unable to listen", Constants.messageUserNotLoggedIn)
            return
        }

        listener = document.addSnapshotListener({ querySnapshot, error in
            Task {
                do {
                    guard let querySnapshot = querySnapshot,
                          error == nil
                    else {
                        let errorMessage = "[FirebaseRepository] Error fetching \(self.collectionId): \(String(describing: error))"
                        await callback(nil, errorMessage)
                        return
                    }
                    let item = try querySnapshot.data(as: AnyFirebaseAdaptedData.self).map { $0.base }
                    await callback(item, "")
                } catch {
                    let errorMessage = "[FirebaseRepository] Error fetching \(self.collectionId): \(error)"
                    print(errorMessage)
                }
            }
        })
    }

}
