//
//  AppConfig.swift
//  TourMate
//
//  Created by Keane Chan on 8/4/22.
//

private struct UserServiceKey: InjectionKey {
    static var currentValue: UserService = FirebaseUserService()
}

private struct TripServiceKey: InjectionKey {
    static var currentValue: TripService = FirebaseTripService()
}

private struct PlanServiceKey: InjectionKey {
    static var currentValue: PlanService = FirebasePlanService()
}

private struct CommentServiceKey: InjectionKey {
    static var currentValue: CommentService = FirebaseCommentService()
}

private struct PlanUpvoteServiceKey: InjectionKey {
    static var currentValue: PlanUpvoteService = FirebasePlanUpvoteService()
}

private struct LocationServiceKey: InjectionKey {
    static var currentValue: LocationService = RealLocationService()
}

private struct UserRepositoryKey: InjectionKey {
    static var currentValue: Repository = FirebaseRepository(collectionId: FirebaseConfig.userCollectionId)
}

private struct TripRepositoryKey: InjectionKey {
    static var currentValue: Repository = FirebaseRepository(collectionId: FirebaseConfig.tripCollectionId)
}

private struct PlanRepositoryKey: InjectionKey {
    static var currentValue: Repository = FirebaseRepository(collectionId: FirebaseConfig.planCollectionId)
}

private struct CommentRepositoryKey: InjectionKey {
    static var currentValue: Repository = FirebaseRepository(collectionId: FirebaseConfig.commentCollectionId)
}

private struct PlanUpvoteRepositoryKey: InjectionKey {
    static var currentValue: Repository = FirebaseRepository(collectionId: FirebaseConfig.upvoteCollectionId)
}

private struct LocationWebRepositoryKey: InjectionKey {
    static var currentValue: LocationWebRepository = RealLocationWebRepository(baseURL: ApiConfig.geoapifyBaseUrl)
}

extension InjectedValues {
    var userService: UserService {
        get { Self[UserServiceKey.self] }
        set { Self[UserServiceKey.self] = newValue }
    }

    var tripService: TripService {
        get { Self[TripServiceKey.self] }
        set { Self[TripServiceKey.self] = newValue }
    }

    var planService: PlanService {
        get { Self[PlanServiceKey.self] }
        set { Self[PlanServiceKey.self] = newValue }
    }

    var commentService: CommentService {
        get { Self[CommentServiceKey.self] }
        set { Self[CommentServiceKey.self] = newValue }
    }

    var planUpvoteService: PlanUpvoteService {
        get { Self[PlanUpvoteServiceKey.self] }
        set { Self[PlanUpvoteServiceKey.self] = newValue }
    }

    var locationService: LocationService {
        get { Self[LocationServiceKey.self] }
        set { Self[LocationServiceKey.self] = newValue }
    }

    var userRepository: Repository {
        get { Self[UserRepositoryKey.self] }
        set { Self[UserRepositoryKey.self] = newValue }
    }

    var tripRepository: Repository {
        get { Self[TripRepositoryKey.self] }
        set { Self[TripRepositoryKey.self] = newValue }
    }

    var planRepository: Repository {
        get { Self[PlanRepositoryKey.self] }
        set { Self[PlanRepositoryKey.self] = newValue }
    }

    var commentRepository: Repository {
        get { Self[CommentRepositoryKey.self] }
        set { Self[CommentRepositoryKey.self] = newValue }
    }

    var planUpvoteRepository: Repository {
        get { Self[PlanUpvoteRepositoryKey.self] }
        set { Self[PlanUpvoteRepositoryKey.self] = newValue }
    }

    var locationWebRepository: LocationWebRepository {
        get { Self[LocationWebRepositoryKey.self] }
        set { Self[LocationWebRepositoryKey.self] = newValue }
    }
}
