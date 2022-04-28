//
//  TargetBookToMoveView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 4/12/22.
//

import SwiftUI

struct TargetBoxToMoveView: View {
    //MARK: test with all boxes then add a filter to show all boxes by the target freezer
    //MARK: will show all the boxes for the target freezer in a grid view
    @State var gridLayout: [GridItem] = [ GridItem() ]
    @Binding var all_rack_boxes : [BoxItemModel]
    //use the vm to update the list
    
    
    @State private var searchText = ""
    var searchResults: [BoxItemModel] {
        if !self.all_rack_boxes.isEmpty{
            if searchText.isEmpty {
                return self.all_rack_boxes
            } else {
                return self.all_rack_boxes.filter { $0.freezer_box_label!.contains(searchText)
                    ||
                    $0.freezer_rack!.contains(searchText)
                    
                    
                }
            }
            
                
            }
        else{
            return [BoxItemModel]()
        }
    }
    
    var body: some View {
        //MARK: get all boxes in target freezer
        
        VStack {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    
                    ForEach(self.searchResults, id: \.id) { box in
                        
                        BoxItemCard(rack_box: .constant(box))
                           // .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: gridLayout.count == 1 ? 200 : 100)
                            .cornerRadius(10)
                            .shadow(color: Color.primary.opacity(0.3), radius: 1)
                        
                    }
                    
                    
                }
                .padding(.all, 10)
                .animation(.interactiveSpring(),value: 3)
                .searchable(text: $searchText){
                    ForEach(searchResults, id: \.id) { result in
                        Text("Are you looking for \(result.freezer_box_label ?? "") ?").searchCompletion(result.freezer_box_label ?? "")
                    }
                }
            
            }
            
            .navigationBarTitle("Boxes in FreezerName",displayMode: .inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.gridLayout = Array(repeating: .init(.flexible()), count: self.gridLayout.count % 4 + 1)
                    }) {
                        Image(systemName: "square.grid.2x2")
                            .font(.title)
                            .foregroundColor(Color.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    
                  /*  NavigationLink(destination: CreateNewMemory()){
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(Color.primary)
                    }*/
                    //CreateNewMemory
                }
                
                
            }
        }
        
        
    }
}

struct TargetBoxToMoveView_Previews: PreviewProvider {
    static var previews: some View {
        TargetBoxToMoveView( all_rack_boxes: .constant([BoxItemModel()]))
    }
}
