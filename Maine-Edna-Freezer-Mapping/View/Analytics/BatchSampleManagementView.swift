//
//  BatchSampleManagementView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/25/22.
//

import SwiftUI

//MARK: need to be able to take the samples from the batch and return them to the freezer as new extracted samples using the same position as the previous un-extracted sample
//MARK: this will be the entry point to the App
struct BatchSampleManagementView: View {
    //MARK: When clicked carry user to the sample to complete the process
    
    @State var showBatchDetailView : Bool = false
    @State var targetBatch : SampleBatchModel = SampleBatchModel()
#warning("Should remove batch when all the samples in the list have been returned")
#warning("On return once you have clicked that the target barcode was returned then you can remove from the sample from the list of batch samples")
    @AppStorage(AppStorageNames.store_sample_batches.rawValue)  var store_sample_batches : [SampleBatchModel] = [SampleBatchModel]()
    @State private var selection = Set<SampleBatchModel>()
    
    let names : [SampleBatchModel] = [
        SampleBatchModel(batchName: "Test Batch", samples: [InventorySampleModel]()),
        SampleBatchModel(batchName: "Test Batch 2", samples: [InventorySampleModel]()),
        SampleBatchModel(batchName: "Test Batch 3", samples: [InventorySampleModel]()),
        SampleBatchModel(batchName: "Test Batch 4", samples: [InventorySampleModel]())
    ]
    @State private var isEditMode: EditMode = .active
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading,spacing: 10){
                ZStack{
                    BatchSampleListView(showBatchDetailView: $showBatchDetailView, targetBatch: $targetBatch)
              
                }
                .background(
                    NavigationLink(destination: BatchSampleDetailView(target_sample_batch: $targetBatch), isActive: $showBatchDetailView, label: {EmptyView()})
                )
            }
            
            .navigationTitle("\(store_sample_batches.count) Sample Batches")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}


extension BatchSampleManagementView{
    
    private var empty_state : some View{
        Section{
            Image("Empty_Box")
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

struct BatchSampleManagementView_Previews: PreviewProvider {
    static var previews: some View {
        BatchSampleManagementView()
    }
}


struct BatchSampleListView : View{
    @AppStorage(AppStorageNames.store_sample_batches.rawValue)  var store_sample_batches : [SampleBatchModel] = [SampleBatchModel]()
    @Binding var showBatchDetailView : Bool
    @Binding var targetBatch : SampleBatchModel
    
    
    var body: some View{
        
        batch_list
    }
    
}

extension BatchSampleListView{
    
    private var batch_list : some View{
        
        Section{
            if store_sample_batches.count > 0{
                withAnimation {
                    List{
                        ForEach(store_sample_batches, id: \.id){ batch in
                            
                            HStack{
                                Text("\(batch.batchName ?? "N/A")").bold()
                                
                                Spacer()
                                
                                VStack(alignment: .trailing,spacing: 10){
                                    Text("Samples in Batch")
                                    Text("\(batch.samples.count)").bold()
                                }.font(.caption)
                                
                            }.padding()
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    //MARK: go to detail screen to show all the samples that is inside of the batch
                                    //MARK: Next to do
                                    //MARK: swipe to delete batch
                                    withAnimation {
                                        self.targetBatch = batch
                                        self.showBatchDetailView.toggle()
                                    }
                                }
                                .swipeActions {
                                    Button("Remove") {
                                        withAnimation {
                                            store_sample_batches.removeAll(where: {$0.batchName == batch.batchName})
                                        }
                                    }
                                    .tint(.red)
                                }
                            
                            
                        }
                    }.listStyle(.plain)
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
                    //MARK: Put these in a const file so all assets can be update centrally 
                    Image("Empty_Box").resizable().frame(width: 400, height: 400, alignment: .center)
                    
                    Spacer()
                }
            }
        }
    }
    
}
