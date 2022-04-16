//
//  PlanDiffUtil.swift
//  TourMate
//
//  Created by Keane Chan on 16/4/22.
//

struct PlanDiffUtil {

    let wordLimit: Int

    init(wordLimit: Int = 30) {
        self.wordLimit = wordLimit
    }

    func getDiff<T: Plan>(plan1: T, plan2: T) -> String {
        let differenceMap = plan1.diff(other: plan2)
        
        guard !differenceMap.isEmpty else {
            return "Plan was restored"
        }

        return differenceMap
            .map({ "\($0) changed \(truncateString(str1: $1.0, str2: $1.1))" })
            .joined(separator: "\n")
    }

    func truncateString(str1: String, str2: String) -> String {
        guard str1.count < wordLimit,
              str2.count < wordLimit else {
            return ""
        }

        return "from \(str1) to \(str2)"
    }
}
