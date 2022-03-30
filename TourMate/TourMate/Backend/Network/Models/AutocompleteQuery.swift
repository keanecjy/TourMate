//
//  AutocompleteQuery.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation

struct AutocompleteQuery {
    let apiKey: String
    let text: String
    let type: String = ""
    let lang: String = ""
    let filter: String = ""
    let bias: String = ""
    let format: String = "json"

    func getQuery() -> String {
        var query = "?text=\(text)"

        if !type.isEmpty {
            query += "&type=\(type)"
        }

        if !lang.isEmpty {
            query += "&lang=\(lang)"
        }

        if !filter.isEmpty {
            query += "&filter=\(filter)"
        }

        if !bias.isEmpty {
            query += "&bias=\(bias)"
        }

        query += "&format=\(format)"

        query += "&apiKey=\(apiKey)"

        return query
    }
}
