//
//  MultiBatchSampleListView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/27/22.
//

import SwiftUI

struct MultiBatchSampleListView : View{
    @AppStorage(AppStorageNames.store_sample_batches.rawValue)  var store_sample_batches : [SampleBatchModel] = [SampleBatchModel]()
    @Binding var showBatchDetailView : Bool

    
    @Binding var selection : Set<SampleBatchModel>
    @State private var isEditMode: EditMode = .active
    
    var body: some View{
        
        VStack{
            header
            
            batch_list
            
            
        }
        
    }
    
}

extension MultiBatchSampleListView{
    
    private var header : some View{
        Section{
            if selection.count > 0{
                withAnimation(.spring()) {
                    HStack{
                        Text("\(selection.count)")
                            .font(.title3)
                            .foregroundColor(Color.primary)
                            .bold()
                        Text("Batches Selected")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Spacer()
                    }.padding(.horizontal)
                }
            }
        }
    }
    
    private var batch_list : some View{
        
        Section{
            if store_sample_batches.count > 0{
                withAnimation {
                    // List{
                    List(store_sample_batches, id: \.self, selection: $selection) { batch in
                        
                        
                        HStack{
                            Text("\(batch.batchName ?? "N/A")").bold()
                            
                            Spacer()
                            
                            VStack(alignment: .trailing,spacing: 10){
                                Text("Samples in Batch")
                                Text("\(batch.samples.count)").bold()
                            }.font(.caption)
                            
                        }//.padding()
                        .listRowBackground(Color.clear)
                    }
                    
                    .environment(\.editMode, self.$isEditMode)
                    // }
                    
                }
            }
            else{
                VStack(alignment: .center){
                    /* Button {
                     self.refreshList()
                     
                     
                     } label: {
                     HStack{
                     Image(systemName: "arrow.clockwise")
                     Text("List")
                     }.roundButtonStyle()
                     }
                     */
                    Image("empty_box").resizable().frame(width: 400, height: 400, alignment: .center)
                }
            }
        }
    }
    
}
