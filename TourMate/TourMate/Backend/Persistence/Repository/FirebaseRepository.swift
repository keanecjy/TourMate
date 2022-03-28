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

    weak var eventDelegate: FirebaseEventDelegate?

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

            print("[FirebaseRepository] Fetched Item: \(id)")

            return (item, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error fetching: \(error)"
            return (nil, errorMessage)
        }
    }

    @MainActor
    func fetchItems(field: String, arrayContains id: String) async -> (items: [FirebaseAdaptedData],
                                                                            errorMessage: String) {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), arrayContains: id)

        print("[FirebaseRepository] Fetched Items with Field: \(field), arrayContains: \(id)")

        return await fetchItems(from: query)
    }

    @MainActor
    func fetchItems(field: String, isEqualTo id: String) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), isEqualTo: id)

        print("[FirebaseRepository] Fetched Items with Field: \(field), isEqualTo: \(id)")

        return await fetchItems(from: query)
    }

    @MainActor
    func fetchItemsAndListen(field: String, arrayContains id: String) async {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), arrayContains: id)

        fetchItemsAndListen(from: query)
    }

    @MainActor
    func fetchItemsAndListen(field: String, isEqualTo id: String) async {
        let query = db.collection(collectionId).whereField(FirebaseConfig.fieldPath(field: field), isEqualTo: id)

        fetchItemsAndListen(from: query)
    }

    @MainActor
    func fetchItemAndListen(id: String) async {
        let itemRef = db.collection(collectionId).document(id)

        fetchItemAndListen(from: itemRef)
    }

    func detachListener() {
        guard let listener = listener else {
            print("[FirebaseRepository] Listener is nil, unable to detach")
            return
        }

        print("[FirebaseRepository] Successfully removed listener")
        listener.remove()
    }

    @MainActor
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let deletedItemRef = db.collection(collectionId).document(id)
            try await deletedItemRef.delete()

            print("[FirebaseRepository] Deleted: \(id)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebaseRepository] Error deleting: \(error)"
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
            let errorMessage = "[FirebaseRepository] Error fetching: \(error)"
            return ([], errorMessage)
        }
    }

    @MainActor
    private func fetchItemsAndListen(from query: Query) {
        guard Auth.auth().currentUser != nil else {
            print("Unable to listen", Constants.messageUserNotLoggedIn)
            return
        }

        listener = query.addSnapshotListener({ querySnapshot, error in
            Task {
                guard let documents = querySnapshot?.documents,
                      error == nil
                else {
                    let errorMessage = "[FirebaseRepository] Error fetching documents: \(String(describing: error))"
                    await self.eventDelegate?.update(items: [], errorMessage: errorMessage)
                    return
                }
                let items = documents.compactMap({ try? $0.data(as: AnyFirebaseAdaptedData.self) }).map { $0.base }
                await self.eventDelegate?.update(items: items, errorMessage: "")
            }
        })
    }

    @MainActor
    private func fetchItemAndListen(from document: DocumentReference) {
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
                        let errorMessage = "[FirebaseRepository] Error fetching doc: \(String(describing: error))"
                        await self.eventDelegate?.update(item: nil, errorMessage: errorMessage)
                        return
                    }
                    let item = try querySnapshot.data(as: AnyFirebaseAdaptedData.self).map { $0.base }
                    await self.eventDelegate?.update(item: item, errorMessage: "")
                } catch {
                    let errorMessage = "[FirebaseRepository] Error fetching: \(error)"
                    print(errorMessage)
                }
            }
        })
    }

}
