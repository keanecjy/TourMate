//
//  AppConfig.swift
//  TourMate
//
//  Created by Keane Chan on 8/4/22.
//

private struct AuthenticationServiceKey: InjectionKey {
    static var currentValue: AuthenticationService = FirebaseAuthenticationService()
}

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
    static var currentValue: LocationService = MockLocationService()
}

private struct AuthenticationManagerKey: InjectionKey {
    static var currentValue: AuthenticationManager = FirebaseAuthenticationManager(userService: InjectedValues[\.userService])
}

extension InjectedValues {
    var authenticationService: AuthenticationService {
        get { Self[AuthenticationServiceKey.self] }
        set { Self[AuthenticationServiceKey.self] = newValue }
    }

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

    var authenticationManager: AuthenticationManager {
        get { Self[AuthenticationManagerKey.self] }
        set { Self[AuthenticationManagerKey.self] = newValue }
    }
}
