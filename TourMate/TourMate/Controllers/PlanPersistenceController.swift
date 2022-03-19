//
//  PlanPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

struct PlanPersistenceController {
    // TODO: CRUD for plans - To think of better way to generalize things
    
    func addPlan<T: Plan>(plan: T) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: plan.toData())
    }

}
