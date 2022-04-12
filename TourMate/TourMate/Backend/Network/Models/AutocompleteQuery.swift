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
    let type: String
    let lang: String = ""
    let filter: String = ""
    let bias: String = ""
    let format: String = "json"

    init(apiKey: String, text: String, type: String = "") {
        self.apiKey = apiKey
        self.text = text
        self.type = type
    }

    func getQuery() -> String {
        var query = "?text=\(getUrlString(text))"

        if !type.isEmpty {
            query += "&type=\(getUrlString(type))"
        }

        if !lang.isEmpty {
            query += "&lang=\(getUrlString(lang))"
        }

        if !filter.isEmpty {
            query += "&filter=\(getUrlString(filter))"
        }

        if !bias.isEmpty {
            query += "&bias=\(getUrlString(bias))"
        }

        query += "&format=\(getUrlString(format))"

        query += "&apiKey=\(getUrlString(apiKey))"

        return query
    }

    func getUrlString(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}
