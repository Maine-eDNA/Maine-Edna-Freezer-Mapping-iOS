//
//  EditBarcodeListView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI

//MARK: Add to its own View

struct EditBarcodeListView : View{
    //May want to show more details to track with the barcode number
    @Binding var target_barcodes : [String]
    
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    @State var show_guided_steps : Bool = false
    
    @State var show_sample_detail : Bool = false
    
    var body: some View{
        ZStack{
        VStack{
            
            List( self.target_barcodes, id: \.self){barcode in
                
                HStack{
                    Text("\(barcode)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                    if self.show_guided_steps{
                        withAnimation(.easeInOut){
                            Image(systemName: (self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode}) != nil) ? "checkmark.circle" : "xmark.circle")
                                .foregroundColor(((self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode})) != nil) ? Color.green : Color.red)
                        }
                        
                    }
                    
                }
                .swipeActions(edge: .leading){
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
                    
                }
            }
            
            .listStyle(.plain)
            //.animation(.spring(), value: 2)
            //  .padding(.horizontal,10)
        }
        }.background(
            NavigationLink(isActive: $show_sample_detail, destination: {
                ResultsPreviewView(inventoryLocation: $cart_vm.inventoryLocation)
            }, label: {
                EmptyView()
            })
        )
        .navigationTitle("Edit Barcode List")
    }
}
