//
//  BoxSampleMapView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI
import AlertToast
#warning("Need a way to determine if the sample position contains records (if it does give a unique color)")
#warning("Need to test creating new Freezers, Racks and Boxes")
#warning("Need to test Finding samples and taking them or removing them from freezer and creating the batches")
#warning("Not showing the Samples in the Box need to debug why that is so")
#warning("If in swap mode disable the navigation on all Empty Samples and make the empty samples instead be clickable which enables that sample and makes it be the replacement position for the initial position. Once confirm the swap, the prvious position becomes empty and a new sample can be placed there if it was a clash mode (clash means move the sample in the position to new position and place the new sample in the previous conflict position")
#warning("Test this to see why it is not showing the highlighted samples")


#warning("Show the batches whenopen the app, put the dashboard in Menu")

#warning("In Add Mode, when press auto fill for the system to assign the barcodes to position or manuallypress the location and select the barode from the list of barcodes provided")
#warning("Bug some samples arent showing up in the map although added to the db")

#warning("Need to hide buttons when not in use at the top, especially when using mobile phone")
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
    
  
    
    
    //CapsuleSuggestedPositionView
    @StateObject var inventory_vm = FreezerInventoryViewModel()
#warning("Add a is in guide mode to when click sample it doesnt move to another screen instead it adds the tapped sample to a visible list that can be seen by pressing show list")
    
#warning("Need to fix the logic so that if the Row or COlumn is 0 + 1 to it so it doesnt say its less than one")
    
    @Binding var is_in_select_mode : Bool
    
    ///used to do multi-select for take from freezer and perm_remove
    @State var selected_samples_to_take : [InventorySampleModel] = []
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    @State var showBatchSamples : Bool = false
    
    @AppStorage(AppStorageNames.store_sample_batches.rawValue)  var store_sample_batches : [SampleBatchModel] = [SampleBatchModel]()
    
    @State var reset_cart_form_control : Bool = false
    
    @Binding var selectMode : String
    
    @State var isSampleSelected : Bool = false
    
    @State var showResolutionPopUp : Bool = false
    
    
    var body: some View {
        
        
        
        //MARK: show the count here of the number of items selected
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
                                    
                                    
                                    
                                    self.inventory_vm.target_sample_detail = content
                                    
                                    if selectMode == "Remove"{
                                        if let targetIndexToRemove = isSampleInList(sample: content)
                                        {
                                            //already exist which means the user is unselecting the sample
                                            if removeSampleFromTargetList(targetIndexToRemove: targetIndexToRemove){
                                                //then unselect the target sample by removing from the list
                                                displayMesssageToUser(_message: "\(content.sample_barcode) Unselected", _isError: false)
                                            }
                                        }
                                     
                                        else{
                                            //doesnt already exist so add to list
                                            #warning("TODO next to ensure the target sample color changes to be highlight and can be unselected if no longer on removal list or accidentlly selected, when removed should turn to gray")
                                            //MARK: highlight the sample that was selected
                                            displayMesssageToUser(_message: "Hightlight this Sample", _isError: false)
                                                #warning("NEXT")
                                            //set that the sample has been selected
                                            //MARK: need to track the selected samples in a list
                                            //if unselected (means its false) then remove from the list and
                                            
                                            //add to multi-select list
                                            self.selected_samples_to_take.append(content)
                                            
                                            self.isSampleSelected.toggle()
                                        }
                                    }
                                    else if selectMode == "Add"{
                                        //MARK: Position already taken so show modal with resolution options
                                        populateAndShowResolutionPopUp()
                                    }
                                    else{
                                        //open the modal
                                        print("Show Details Pressed")
                                        //MARK: after this functionality is tested add it to other capsules
                                        sampleSuggestedCapsuleFunctionality()
                                        
                                    }
                                }
                        }
                    }
                    else if content.freezer_inventory_row == row && content.freezer_inventory_column == col{
                        
                        BoxSampleCapsuleView(sampleDetail: .constant(content), targetSamples: $selected_samples_to_take, isSelected: $isSampleSelected)
                            .onTapGesture {
                                //MARK: add this to its own section
                                self.inventory_vm.target_sample_detail = content
                                
                                if selectMode == "Remove"{
                                    //if the current sample being selected was already selected then unselect it and remove it from the list
                                    //MARK: own func
                                    if let targetIndexToRemove = isSampleInList(sample: content)
                                    {
                                        //already exist which means the user is unselecting the sample
                                        if removeSampleFromTargetList(targetIndexToRemove: targetIndexToRemove)
                                        {
                                            //then unselect the target sample by removing from the list
                                            displayMesssageToUser(_message: "\(content.sample_barcode) Unselected", _isError: false)
                                        }
                                    }
                                  
                                    else{
                                        //doesnt already exist so add to list

                                        //MARK: highlight the sample that was selected
                                        displayMesssageToUser(_message: "Hightlight this Sample", _isError: false)

                                        //set that the sample has been selected
                                        //MARK: need to track the selected samples in a list
                                        //if unselected (means its false) then remove from the list and
                                        
                                        //add to multi-select list
                                        self.selected_samples_to_take.append(content)
                                        
                                        self.isSampleSelected.toggle()
                                    }
                                    
                                }
                                else if selectMode == "Add"{
                                    //MARK: Position already taken so show modal with resolution options
                                    populateAndShowResolutionPopUp()
                                }
                                else{
                                    //open the modal
                                    print("Show Details Pressed")
                                    sampleCapsuleFunctionality()
                                    /* withAnimation {
                                     self.showSampleDetail.toggle()
                                     }*/
                                }
                                
                            }
                        
                        
                        
                        
#warning("Move this once finish testing that the suggested location works")
                        //.background(.brown)
                    }
                    else{
                        //MARK: - Empty sample box sample Section
                        //empty sample box sample color
                        
                        VStack {
                            BoxSampleCapsuleView(sampleDetail: .constant(content), targetSamples: $selected_samples_to_take, isSelected: $isSampleSelected)
                                .onTapGesture {
                                    if selectMode == "Remove"{
                                        //MARK: do nothing since you cant remove from an empty position
                                        
                                        displayMesssageToUser(_message: "Can't Remove Empty Sample", _isError: false)
                                        
                                        
                                        
                                    }
                                    else{
                                        //MARK: Need to debug to ensure the correct coordinates are sent to the form at all times
                                        
                                        let tempSampleDetail = InventorySampleModel()
                                        //Set the row and column
                                        if let box_row_cap = box.freezer_box_capacity_row{
                                            if row == (box_row_cap - 1){
                                                //add 1 to the row
                                                //content.freezer_inventory_row = row //+ 1
                                                tempSampleDetail.freezer_inventory_row = row
                                            }
                                            else{
                                                tempSampleDetail.freezer_inventory_row = row > 0 ? row - 1 : row// + 1
                                                
                                            }
                                        }
                                     
                                        tempSampleDetail.freezer_inventory_column = col + 1 //because it starts at 0
                                        tempSampleDetail.freezer_box = box.freezer_box_label_slug ?? "" //The box slug
                                        self.inventory_vm.target_sample_detail = tempSampleDetail
                                        
                                        withAnimation {
                                            self.showCreateNewSample.toggle()
                                            
                                            //reset the content
                                        }
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
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    if is_in_select_mode && selectMode != "Remove"{
                        Button {
                            //show list of samples in the list
                            withAnimation {
                                self.showBatchSamples.toggle()
                            }
                            
                        } label: {
                            HStack{
                                Text("\(selected_samples_to_take.count)").bold()
                                Text("Samples")
                            }.roundButtonStyle()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if is_in_select_mode && selectMode != "Remove"{
                        Button {
                            //add the selected_samples to store_sample_batches
                            //MARK: make batch
                            if selected_samples_to_take.count > 0{
                                var new_sample_batch = SampleBatchModel()
                                //made of UUID + Current date + number of samples
                                new_sample_batch.batchName = "\(UUID().uuidString)_\(Date().asShortDateString())_\(selected_samples_to_take.count)"
                                new_sample_batch.samples = selected_samples_to_take
                                //add to the global or database list
                                self.store_sample_batches.append(new_sample_batch)
                                
                                //clear from the local list
                                withAnimation {
                                    self.selected_samples_to_take.removeAll()
                                    self.reset_cart_form_control.toggle()
                                }
                            }
                            else{
                                self.responseMsg = "Must have 1 or more samples"
                                self.showResponseMsg = true
                                self.isErrorMsg = true
                            }
                            
                        } label: {
                            HStack{
                                Image(systemName: "tray.and.arrow.up.fill")
                                Text("Take Samples")
                            }.roundButtonStyle()
                        }
                    }
                }
            }
            
        }.background(
            NavigationLink(isActive: $showSampleDetail, destination: {
                SampleInvenActivLogView(sample_detail: $inventory_vm.target_sample_detail)
            }, label: {
                EmptyView()
            })
        )
        .background(
            NavigationLink(isActive: $showCreateNewSample, destination: {
                CreateInventorySampleView(target_sample_spot_detail: $inventory_vm.target_sample_detail, freezer_box_label: .constant(box.freezer_box_label ?? "No Box Found"))
            }, label: {
                EmptyView()
            })
        )
        .background(
            NavigationLink(isActive: $showBatchSamples, destination: {
                SamplesInReturnCurrentBatchView(samples_in_batch: $selected_samples_to_take)
            }, label: {
                EmptyView()
            })
        )
        .background(
            NavigationLink(destination: GuidedCartView(),isActive: $reset_cart_form_control,  label: {EmptyView()})
        )
        
        .toast(isPresenting: $showResponseMsg){
            if self.isErrorMsg{
                return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
            }
            else{
                return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
            }
        }
        .customHalfSheet(showHalfSheet: $showResolutionPopUp) {
            //Make into Custom Body
            //Text("Resolution Logic and interface will show up here")
          
            ResolutionModalView(inventorySample: self.$inventory_vm.target_sample_detail)
                //.frame(width: 200)
                .padding()
        }
        
        
        
    }
}

struct BoxSampleMapView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleMapView(box: .constant(BoxItemModel()), freezer_profile: .constant(FreezerProfileModel()), is_in_select_mode: .constant(false), selectMode: .constant(""))
    }
}

extension BoxSampleMapView{
    
    func populateAndShowResolutionPopUp(){
        //Trigger the modal
        withAnimation {
            self.showResolutionPopUp.toggle()
        }
        
    }
    
    ///checks if the sample is in the multi-select list and returns an index if found
    func isSampleInList(sample : InventorySampleModel) -> Int?{
        return selected_samples_to_take.firstIndex(where: {$0.id == sample.id})
    }
    
    ///removes the sample at the target index and confirms it is no longer in the list
    func removeSampleFromTargetList(targetIndexToRemove : Int) -> Bool{
         selected_samples_to_take.remove(at: targetIndexToRemove)
        
        if !selected_samples_to_take.indices.contains(targetIndexToRemove){
            //means it no longer exist
            return true
        }
        else{
            return false
        }
        
    }
    
    func displayMesssageToUser(_message : String, _isError : Bool){
        self.responseMsg = _message
        self.isErrorMsg = _isError
        self.showResponseMsg = true
    }
    
    func doesSampleAlreadyExistInTheList(target_sample : InventorySampleModel) -> Bool
    {
        if (selected_samples_to_take.first(where: {$0.sample_barcode == target_sample.sample_barcode}) != nil){
            //was already found
            print("Sample is already in the list")
            
            return true
        }
        else{
            //not found so add to the list
            return false
        }
    }
    
    ///Switches the mode or behavior of the capsule according to the capusles mode
    func sampleSuggestedCapsuleFunctionality(){
        //if not in select mode then do its normal operation such as show menu or sample details
        if !is_in_select_mode{
            withAnimation {
                self.showSampleActionMenu.toggle()
            }
        }
        else if is_in_select_mode{
            print("In Select mode so will now add this sample to the list")
        }
    }
    
    ///Switches the mode or behavior of the capsule according to the capusles mode
    func sampleCapsuleFunctionality(){
        //if not in select mode then do its normal operation such as show menu or sample details
        if !is_in_select_mode{
            withAnimation {
                self.showSampleDetail.toggle()
            }
        }
        else if is_in_select_mode{
            print("In Select mode so will now add this sample to the list")
            
            withAnimation {
                if doesSampleAlreadyExistInTheList(target_sample: self.inventory_vm.target_sample_detail){
                    print("Sample Already Exist")
                    
                    self.responseMsg = "\(self.inventory_vm.target_sample_detail.sample_barcode) Already Exist in list"
                    self.showResponseMsg = true
                    self.isErrorMsg = true
                }
                else{
                    self.selected_samples_to_take.append( self.inventory_vm.target_sample_detail)
                }
            }
        }
    }
    
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
                                    content(row, column,InventorySampleModel(id: 0,freezer_box: "",freezer_inventory_column: column, freezer_inventory_row: row, is_suggested_sample: false,freezer_inventory_freeze_datetime: Date().ISO8601Format()))//MARK: change this to be dynamic when it is suggested
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



//MARK: put it on a separate page

struct SamplesInReturnCurrentBatchView : View{
    
    @Binding var samples_in_batch : [InventorySampleModel]
    
    @AppStorage(AppStorageNames.store_sample_batches.rawValue)  var store_sample_batches : [SampleBatchModel] = [SampleBatchModel]()
    
    @State var reset_cart_form_control : Bool = false
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    var body: some View{
        VStack{
            ZStack{
                batch_samples_list
            }
            .background(
                NavigationLink(destination: GuidedCartView(),isActive: $reset_cart_form_control,  label: {EmptyView()})
            )
        }
        .toast(isPresenting: $showResponseMsg){
            if self.isErrorMsg{
                return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
            }
            else{
                return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
            }
        }
        .navigationTitle("Items in Batch")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //add the selected_samples to store_sample_batches
                    //MARK: make batch on mobile screens
                    if samples_in_batch.count > 0{
                        var new_sample_batch = SampleBatchModel()
                        //made of UUID + Current date + number of samples
                        new_sample_batch.batchName = "\(UUID().uuidString)_\(Date().asShortDateString())_\(samples_in_batch.count)"
                        
                        for sample_detail in samples_in_batch{
                            new_sample_batch.samples.append(sample_detail)
                        }
                        //MARK: add to the database or global list
                        self.store_sample_batches.append(new_sample_batch)
                        
                        //clear the current selection of items and go back to the start of the form
                        //method
                        /*
                         MARK: pop to root tutorial
                         https://stackoverflow.com/questions/57334455/how-can-i-pop-to-the-root-view-using-swiftui
                         */
                        withAnimation {
                            self.samples_in_batch.removeAll()
                            self.reset_cart_form_control.toggle()
                        }
                        
                        
                    }
                    else{
                        self.responseMsg = "Must have 1 or more samples"
                        self.showResponseMsg = true
                        self.isErrorMsg = true
                    }
                    
                } label: {
                    HStack{
                        Image(systemName: "tray.and.arrow.up.fill")
                        Text("Take Samples")
                    }.roundButtonStyle()
                }
            }
        }
    }
    
    
}

extension SamplesInReturnCurrentBatchView{
    
    private var batch_samples_list : some View{
        
        Section{
            List{
                ForEach(samples_in_batch, id: \.id){ sample in
                    
                    HStack{
                        Text("\(sample.sample_barcode ?? "N/A")").bold()
                        Text("Inventory Type: \(sample.freezer_inventory_type)")
                    }.swipeActions {
                        Button("Remove") {
                            withAnimation {
                                samples_in_batch.removeAll(where: {$0.sample_barcode == sample.sample_barcode})
                            }
                        }
                        .tint(.red)
                    }
                    
                }
            }.listStyle(.plain)
        }
    }
    
}
