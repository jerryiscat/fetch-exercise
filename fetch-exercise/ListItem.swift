//
//  ListItem.swift
//  fetch-exercise
//
//  Created by Jasmine Zhang on 3/20/24.
//

import Foundation

struct ListItem: Decodable, Identifiable {
    let id: Int
    let listId: Int
    let name: String?
}
