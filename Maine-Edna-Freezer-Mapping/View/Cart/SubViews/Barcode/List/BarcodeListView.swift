//
//  BarcodeListView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI

struct BarcodeListView : View{
    @Binding var target_barcodes : [String]
    
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    @State var show_guided_steps : Bool = false
    
    @State var show_sample_detail : Bool = false
    
    @State var show_edit_list : Bool = false
    
    @Binding var maximizeListSpace : Bool
    
    var body: some View{
        
        
        
        ZStack{
            VStack{
                //Edit mode to be able to swipe because of the swipe problem
                if target_barcodes.count > 0{
                    withAnimation(.easeOut){
                        edit_expand_barcode_list_section
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
                //Edit btn end
                
                // Text("Target Barcodes").bold()
                //Add swipe left to delete
                //swipe right to get details about the target barcode (search the db to find data on it)
                
                List( self.target_barcodes, id: \.self){barcode in
                    
                    HStack{
                        Text("\(barcode)")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                        /* if self.show_guided_steps{
                         withAnimation(.easeInOut){
                         Image(systemName: (self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode}) != nil) ? "checkmark.circle" : "xmark.circle")
                         .foregroundColor(((self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode})) != nil) ? Color.green : Color.red)
                         }
                         
                         }*/
                        
                    }
                    /* .swipeActions(edge: .leading){
                     Button(action: {
                     
                     
                     
                     cart_vm.FetchSingleInventoryLocation(_sample_barcode: barcode,_isAddToListMode: false)
                     
                     self.show_sample_detail.toggle()
                     }, label:{
                     HStack{
                     Image(systemName: "info.circle")
                     
                     }
                     }).tint(.blue)
                     
                     
                     
                     }
                     .swipeActions(edge: .trailing) {
                     Button(action: {
                     //remove from list
                     if let target_code = self.target_barcodes.firstIndex(of: barcode)
                     {
                     print("Index \(target_code)")
                     self.target_barcodes.remove(at: target_code)
                     }
                     //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                     }, label:{
                     HStack{
                     Image(systemName: "trash")
                     
                     }
                     }).tint(.red)
                     
                     }*/
                }
                
                .listStyle(.plain)
                //.animation(.spring(), value: 2)
                //  .padding(.horizontal,10)
                
            }
        }.background(
            
            NavigationLink(isActive: $show_edit_list, destination: {
                EditBarcodeListView(target_barcodes: $target_barcodes)
            }, label: {
                EmptyView()
            })
        )
        
        
        
        
    }
}

extension BarcodeListView{
    
    private var edit_expand_barcode_list_section : some View{
        HStack(spacing: 10){
            Spacer()
            
            
            Button {
                //action
                self.maximizeListSpace.toggle()
                
            } label: {
                HStack{
                    Image(systemName: self.maximizeListSpace == true ? "rectangle.arrowtriangle.2.inward":"rectangle.expand.vertical")
                    Text("List")
                }.roundButtonStyle()
            }
            
            Button {
                //open edit modal
                self.show_edit_list.toggle()
            } label: {
                HStack{
                    Image(systemName: "pencil")
                    Text("Barcodes")
                }.roundButtonStyle()
            }
            
        }
    }
    
}
