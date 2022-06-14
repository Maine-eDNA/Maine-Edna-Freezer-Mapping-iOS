//
//  ResultsPreviewView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 4/14/22.
//

import SwiftUI

struct ResultsPreviewView: View {
    
    @Binding var inventoryLocation : InventoryLocationResult
    /*
     var sampleBarcode, freezerInventorySlug, freezerInventoryType, freezerInventoryStatus: String?
     var freezerInventoryColumn, freezerInventoryRow: Int?
     var freezerBox: BoxModel?
     var createdBy, createdDatetime, modifiedDatetime: String?
     */
    var body: some View {
    
        VStack(alignment: .leading,spacing: 10){
        // #warning("Design a screen that shows the details about the target sample as to where to find it ")
    
            VStack(alignment: .leading,spacing: 2){
                //MARK: use grid
                //freezer it is in and the room
                Text("freezer").font(.caption2).foregroundColor(Color.white)
                Text("\(inventoryLocation.freezerBox?.freezer_rack?.freezer?.freezerLabel ?? "No Freezer Found")")
                    .font(.title3)
                    .foregroundColor(Color.white)
                
                Text("building").font(.caption2).foregroundColor(Color.white)
                Text("\(inventoryLocation.freezerBox?.freezer_rack?.freezer?.freezerRoomName ?? "No Room Found")")
                    .font(.title3)
                    .foregroundColor(Color.white)
                
                Text("barcode").font(.caption2).foregroundColor(Color.white)
                Text("\(inventoryLocation.sampleBarcode ?? "")")
                    .font(.title3)
                    .foregroundColor(Color.white)
                
            }
            .padding(.all)
            .frame(width: UIScreen.main.bounds.width * 0.90)
            .background(Color.theme.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
               
            
            Section(header: Text("Box Detail").font(.subheadline).foregroundColor(Color.theme.secondaryText)) {
                List{
              
                    BoxDetailSpecListItemView(label: .constant("Name"), labelValue: .constant(inventoryLocation.freezerBox?.freezer_box_label ?? ""))
                    
                    BoxDetailSpecListItemView(label: .constant("Found in"), labelValue: .constant(inventoryLocation.freezerBox?.freezer_rack?.freezer_rack_label ?? ""))
                
                    
                }.listStyle(.automatic)
                
            }
        }.padding(.all)
    }
}

struct ResultsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsPreviewView(inventoryLocation: .constant(dev.inventoryLocationResult))
    }
}


//MARK: reusable place in own file
struct BoxDetailSpecListItemView : View{
    
    @Binding var label : String
    @Binding var labelValue : String
    
    var body: some View{
        HStack{
            Text("\(label)")
                .foregroundColor(Color.theme.secondaryText)
            
            Spacer()
            Text(labelValue)
                .font(.subheadline)
               
        }
    }
}
