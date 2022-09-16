//
//  SamplesFoundFromListView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 9/15/22.
//

import SwiftUI

struct SamplesFoundFromListView: View {
    
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    @Binding var target_barcodes : [String]
    
    @Binding var sampleLocationMaps : [SearchModeSampleMapModel]
    
    var body: some View {
        //Text("Shows where all the items from the barcode list was found, it also shows what samples were not found (x) Beside")
        VStack(alignment: .center){
         Text("All the Samples found and Where")
                .font(.title2)
                .foregroundColor(Color.primary)
                .bold()
            Text("In the next view, the samples will be grouped")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
            List{
                ForEach(sampleLocationMaps, id: \.id){ sampleMap in
                    
                    //put it in its own view
                    HStack{
                        Text("\(sampleMap.sampleProfile.sample_barcode)")
                            .font(.title3)
                            .bold()
                        Spacer()
                        
                        VStack(alignment: .leading){
                            Text("Freezer")
                            Text("\(sampleMap.freezerProfile.freezerLabel)")
                        }
                        
                        VStack(alignment: .leading){
                            Text("Rack")
                            Text("\(sampleMap.rackProfile.freezer_rack_label)")
                        }
                        
                        VStack(alignment: .leading){
                            Text("Box")
                            Text("\(sampleMap.boxProfile.freezer_box_label ?? "")")
                        }
                    }
                    
                    
                    
                }
            }
            Spacer()
        }
        
            .onAppear(){
                //on load try to find all the samples in this list
                let barcodeStrList : String = target_barcodes.joined(separator: ",")
                
                // get the list  returned using completion
                #warning("Show loading Spinner")
                self.cart_vm.FetchInventoryLocation(_sample_barcodes: barcodeStrList){ barcodesFound in
                    
                    sampleLocationMaps = convertInventoryLocationResultTo(inventory_sample_results: barcodesFound)
                }
                
                
            }
    }
}

extension SamplesFoundFromListView{
    //convert the InventoryLocationResult to be re-ordered from Freezer -> Rack -> Box -> Sample
    
    func convertInventoryLocationResultTo(inventory_sample_results : [InventoryLocationResult]) -> [SearchModeSampleMapModel]
    {
        //SearchModeSampleMapModel
        
        var reOrderedInventoryList : [SearchModeSampleMapModel] = [SearchModeSampleMapModel]()
        
        for inven in inventory_sample_results{
            
            var freezer : FreezerProfileModel = FreezerProfileModel()
            
            if let freezerResult =  inven.freezerBox?.freezer_rack?.freezer{
                freezer = freezerResult
            }
            
            var rack : RackModel = RackModel()
            
            if let rackResult = inven.freezerBox?.freezer_rack{
                rack = rackResult
            }
            
            var box : BoxModel = BoxModel()
            
            if let boxResult = inven.freezerBox{
                box = boxResult
            }
            
            var sampleInv : InventorySampleModel = InventorySampleModel()
            
          
            sampleInv = InventorySampleModel(freezer_box: inven.freezerBox?.freezer_box_label ?? "", freezer_inventory_column: inven.freezerInventoryColumn ?? 0, freezer_inventory_row: inven.freezerInventoryRow ?? 0, freezer_inventory_type: inven.freezerInventoryType ?? "", freezer_inventory_status: inven.freezerInventoryStatus ?? "", sample_barcode: inven.sampleBarcode ?? "", freezer_inventory_freeze_datetime: inven.createdDatetime ?? "")
        
            
            reOrderedInventoryList.append(SearchModeSampleMapModel(freezerProfile: freezer, rackProfile: rack, boxProfile: box, sampleProfile: sampleInv))
            
          
        }
        
        return reOrderedInventoryList
    }
    
    
    
}

struct SamplesFoundFromListView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesFoundFromListView(target_barcodes: .constant(dev.targetBarcodes), sampleLocationMaps: .constant([SearchModeSampleMapModel]()))
    }
}
