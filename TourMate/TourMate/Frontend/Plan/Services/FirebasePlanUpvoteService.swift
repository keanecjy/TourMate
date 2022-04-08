//
//  FirebaseUpvoteService.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

class FirebasePlanUpvoteService: PlanUpvoteService {
    required init() {

    }

    private let firebaseRepository = FirebaseRepository(collectionId: FirebaseConfig.upvoteCollectionId)

    private let planUpvoteAdapter = PlanUpvoteAdapter()

    weak var planUpvoteEventDelegate: PlanUpvoteEventDelegate?

    func fetchPlanUpvotesAndListen(withPlanId planId: String) async {
        print("[FirebasePlanUpvoteService] Fetching and listening to plan upvotes")

        firebaseRepository.eventDelegate = self
        await firebaseRepository.fetchItemsAndListen(field: "planId", isEqualTo: planId)
    }

    func addPlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await firebaseRepository.addItem(id: planUpvote.id,
                                         item: planUpvoteAdapter.toAdaptedPlanUpvote(planUpvote: planUpvote))
    }

    func deletePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await firebaseRepository.deleteItem(id: planUpvote.id)
    }

    func updatePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await firebaseRepository.updateItem(id: planUpvote.id,
                                            item: planUpvoteAdapter.toAdaptedPlanUpvote(planUpvote: planUpvote))
    }

    func detachListener() {
        firebaseRepository.eventDelegate = nil
        firebaseRepository.detachListener()
    }
}

// MARK: - FirebaseEventDelegate
extension FirebasePlanUpvoteService: FirebaseEventDelegate {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebasePlanUpvoteService] Updating Plan upvotes")

        guard errorMessage.isEmpty else {
            await planUpvoteEventDelegate?.update(planUpvotes: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedPlanUpvotes = items as? [FirebaseAdaptedPlanUpvote] else {
            await planUpvoteEventDelegate?.update(planUpvotes: [], errorMessage: Constants.errorPlanUpvoteConversion)
            return
        }

        let planUpvotes = adaptedPlanUpvotes.map({ planUpvoteAdapter.toPlanUpvote(adaptedPlanUpvote: $0) })

        await planUpvoteEventDelegate?.update(planUpvotes: planUpvotes, errorMessage: "")
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {}
}
