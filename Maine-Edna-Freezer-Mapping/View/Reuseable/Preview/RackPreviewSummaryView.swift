//
//  RackPreviewSummaryView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI

struct RackPreviewSummaryView: View {
    @Binding var rack_detail : RackItemModel
    var body: some View {
        VStack{
            Text("Rack: \(rack_detail.freezer_rack_label)").font(.title).bold()
          
            HStack{
                Text("Row Start: \(rack_detail.freezer_rack_row_start)").font(.title3)
                Spacer()
                Text("Row End: \(rack_detail.freezer_rack_row_end)").font(.title3)
            }
            HStack{
                Text("Column Start: \(rack_detail.freezer_rack_column_start)").font(.title3)
                Spacer()
                Text("Column End: \(rack_detail.freezer_rack_column_end)").font(.title3)
            }
        }.padding()
    }
}

struct RackPreviewSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        RackPreviewSummaryView(rack_detail: .constant(RackItemModel()))
    }
}
