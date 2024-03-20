//
//  ListItemsView.swift
//  fetch-exercise
//
//  Created by Jasmine Zhang on 3/20/24.
//

import SwiftUI

struct ListItemsView: View {
    @ObservedObject var viewModel = ListItemViewModel()
    
    @State private var selectedListId: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select List", selection: $selectedListId) {
                    Text("All").tag(Int?.none)
                    ForEach(viewModel.groupedItems.keys.sorted(), id: \.self) { listId in
                        Text("ListId \(listId)").tag(Optional(listId))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    if let selectedListId = selectedListId {
                        ForEach(viewModel.groupedItems[selectedListId] ?? [], id: \.id) { item in
                            Text(item.name ?? "Unknown")
                        }
                    
                    } else {
                        ForEach(Array(viewModel.groupedItems.keys).sorted(), id: \.self) { listId in
                            Section(header: Text("List ID: \(listId)")) {
                                ForEach(viewModel.groupedItems[listId] ?? [], id: \.id) { item in
                                    Text(item.name ?? "Unknown")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("List Items")
        }
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView()
    }
}


#Preview {
    ListItemsView()
}
