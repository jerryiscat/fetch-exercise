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
                        let groupedItems = Dictionary(grouping: filteredItems, by: { $0.listId })
                            .mapValues { items in
                                items.sorted { item1, item2 in
                                    let number1 = self.extractNumber(from: item1.name!)
                                    let number2 = self.extractNumber(from: item2.name!)
                                    if let number1 = number1, let number2 = number2 {
                                        return number1 < number2
                                    } else {
                                        return item1.name! < item2.name!
                                    }
                                }
                            }
                        self.groupedItems = groupedItems
                    }
                } else {
                    print("Failed to decode data")
                }
            } else if let error = error {
                print("HTTP request failed \(error)")
            }
        }.resume()
    }
    
    func extractNumber(from string: String) -> Int? {
        let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
        let nsString = string as NSString
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: nsString.length))
        guard let match = results.first else { return nil }
        return Int(nsString.substring(with: match.range))
    }
    

}


