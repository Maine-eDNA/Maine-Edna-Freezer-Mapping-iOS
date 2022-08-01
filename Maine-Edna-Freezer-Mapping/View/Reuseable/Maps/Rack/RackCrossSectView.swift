//
//  RackCrossSectView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct RackCrossSectView: View {
    
    var rack_profile : RackItemModel
    @Binding var rack_boxes : [BoxItemModel]
    @Binding var freezer_profile : FreezerProfileModel
    @Binding var current_rack_row : Int
    
    //Css section
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
    @State var user_css_settings : UserCssModel = UserCssModel()
    @ObservedObject var convert_service : ClassConverter = ClassConverter()
    
    //default css
    //if user css doesnt exist create one for this user
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    //New
    @Binding var show_guided_box_view : Bool
    @Binding var show_guided_rack_view : Bool
    
    ///used to not move to another screen when the screen called within a guided form
    @Binding var in_guided_sample_mode : Bool
    @State var show_box_samples_in_guided : Bool = false
    
    @State var showCreateFreezerBox : Bool = false
    
    @State private var targetRow : Int = 0
    @State private var targetColumn : Int = 0
    
    @State var targetBox : BoxItemModel = BoxItemModel()
    @State var showFreezerBoxDetail : Bool = false
    
    ///Used as a master list to show the records that need to be highlighted
    @State var inventoryLocations : [InventorySampleModel] = []
    @State var isInSearchMode : Bool = false
    
    @State var freezer_rack_label_slug : String = ""
    
    @StateObject private var vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
#warning("Need to refractor the box view to change the row based on the row selected and leave the row and column as is")
    
    
    //MARK: required to switch the sample map into tap to add to list mode etc
    @Binding var is_in_select_mode : Bool
    
    var body: some View {
#warning("Required Validation when entering new box it must meet the validation rules below")
        //TODO: - Need to add validation to prevent user from adding a position outside of the scope of the box, rack or freezer ( min starting position max position the max or furthest space)
        
#warning("NEXT Calculate the number of samples each box can hold and how much space is still available")
        /*
         
         Max Box Columns (Inventory) and Max Box Rows (Inventory) means the capacity of the Box 10 x 10 means 100 samples max
         
         So a Rack with 3 columns means a box can be in any of the 3 columns
         and a the rack has 5 Rows it means it can be in any of the rows
         so any of the row and column combination but must not fall outside of the range else show error
         */
        
        /*
         How the types work
         /
         row /      rack_profile.freezer_rack_row_start   rack_profile.freezer_rack_row_end
         depth  |   rack_profile.freezer_rack_depth_start  rack_profile.freezer_rack_depth_end
         |
         Column __  rack_profile.freezer_rack_column_start  rack_profile.freezer_rack_column_end
         */
        //MARK: start with depth then column then row
        
       
        
        #warning("Need to increment the rack_depth and implement the row switching for the rack layout")
        //MARK: rows
        //MARK: each row has columns and depth (height)
        ZStack{
            //MARK: Do row last show it when the selector is clicked for the row
            //if in_guided_sample_mode then dont navigate away just switch
            //show_box_samples_in_guided
            VStack{
              

                
                Group{
                if !show_box_samples_in_guided{
                    withAnimation {
                        box_loop_section
                    }
                }
                else if show_box_samples_in_guided{
                    withAnimation {
                        freezer_box_samples_section
                    }
                }
            }
            }
            
            .onAppear{
                debugPrint(rack_profile)
                print("Rack Name: \(self.rack_profile.freezer_rack_label_slug)")
               // print(freezer_rack_label_slug)
                print("Rack Name: \(self.rack_profile.freezer_rack_column_start)")
                //freezer_rack_column_start
                print("Amt of boxes : \(self.rack_boxes.count)")
                //get user css profile
                if self.store_user_default_css.count > 0{
                    user_css_settings = self.store_user_default_css.first!
                }
                else{
                    //use the default values
                    if self.store_default_css.count > 0{
                        user_css_settings = self.convert_service.DefaultCssToUserCss(_user_email: self.store_email_address, _default_css: self.store_default_css.first!)
                        print("User Settings from default Css Sample: \(user_css_settings.freezer_empty_box_css_background_color)")
                    }
                    
                }
                
                //MARK: If data not found
                /*print("Rack Label Slug: \(freezer_rack_label_slug)")
                
                self.vm.FilterFreezerBoxes(_freezer_rack_label_slug: "test_freezer_1_test_rack3")
                 */
                
            }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            self.show_box_samples_in_guided.toggle()
                        }
                    } label: {
                        HStack{
                            Text(show_box_samples_in_guided ?  "Show Box Layout" : "Show Samples")
                        }.roundButtonStyle()
                    }
                }
            }
            
        }  .background(){
            NavigationLink(destination: CreateNewFreezerBoxView(row: self.$targetRow, column: self.$targetColumn, freezer_profile: self.$freezer_profile,rack_profile: .constant(self.rack_profile)),isActive: self.$showCreateFreezerBox,  label: {EmptyView()})
        }
        .background(){
            //MARK: Need to send isInSearchMode so that it highlights the samples
            NavigationLink(destination: FreezerInventoryView(box_detail: self.$targetBox, freezer_profile: self.$freezer_profile,inventoryLocations: self.inventoryLocations,isInSearchMode: self.isInSearchMode,is_in_select_mode: $is_in_select_mode)
                           ,isActive: self.$showFreezerBoxDetail,  label: {EmptyView()})
        }
#warning("Fix these to pass parameters")
        /*.background(
         //  NavigationLink(destination: CreateNewFreezerBoxView(row: .constant(0), column: .constant(0), freezer_profile: self.$freezer_profile,rack_profile: .constant(self.rack_profile)))
         )
         .background(
         //NavigationLink(destination: FreezerInventoryView(box_detail: BoxModel(), freezer_profile: self.$freezer_profile))
         
         )*/
    
    }
}

extension RackCrossSectView{
   
    private var column_loop_section : some View{
        Section{
            
        }
    }
    
    
    private var depth_loop_section : some View{
        Section{
            
        }
    }
    
    
    private var row_loop_section : some View{
        Section{
            
        }
    }
    
    
    
    private var box_loop_section : some View{
        VStack{
            Text("Current Rack Row # \(current_rack_row)")
            if self.rack_boxes.count > 0{
                withAnimation(.easeInOut(duration: 5)){
                    //MARK: Depth is the height of the rack
                    ///plus 1 on the depth as not to exclude the last depth 1 to 3 should contain 1,2,3
                    ForEach(rack_profile.freezer_rack_depth_start ..< (rack_profile.freezer_rack_depth_end + 1), id: \.self) { rack_depth in
                        HStack {
                            ///plus 1 on the column as not to exclude the last column 1 to 3 should contain 1,2,3
                            ForEach(rack_profile.freezer_rack_column_start ..< (rack_profile.freezer_rack_column_end + 1), id: \.self) { rack_column in
                                ForEach(self.rack_boxes, id: \.freezer_box_label) {
                                    box in
                                    //MARK: handle depth later build the logic back uo
                                    
                                    ///checking if the box_column location is equal to the current rack column
                                     if box.is_suggested_box_position && box.freezer_box_column == rack_column{
                                        
                                         SuggestedBoxItemCard(box_color: "green", box_text_color: "white", freezer_box_row: 0, freezer_box_column: rack_column,freezer_rack_depth: rack_depth,freezer_rack: rack_profile.freezer_rack_label)
                                            .listRowBackground(Color.clear)
                                            .onTapGesture {
                                                
                                                self.show_guided_rack_view = false
                                                self.show_guided_box_view.toggle()
                                                //set the current box
                                                self.targetBox = box
                                                if !in_guided_sample_mode{
                                                    self.showFreezerBoxDetail.toggle()
                                                }
                                                else{
                                                    self.show_box_samples_in_guided.toggle()
                                                }
                                            }
                                        
                                    }
                                      else if box.freezer_box_column == rack_column{
                                        //BoxItemCard(rack_box: <#T##BoxItemModel#>, rack_depth: <#T##Int#>, rack_row: <#T##Int#>, box_color: <#T##String#>, box_text_color: <#T##String#>, height: <#T##CGFloat#>, width: <#T##CGFloat#>)
                                          BoxItemCard(rack_box: .constant(box),rack_depth: .constant(rack_depth), rack_row: .constant(0))
                                            .listRowBackground(Color.clear)
                                            .onTapGesture {
                                                
                                                
                                                //set the current box
                                                self.targetBox = box
                                                if !in_guided_sample_mode{
                                                    self.showFreezerBoxDetail.toggle()
                                                }
                                                else{
                                                    self.show_box_samples_in_guided.toggle()
                                                }
                                            }
                                        
                                    }
                                    else{
                                 
                                        //Create new box: send the row and column the current box is in and the freezer info
                                        
                                        BoxEmptyItemCard(freezer_box_row: 0 , freezer_box_column: rack_column,freezer_rack_depth: rack_depth,freezer_rack: rack_profile.freezer_rack_label)
                                        // .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                            .listRowBackground(Color.clear)
                                            .onTapGesture {
                                                //MARK: need to capture the depth and row separately
                                                // self.targetRow = depth //depth is what tells how far down a box is
                                                self.targetColumn = rack_column
                                                
                                                //When Empty should create new item doesnt matter the mode
                                                self.showCreateFreezerBox.toggle()
                                                
                                                //segue to the view
                                               /* if !in_guided_sample_mode{
                                                    self.showFreezerBoxDetail.toggle()
                                                }
                                                else{
                                                    self.show_box_samples_in_guided.toggle()
                                                    
                                                   
                                                }*/
                                            }
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                }
            }
            Spacer()
        }
    }
    
    
    private var freezer_box_samples_section : some View{
        FreezerInventoryView(box_detail: self.$targetBox, freezer_profile: self.$freezer_profile,inventoryLocations: self.inventoryLocations,isInSearchMode: self.isInSearchMode, is_in_select_mode: $is_in_select_mode)
    }
}


///.background(Color(wordName: box_color))//set the color based on the status of the box empty, half full and full (not available)







struct RackCrossSectView_Previews: PreviewProvider {
    static var previews: some View {
        #warning("Refractor and add to the Dev Preview")
        
        var rack_profile : RackItemModel = RackItemModel()
        var rack_boxes : [BoxItemModel] = [BoxItemModel]()
        var box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_capacity_row = 10
        box.freezer_box_capacity_column = 10 //row x col equal max capacity
        rack_boxes.append(box)
        
        
        var box2 = BoxItemModel()
        box2.id = 2
        box2.freezer_box_label = "rack_1_1_box_2"
        box2.freezer_box_capacity_row = 10
        box2.freezer_box_capacity_column = 10 //row x col equal max capacity
        rack_boxes.append(box2)
        
        
        rack_profile.freezer_rack_depth_end = 1
        rack_profile.freezer_rack_depth_start = 1
        rack_profile.freezer_rack_column_start = 1
        rack_profile.created_by = "keijaoh.campbell@maine.edu"
        rack_profile.freezer = "Freezer_Test_1"
        rack_profile.freezer_rack_label = "Freezer_Test_1_Rack_1"
        
        
        return Group {
            
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()), current_rack_row: .constant(1),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false),in_guided_sample_mode: .constant(false),is_in_select_mode: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()), current_rack_row: .constant(1),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false),in_guided_sample_mode: .constant(false),is_in_select_mode: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()), current_rack_row: .constant(1),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false),in_guided_sample_mode: .constant(false),is_in_select_mode: .constant(false))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
}

