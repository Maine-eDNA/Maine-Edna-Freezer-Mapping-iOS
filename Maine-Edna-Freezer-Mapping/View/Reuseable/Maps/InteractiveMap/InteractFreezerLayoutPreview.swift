//
//  InteractFreezerLayoutPreview.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI

struct InteractFreezerLayoutPreview: View {
#warning("TODO TO MAKE THE COLOR DYNAMIC")
    //need to show the empty spots by pre-populating it and with the positions
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    @State var showSampleDetail : Bool = false
    @Binding  var freezer_max_rows : Int
    @Binding  var freezer_max_columns: Int
    @Binding var freezer_rack_layout : [RackItemModel]
    @State var freezer_profile : FreezerProfileModel
    @State var current_label : String = ""
    //conditional renders
    @Binding var show_create_new_rack : Bool
    //TODO: - need to get the system colors
    
    @State var max_capacity : Int = 0
    //TODO: - SHow when takes more than one row and col
    
    //Theme information
    //TODO: make it a environment object
    // @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    @AppStorage(AppStorageNames.stored_user_id.rawValue)  var stored_user_id : Int = 0
    //TODO: updated model (may need to make this into a map settings model
#warning("updated model (may need to make this into a map settings model")
    @State var inner_rack_rect_color : String = "gray"
    @State var suggested_outline_slot_color : String = "yellow"
    
    @Binding var show_guided_rack_view : Bool
    
    @Binding var show_guided_map_view : Bool
    
    @State var showingAlert : Bool = false
    @State var alertMsg : String = ""
    @State var inventoryLocations : [InventorySampleModel] = []
    @State var isInSearchMode : Bool = false
    
    @Binding var freezer_width : CGFloat
    @Binding var freezer_height : CGFloat
    
    var body: some View {
        //TODO outline the map with the row labels and column outline
        ScrollView([.horizontal, .vertical],showsIndicators: false){
            //Experiment
            //MARK: Show map only if them can be found
            // if let user_css = user_css_core_data_service.user_css_entity{
            InteractiveGridStack(rows: freezer_max_rows, columns: freezer_max_columns,racks: self.freezer_rack_layout) { row, col,content  in
                
                #warning("NEED TO POPULATE THE RACK PROFILE NEXT TO SHOW DATA FROM THE LIST")
                NavigationLink(destination: RackProfileView(rack_profile: .constant(content),freezer_profile: self.freezer_profile,isInSearchMode: self.isInSearchMode, inventoryLocations: self.inventoryLocations, addToRackMode: .constant(false))){
                    
                    if content.freezer_rack_row_start == row && content.freezer_rack_column_start == col{
                        //this is the target position where something exist
                        //  MultiRackSlotItemView(top_half_color: .constant("green"), bottom_half_color: .constant("gray"))
                        ///Check if it is a single or multi-rack level rack
                        if content.is_suggested_rack_position && (content.freezer_rack_depth_end - content.freezer_rack_depth_start) > 0{
                            SuggestedRackGridItemView(inner_rack_rect_color: self.$inner_rack_rect_color, outline_color: self.$suggested_outline_slot_color, rack_label: .constant(content.freezer_rack_label))
                             /*   .onTapGesture {
                                    //allow users to clip it to be able to see the suggest rack layout
                                    self.show_guided_map_view = false
                                    self.show_guided_rack_view.toggle()
                                }*/
                        }
                        else if (content.freezer_rack_depth_end - content.freezer_rack_depth_start) > 0{
                            //MARK: - multi-level rack level section
                            MultiRackSlotItemView(top_half_color: .constant(/*user_css.freezer_inuse_rack_css_text_color ??*/ "green"), bottom_half_color: .constant(/*user_css.freezer_empty_rack_css_text_color ?? */"gray"),width: 50,height: 50)
                            
                            
                        }
                        else if (content.freezer_rack_depth_end - content.freezer_rack_depth_start) < 1{
                            //MARK: - single rack level section
                            //single rack level color scheme
                            //Text("\(content.freezer_rack_label) Depth End: \(content.freezer_rack_depth_end) Depth Start: \(content.freezer_rack_depth_start)")
                            SingleLevelRaciSlotItemView(single_lvl_rack_color: .constant(/*user_css.freezer_inuse_rack_css_text_color ?? */"blue"))
#warning("Use Alert Toast")
                            /*.onLongPressGesture {
                             self.showingAlert = true
                             print("Row: \(row) Column: \(col)")
                             self.alertMsg = "Row: \(row) Column: \(col)"
                             self.showingAlert.toggle()
                             
                             }*/
                            
                        }
                        else if content.is_suggested_rack_position && (content.freezer_rack_depth_end - content.freezer_rack_depth_start) < 1{
                            SuggestedRackGridItemView(inner_rack_rect_color: self.$inner_rack_rect_color, outline_color: self.$suggested_outline_slot_color, rack_label: .constant(content.freezer_rack_label))
                             /*   .onTapGesture {
                                    //allow users to clip it to be able to see the suggest rack layout
                                    self.show_guided_map_view = false
                                    self.show_guided_rack_view.toggle()
                                }*/
                        }
                        
                    }
                    else if content.is_suggested_rack_position {
                        SuggestedRackGridItemView(inner_rack_rect_color: self.$inner_rack_rect_color, outline_color: self.$suggested_outline_slot_color, rack_label: .constant(content.freezer_rack_label))
                         /*   .onTapGesture {
                                //allow users to clip it to be able to see the suggest rack layout
                                self.show_guided_map_view = false
                                self.show_guided_rack_view.toggle()
                            }*/
                    }
                    else{
                        //MARK: - Empty Rack Section
                        //empty rack color
                        // Text("\(row) - \(col) =>  \(content.freezer_rack_row_start) - \(content.freezer_rack_column_start)")
                        // if let empty_rack_css = user_css.freezer_empty_rack_css_text_color {
                        // EmptyRackSlotView(empty_rack_color: .constant(empty_rack_css),width: 50,height: 50)
                        
                        // }
                        //  else{
                        EmptyRackSlotView(empty_rack_color: .constant("gray"),width: 50,height: 50)
                            .onTapGesture {
                                //show_create_new_rack
                                //open the model
                                withAnimation {
                                    self.show_create_new_rack.toggle()
                                }
                            }
                        //SuggestedRackGridItemView(inner_rack_rect_color: self.$inner_rack_rect_color, outline_color: self.$suggested_outline_slot_color)
                        // }
                    }
                } .alert(self.alertMsg, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                
                
            }.buttonStyle(PlainButtonStyle())  /*Remove Navigation Link blue tint*/
               // .frame(width: freezer_width, height: freezer_height, alignment: .center)
            
            
            
        }
        
        
        
        .onAppear{
            //Get freezer layout
            self.max_capacity = (freezer_profile.freezerCapacityRows ?? 0) * (freezer_profile.freezerCapacityColumns ?? 0)
#warning("Need to fix this")
            //self.user_css_core_data_service.fetchTargetUserCssById(_userCssId: self.stored_user_id)
            if freezer_rack_layout.count > 0{
                print("Interaction \(freezer_rack_layout.first?.freezer_rack_label_slug)")
            }
        }
    }
}

struct InteractFreezerLayoutPreview_Previews: PreviewProvider {
    static var previews: some View {
        InteractFreezerLayoutPreview(freezer_max_rows: .constant(0), freezer_max_columns: .constant(0), freezer_rack_layout: .constant([RackItemModel]()), freezer_profile: FreezerProfileModel(), show_create_new_rack: .constant(false), show_guided_rack_view: .constant(false), show_guided_map_view: .constant(false),freezer_width: .constant(UIScreen.main.bounds.width * 0.95),freezer_height: .constant(UIScreen.main.bounds.height * 0.95))
        
    }
}


struct InteractiveGridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let racks : [RackItemModel]
    let content: (Int, Int,RackItemModel) -> Content
    //letters of the alphabet start
    let alphabet : [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    //letters of the alphabet end
    
    var body: some View {
        VStack {
            
            //add these parts into sub views
            
            ForEach(0 ..< rows, id: \.self) { row in
                
                HStack {
                    ForEach((0 ..< columns), id: \.self) { (column) in
                        
                        // if column == 0{
                        HStack{
                            
                            Text("\(( column == 0 ? String(alphabet[row]).uppercased() : "") )")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal,column == 0 ? 10 : 0)
                            
                        }
                        
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
                            if let rack = racks.first(where: {$0.freezer_rack_column_start == column  && $0.freezer_rack_row_start == row}){
                                content(row, column,rack)
                            }
                            else{
                                content(row, column,RackItemModel(id: 0, freezer_rack_label: "Empty", freezer_rack_label_slug: "Empty", is_suggested_rack_position: false))
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
    
    init(rows: Int, columns: Int, racks: [RackItemModel], @ViewBuilder content: @escaping (Int, Int,RackItemModel) -> Content) {
        self.rows = rows
        self.columns = columns
        self.racks = racks
        
        self.content = content
    }
}
