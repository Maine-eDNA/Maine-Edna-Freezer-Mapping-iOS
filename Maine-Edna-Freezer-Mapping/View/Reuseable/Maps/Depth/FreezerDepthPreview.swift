//
//  FreezerDepthPreview.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/4/21.
//

import SwiftUI

struct FreezerDepthPreview: View {
    
      let columns = [
          GridItem(.adaptive(minimum: 100))
      ]
      @State var showSampleDetail : Bool = false
      @Binding  var freezer_max_rows : Int

      
      var body: some View {
          
          GridStack(rows: freezer_max_rows, columns: 1) { row, col in
              
              SingleLevelRaciSlotItemView(single_lvl_rack_color: .constant("blue"))
             
           }
       }
}

struct FreezerDepthPreview_Previews: PreviewProvider {
    static var previews: some View {
        FreezerDepthPreview(freezer_max_rows: .constant(0))
    }
}
