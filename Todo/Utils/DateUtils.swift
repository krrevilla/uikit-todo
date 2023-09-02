//
//  Date.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import Foundation

func formatDate(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format

    return dateFormatter.string(from: date)
}

