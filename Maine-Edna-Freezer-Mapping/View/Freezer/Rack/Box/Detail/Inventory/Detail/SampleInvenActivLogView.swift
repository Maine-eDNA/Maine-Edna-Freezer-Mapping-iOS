//
//  SampleInvenActivLogView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI

struct SampleInvenActivLogView: View {
    
    @Binding var sample_detail : InventorySampleModel
    @State var showNerdRackStats : Bool = false
    @ObservedObject var sample_check_out_log_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
    @ObservedObject var box_sample_service : BoxInventorySampleRetrieval = BoxInventorySampleRetrieval()
    
    //fetch the sample detail then get the logs
    @State var need_target_sample : Bool = false
    @State var freezer_log_slug : String = ""
    @State var sample_detail_found : InventorySampleModel = InventorySampleModel()
    //add a date formatter later on
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy'-'MM'-'dd"
    // formatter.dateStyle = .long
    @State private var searchText = ""
    var searchResults: [FreezerCheckOutLogModel] {
        if searchText.isEmpty {
            return
            self.sample_check_out_log_service.stored_box_sample_logs
        } else {
            return self.sample_check_out_log_service.stored_box_sample_logs.filter { $0.created_by.contains(searchText) }
        }
    }
    
    
    //sample activity log
    var body: some View {
         VStack{//ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                if !self.sample_detail.freezer_inventory_slug.isEmpty
                {
                    withAnimation{
                        SampleHeaderView(sample_detail: self.$sample_detail)
                    }
                }
                else if !sample_detail_found.freezer_inventory_slug.isEmpty
                {
                    withAnimation{
                        SampleHeaderView(sample_detail: self.$sample_detail_found)
                    }
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Toggle("Nerd Stats", isOn: $showNerdRackStats)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    
                    if showNerdRackStats{
                        
                        
                        Section{
                            if !self.sample_detail.freezer_inventory_slug.isEmpty
                            {
                                withAnimation{
                                    NerdStatisticsSectionView(sample_detail: self.$sample_detail)
                                }
                            }
                            else if !sample_detail_found.freezer_inventory_slug.isEmpty
                            {
                                withAnimation{
                                    NerdStatisticsSectionView(sample_detail: self.$sample_detail_found)
                                }
                            }
                        }
                    }
                }
                VStack(alignment: .leading){
                    HStack{
                        Text("\(self.sample_detail.sample_barcode.uppercased()) Inventory History").font(.title3).bold()
                    }
                    
                    //self.sample_check_out_log_service.stored_box_sample_logs
                    VStack{
                        
                        List{
                            // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                            
                            ForEach(
                                self.searchResults, id: \.id) { log in
                                    
                                    NavigationLink(destination: CheckOutLogDetailView(log: log)) {
                                        //Freezer cards
                                        
                                        // FreezerProfileCardView(freezer_profile: freezer)
                                        SampleCheckOutLogCard(log: log)
                                        
                                    }
                                }
                            
                        }
                        .searchable(text: $searchText){
                            ForEach(searchResults, id: \.id) { result in
                                Text("Are you looking for logs by \(result.created_by) ?").searchCompletion(result.created_by)
                            }
                        }
                        .refreshable {
                            
                            self.sample_check_out_log_service.FetchAllSampleCheckOutLog(_inventory_id: String(self.sample_detail.id))
                        }
                        Spacer()
                        
                        
                        
                        
                        
                        
                    }
                    
                }
                
                //navigation bar section
                .navigationTitle("Existing Sample Detail")
                .navigationBarTitleDisplayMode(.inline)
            }.padding()
            
        }
        
        
        
        
        /*func convertDate(_string_date : String) -> Date{
         let isoDate = _string_date
         
         return Date.now
         }*/
        
        .onAppear{
            print("First \(self.sample_detail.freezer_inventory_slug.isEmpty)")
         if !self.need_target_sample{
                self.sample_check_out_log_service.FetchAllSampleCheckOutLog(_inventory_id: String(self.sample_detail.id))
            }
              else if self.need_target_sample{
                //fetch the sample detail then get the logs
                //1. fetch all logs from
            //https://metadata.spatialmsk.dev/api/freezer_inventory/log/
                //filter by freezer_log_slug then get the freezer_inventory from one of the result to get the sample profile
                self.sample_check_out_log_service.FetchAllRackBoxesFilterByFreezerLogSlug(_freezer_log_slug: self.freezer_log_slug){ response in
                    print("Result: \(response)")
                    let freezer_inventory : String = response
                    
                    if !freezer_inventory.isEmpty{
                        //get the sample detail
                      //  Get_Target_Sample(_freezer_inventory_slug: freezer_inventory)
                    }
                    
                }
            }
        
        }
        

    }
    
 
    func Get_Target_Sample(_freezer_inventory_slug : String) -> Void
    {
        self.box_sample_service.FetchInventorySamplesFilterInByInventorySlug(_freezer_inventory_slug: _freezer_inventory_slug){
            target_sample in
            //populate the header
            DispatchQueue.main.async {
                self.sample_detail_found = target_sample
     
                
            
                
            }
           
        }
    }
}
struct SampleInvenActivLogView_Previews: PreviewProvider {
    static var previews: some View {
        SampleInvenActivLogView(sample_detail: .constant(InventorySampleModel()))
    }
}

//Reusable sections of the sample inventory activity Log view

struct SampleHeaderView : View{
    
    @Binding var sample_detail : InventorySampleModel
    var body : some View{
        VStack(alignment: .leading){
            HStack{
                Text("Sample Barcode").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.sample_barcode)").font(.body)
            }
            
            HStack{
                Text("Box").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_box)").font(.body)
            }
            HStack{
                Text("Type").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_inventory_type)").font(.body)
            }
            HStack{
                Text("Status").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_inventory_status)").font(.body)
            }
 
            
            
        }
    }
}



struct NerdStatisticsSectionView : View{
    
    @Binding var sample_detail : InventorySampleModel
    var body : some View{
        VStack(alignment: .leading){
            HStack{
                Text("Slug").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_inventory_slug)").font(.body)
            }
            HStack{
                Text("Row").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_inventory_row)").font(.body)
            }
            HStack{
                Text("Column").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.freezer_inventory_column)").font(.body)
            }
            HStack{
                Text("Created Date").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.created_datetime)").font(.body)
            }
            HStack{
                Text("Modified Date").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.modified_datetime)").font(.body)
                
                
                
            }
            HStack{
                Text("Created By").font(.title3).bold()
                Spacer()
                Text("\(self.sample_detail.created_by)").font(.body)
            }
            
        }
    }
}
