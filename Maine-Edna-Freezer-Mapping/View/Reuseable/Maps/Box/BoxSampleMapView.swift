//
//  BoxSampleMapView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI
#warning("Need a way to determine if the sample position contains records (if it does give a unique color)")
#warning("Need to test creating new Freezers, Racks and Boxes")
#warning("Need to test Finding samples and taking them or removing them from freezer and creating the batches")
#warning("Not showing the Samples in the Box need to debug why that is so")
#warning("If in swap mode disable the navigation on all Empty Samples and make the empty samples instead be clickable which enables that sample and makes it be the replacement position for the initial position. Once confirm the swap, the prvious position becomes empty and a new sample can be placed there if it was a clash mode (clash means move the sample in the position to new position and place the new sample in the previous conflict position")
#warning("Test this to see why it is not showing the highlighted samples")

struct BoxSampleMapView: View {
    
    let data = (1...100).map { "\($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 20,maximum: 30))
    ]
    @State var showSampleDetail : Bool = false
    @State var showCreateNewSample : Bool = false
    @State var showSampleActionMenu : Bool = false
    
    @Binding var box : BoxItemModel
    //TODO: need to fetch the InventorySampleModel for target box
    //@State var stored_box_samples : [InventorySampleModel]
    
    @Binding var freezer_profile : FreezerProfileModel
    
    @State var target_sample_detail : InventorySampleModel = InventorySampleModel()
    

    //CapsuleSuggestedPositionView
    @StateObject var inventory_vm = FreezerInventoryViewModel()
    
    #warning("Need to fix the logic so that if the Row or COlumn is 0 + 1 to it so it doesnt say its less than one")

    var body: some View {
        ZStack{
            ScrollView([.horizontal,.vertical],showsIndicators: false){
                //Experiment
                // Text("\(box.freezer_box_max_column) \(box.freezer_box_max_row)")
                InteractiveBoxGridStack(rows: $box.freezer_box_capacity_row.wrappedValue ?? 0, columns: $box.freezer_box_capacity_column.wrappedValue ?? 0,samples: self.inventory_vm.all_box_samples) { row, col,content  in
                    
                    
                    //  NavigationLink(destination: SampleInvenActivLogView(sample_detail: .constant(content))){
                    // BoxSampleCapsuleView(single_lvl_rack_color: .constant("blue"))

                    if content.is_suggested_sample && content.freezer_inventory_row == row && content.freezer_inventory_column == col{
                        VStack{
                            //MARK:
                            CapsuleSuggestedPositionView(single_lvl_rack_color: .constant("yellow"), sample_code:.constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")), sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")), showMenu: $showSampleActionMenu, showSampleDetail: $showSampleDetail)
                                .onTapGesture {
                                    
                                    
                                    
                                    self.target_sample_detail = content
                                    
                                    //open the modal
                                    print("Show Details Pressed")
                                    
                                    withAnimation {
                                        self.showSampleActionMenu.toggle()
                                    }
                                }
                        }
                    }
                    else if content.freezer_inventory_row == row && content.freezer_inventory_column == col{
                        
                        BoxSampleCapsuleView(background_color: .constant(setColorBasedOnSampleType(freezer_inventory_type: content.freezer_inventory_type)),sample_code: .constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")),sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")), foreground_color: .constant("white"),width: 50,height: 50)
                            .onTapGesture {
                                self.target_sample_detail = content
                                
                                //open the modal
                                print("Show Details Pressed")
                                
                                withAnimation {
                                    self.showSampleDetail.toggle()
                                }
                            }
                        
                        
                        
                        
#warning("Move this once finish testing that the suggested location works")
                        //.background(.brown)
                    }
                    else{
                        //MARK: - Empty sample box sample Section
                        //empty sample box sample color
                        
                        VStack {
                            BoxSampleCapsuleView(background_color: .constant("gray"),sample_code: .constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")),sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")), foreground_color: .constant("white"),width: 50,height: 50)
                                .onTapGesture {
                                    
                                    //Set the row and column
                                    content.freezer_inventory_row = row
                                    content.freezer_inventory_column = col
                                    content.freezer_box = box.freezer_box_label_slug ?? "" //The box slug
                                    self.target_sample_detail = content
                                    
                                    withAnimation {
                                        self.showCreateNewSample.toggle()
                                    }
                                }
                        }//.background(.red)
                    }
                    
                    // }.buttonStyle(PlainButtonStyle())  /*Remove Navigation Link blue tint*/
                    
                }
                
                
                
            }
            
            .onAppear(){
                
                //Fetch the Samples and populate the map
                getAllSamplesForSampleMap()
            }
            
        }.background(
            NavigationLink(isActive: $showSampleDetail, destination: {
                SampleInvenActivLogView(sample_detail: $target_sample_detail)
            }, label: {
                EmptyView()
            })
        )
        .background(
            NavigationLink(isActive: $showCreateNewSample, destination: {
                CreateInventorySampleView(target_sample_spot_detail: $target_sample_detail, freezer_box_label: .constant(box.freezer_box_label ?? "No Box Found"))
            }, label: {
                EmptyView()
            })
        )
        
    }
}

struct BoxSampleMapView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleMapView(box: .constant(BoxItemModel()), freezer_profile: .constant(FreezerProfileModel()))
    }
}

extension BoxSampleMapView{
    
    func getAllSamplesForSampleMap(){
#warning("Need to send all the samples that belong in this box")
        
        //MARK: fill the results into inventoryLocations
        
        //then go into the freezer box
        
        //MARK: Find inventoryLocations by freezer_box slug
        
        //MARK: Write this endpoint method next
        //https://metadata.spatialmsk.dev/api/freezer_inventory/inventory/?freezer_box=test_freezer_1_test_rack3_test_box3
        //MARK: DO this on the Sample View
        if let box_slug = box.freezer_box_label_slug{
            //MARK: Fetch Data and wait beore going to the next page
            Task{
                //MARK: need a background process
                await inventory_vm.fetchInventoryByBoxSlug(freezer_box_slug: box_slug)
                
                //go back on the main thread
                /* await MainActor.run(body:{
                 self.inventoryLocations = inventory_vm.all_box_samples
                 })
                 */
                
                
                
                
            }
            
        }
    }
    
#warning("Also color the samples based on their type: filter = blue, extraction = purple, sub-core = orange, pooled_lib = brown ")
    
    func setColorBasedOnSampleType(freezer_inventory_type : String) -> String
    {
        //green for target samples
        /*
         "choices": [
            "filter",
            "subcore",
            "extraction",
            "pooled_lib"
          ]
         */
        if freezer_inventory_type == "filter"{
            return "blue"
        }
        else if freezer_inventory_type == "subcore"{
            return "orange"
        }
        else if freezer_inventory_type == "extraction"{
            return "purple"
        }
        else if freezer_inventory_type == "pooled_lib"{
            return "brown"
        }
        else{
            return "mint"
        }
        
    }
    
}

struct InteractiveBoxGridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let samples : [InventorySampleModel]
    let content: (Int, Int,InventorySampleModel) -> Content
    
    //letters of the alphabet start
    let alphabet : [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    //letters of the alphabet end
    
    var body: some View {
        VStack {
            // ForEach(racks, id: .\id){
            
            
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        HStack{
                            
                            Text("\(( column == 0 ? String(alphabet[row]).uppercased() : "") )")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal,column == 0 ? 10 : 0)
                            
                        }
                        
                        /*ForEach(samples, id: \.freezer_box) {
                         sample in
                         content(row, column,sample)
                         }*/
                        VStack(alignment: .leading){
                            Section{
                                if row == 0{
                                    HStack{
                                        Text("\(((column ) + 1) )")
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.horizontal,5)
                                        
                                    }
                                }
                            }
                            Section{
                                //must be unique
                                if let sample = samples.first(where: {$0.freezer_inventory_column == column  && $0.freezer_inventory_row == row}){
                                    content(row, column,sample)
                                }
                                else{
                                    content(row, column,InventorySampleModel(id: 0,freezer_box: "",freezer_inventory_column: column, freezer_inventory_row: row, is_suggested_sample: false))//MARK: change this to be dynamic when it is suggested
                                }
                            }
                            //here
                            Section{
                                if row == (rows - 1){
                                    HStack{
                                        Text("\(((column ) + 1) )")
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.horizontal,5)
                                        
                                    }
                                }
                            }
                            
                        }
                        HStack{
                            
                            Text("\(( column == (columns - 1) ? String(alphabet[row]).uppercased() : "") )")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal,column == 9 ? 8 : 0)
                            
                        }
                        
                        
                        
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, samples: [InventorySampleModel], @ViewBuilder content: @escaping (Int, Int,InventorySampleModel) -> Content) {
        self.rows = rows
        self.columns = columns
        self.samples = samples
        
        self.content = content
    }
}
