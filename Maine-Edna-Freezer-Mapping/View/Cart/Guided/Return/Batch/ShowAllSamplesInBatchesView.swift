//
//  ShowAllSamplesInBatchesView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/27/22.
//

import SwiftUI

struct ShowAllSamplesInBatchesView: View {
    
    @Binding var targetBatches : Set<SampleBatchModel>
    
    @State var allSamplesInBatches : [InventorySampleModel] = [InventorySampleModel]()
    
    //change to binding when done, targetSamplesToProcess is what will be sent to the step by step guide
    @Binding var targetSamplesToProcess : Set<InventorySampleModel>// = Set<InventorySampleModel>()
    @State private var isEditMode: EditMode = .active
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            
                //when returned only remove from the list the samples that were returned leave the rest as a todo to complete in the future
               Text("Shows all samples found in all the selected batch have the option to unselect individual samples that wont be returned")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
            
            //Text("Extract all samples that are in these \(targetBatches.count) batches")
            samples_to_process_list_section
            
            Spacer()
            
                .onAppear(){
                    
                    
                    self.fetchAllSamplesInBatches()
                }
        }
    }
}

extension ShowAllSamplesInBatchesView{
    #warning("Need to trigger this method to when this view appears( only appears after i go to it and go back)")
    #warning("The select must be unique and not duplicate between the batches")
    //MARK: look at how to preselect all the items in the list
    func fetchAllSamplesInBatches(){
        //clear the list first
        self.allSamplesInBatches.removeAll()
        
        for batch in targetBatches{
         
            
            //get the samples in the batch
            for sample in batch.samples{
                allSamplesInBatches.insert(sample, at: 0) //push to the front
            }
            
        }
    }
    
}

extension ShowAllSamplesInBatchesView{
    //select all the samples then unselect the ones the user dont want
    
    private var samples_to_process_list_section : some View{
        Section{
            if targetBatches.count > 0{
                withAnimation {
                    // List{
                    List(allSamplesInBatches, id: \.self, selection: $targetSamplesToProcess) { sample in
                        
                        
                        HStack{
                            Text("\(sample.sample_barcode ?? "N/A")").bold()
                            
                            Spacer()
                            
                            VStack(alignment: .trailing,spacing: 10){
                                Text("Type")
                                Text("\(sample.freezer_inventory_type)").bold()
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


struct ShowAllSamplesInBatchesView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllSamplesInBatchesView(targetBatches: .constant(Set<SampleBatchModel>()), targetSamplesToProcess: .constant(Set<InventorySampleModel>()))
    }
}
