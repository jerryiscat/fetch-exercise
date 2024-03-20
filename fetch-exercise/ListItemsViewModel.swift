//
//  ListItemsViewModel.swift
//  fetch-exercise
//
//  Created by Jasmine Zhang on 3/20/24.
//

import Foundation
import Combine

class ListItemViewModel: ObservableObject {
    @Published var groupedItems: [Int: [ListItem]] = [:]
    
    init() {
        loadItems()
    }
    

    func loadItems() {
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let decodedItems = try? decoder.decode([ListItem].self, from: data) {
                    DispatchQueue.main.async {
                        let filteredItems = decodedItems.filter { $0.name != nil && !$0.name!.isEmpty }
                        let groupedAndSortedItems = Dictionary(grouping: filteredItems, by: { $0.listId })
                            .mapValues { $0.sorted { $0.name! < $1.name! } }
                        self.groupedItems = groupedAndSortedItems
                    }
                } else {
                    print("Failed to decode data")
                }
            } else if let error = error {
                print("HTTP request failed \(error)")
            }
        }.resume()
    }
}


