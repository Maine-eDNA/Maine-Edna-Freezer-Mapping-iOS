//
//  BatchSampleDetailView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/25/22.
//

import SwiftUI

struct BatchSampleDetailView: View {
    @Binding var target_sample_batch : SampleBatchModel
    
    @State var twoColumnGrid : [GridItem] = [GridItem(.fixed(140)), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            header_section
            
            list_section
        }
        .navigationTitle("Batch Sample Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem {
                Button {
                    //MARK: do it after I am finished with
                    //MARK: initiate the return and return extraction action
                    
                } label: {
                    HStack{
                        Image(systemName: "return.right")
                        Text("Samples")
                    }.roundButtonStyle()
                }

            }
        }
    }
}

extension BatchSampleDetailView{
    private var header_section : some View{
        Section{
            LazyVGrid(columns: twoColumnGrid,spacing: 5) {
                 Text("Batch Name")
                    .font(.title2)
                    .foregroundColor(Color.primary)
                    .bold()
                
                Text("\(target_sample_batch.batchName)")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondaryText)
              }
        }
    }
    
    private var list_section : some View{
        Section{
            Text("Samples within Batch")
                .font(.title3)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
                .padding(.horizontal,10)
            List{
                ForEach(target_sample_batch.samples, id: \.id){ sample in
                    
                    HStack{
                        Text("\(sample.sample_barcode ?? "N/A")").bold()
                        
                        Spacer()
                        
                        VStack(alignment: .trailing,spacing: 10){
                            Text("Type")
                            Text("\(sample.freezer_inventory_type)").bold()
                        }.font(.caption)
                        
                        VStack(alignment: .trailing,spacing: 10){
                            Text("Status")
                            Text("\(sample.freezer_inventory_status)").bold()
                        }.font(.caption)
                   
                    }.padding()
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        //MARK: go to detail screen to show all the samples that is inside of the batch
                        //MARK: Next to do
                        //MARK: swipe to delete batch
                    }
                    .swipeActions {
                        Button("Remove") {
                            withAnimation {
                                target_sample_batch.samples.removeAll(where: {$0.sample_barcode == sample.sample_barcode})
                            }
                        }
                        .tint(.red)
                    }
                    
                    
                }
            }.listStyle(.plain)
        }
    }
}


struct BatchSampleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BatchSampleDetailView(target_sample_batch: .constant(SampleBatchModel()))
    }
}
