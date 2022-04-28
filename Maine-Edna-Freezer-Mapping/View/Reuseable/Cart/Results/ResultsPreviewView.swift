//
//  ResultsPreviewView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 4/14/22.
//

import SwiftUI

struct ResultsPreviewView: View {
    
    @Binding var inventoryLocation : InventoryLocationResult
    var body: some View {
    
        HStack{
            
            //
            
        }
    }
}

struct ResultsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsPreviewView(inventoryLocation: .constant(dev.inventoryLocationResult))
    }
}
