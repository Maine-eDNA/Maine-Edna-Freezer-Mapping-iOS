//
//  FreezerInventoryView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct FreezerInventoryView: View {
    
    @Binding var box_detail : BoxItemModel
    @Binding var freezer_profile : FreezerProfileModel
    @StateObject var vm : FreezerInventoryViewModel = FreezerInventoryViewModel()
    @State var showNerdRackStats : Bool = false
    @State var show_map_key : Bool = false
    
    ///Used as a master list to show the records that need to be highlighted
    @State var inventoryLocations : [InventorySampleModel] = []
    @State var isInSearchMode : Bool = false
    @Binding var is_in_select_mode : Bool
    @Binding var selectMode : String //if in remove mode then the samples should be highlighted
    
    var body: some View {
        VStack(alignment: .leading){
            //MARK: Need to re-enable the following and make it collapsable
            #warning("Re-add the top but make it more uniform and less in the way")
            //Show Box Detail at the top
            VStack(alignment: .leading){
                HStack{
                    Text("Box Label").font(.title3).bold()
                    Spacer()
                    Text("\(self.box_detail.freezer_box_label ?? "")").font(.body)
                }
                HStack{
                    Text("in Rack").font(.title3).bold()
                    Spacer()
                    Text("\(self.box_detail.freezer_rack ?? "")").font(.body)
                }
                HStack{
                    Text("Max Capacity").font(.title3).bold()
                    Spacer()
                    if let row = self.box_detail.freezer_box_capacity_row, let column = self.box_detail.freezer_box_capacity_column{
                        Text("\((row * column))").font(.body)
                        
                    }
                }
                HStack{
                    Toggle("Nerd Stats", isOn: $showNerdRackStats)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                if showNerdRackStats{
                    
                    withAnimation(.spring()){
                        VStack(alignment: .leading){
                            HStack{
                                Text("Slug").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_label_slug ?? "")").font(.body)
                            }
                            HStack{
                                Text("Depth").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_depth ?? 0)").font(.body)
                            }
                            HStack{
                                Text("Box Row").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_row ?? 0)").font(.body)
                            }
                            HStack{
                                Text("Max Box Row").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_capacity_row ?? 0)").font(.body)
                            }
                            HStack{
                                Text("Box Column").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_column ?? 0)").font(.body)
                            }
                            HStack{
                                Text("Max Box Column").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.freezer_box_capacity_column ?? 0)").font(.body)
                            }
                            HStack{
                                Text("Created Date").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.created_datetime ?? "")").font(.body)
                            }
                            HStack{
                                Text("Modified Date").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.modified_datetime ?? "")").font(.body)
                            }
                            HStack{
                                Text("Created By").font(.title3).bold()
                                Spacer()
                                Text("\(self.box_detail.created_by ?? "")").font(.body)
                            }
                        }
                    }
                }
                
            }.padding()
            //Text("Show the capsules in the form of grids that look like a box (round capsules")
           /* HStack{
                Button(action: {
                    
                }, label: {
                    HStack{
                       Image(systemName: "plus")
                        Text("Sample").font(.caption)
                    }  .padding()
                }).foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(5)
                
                
                    Button(action: {
                        
                    }, label: {
                        HStack{
                           Image(systemName: "plus")
                            Text("Bulk").font(.caption)
                        } .padding()
                    }).foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                
                    Button(action: {
                        
                    }, label: {
                        HStack{
                           Image(systemName: "plus")
                            Text("CSV").font(.caption)
                        }.padding()
                    }).foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(5)
                
            }.padding()*/
            
            HStack{
                Text("Samples in \(self.box_detail.freezer_box_label ?? "")").font(.title3).bold()
                Label("Top-Down View", systemImage: "eye").font(.caption)
                Spacer()
                Button(action: {
                    //show the key
                    self.show_map_key.toggle()
                }, label: {
                    Image(systemName: "key").font(.title)
                }).tint(.blue)
            }.padding()
            
            if show_map_key{
                withAnimation(.spring())
                {
                    //make reuseable
                    //Sample Capsule Map Key
                    SampleCapsuleMapLegendView(box_detail: self.box_detail)
                }
            }
            #warning("Make sure samples are being sent to the box")
            //MARK: Need to show the get the samples that are the targets and  and the other samples like with boxes
            BoxSampleMapView(box: self.$box_detail, freezer_profile: self.$freezer_profile, is_in_select_mode: $is_in_select_mode, selectMode: $selectMode)
         
            
            Spacer()
        }
        //Navigation Section
        .navigationTitle("Box Profile Detail")
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear{
            print("Target Box ID: \(box_detail.id)")
            //MARK: need to send the inven_locations inventoryLocations
            //MARK: load from the previous page
           /* if isInSearchMode{
                self.vm.LoadFreezerInventoryData(box_detail: self.box_detail, inventoryLocations: self.inventoryLocations)
            }
            else{
                self.vm.LoadFreezerInventoryData(box_detail: self.box_detail, inventoryLocations: self.inventoryLocations)
            }*/
        }
    }
}

struct FreezerInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerInventoryView(box_detail: .constant(BoxItemModel()), freezer_profile: .constant(FreezerProfileModel()), is_in_select_mode: .constant(false), selectMode: .constant(""))
    }
}
