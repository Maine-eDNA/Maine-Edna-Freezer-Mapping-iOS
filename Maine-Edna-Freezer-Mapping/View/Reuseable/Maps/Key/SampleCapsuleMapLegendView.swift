//
//  SampleCapsuleMapLegendView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI

struct SampleCapsuleMapLegendView: View {

    var box_detail : BoxItemModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(box_detail.freezer_box_label.uppercased()) Sample Capsule Map Legend").font(.title2).bold()
            HStack{
                Rectangle()
                    .fill(Color(wordName: "purple")!)
                   .frame(width: 50, height: 50)
                Spacer().frame(width: 50)
                Text("Target Sample").font(.headline).bold()
            }
            HStack{
                Rectangle()
                    .fill(Color(wordName: "red")!)
                   .frame(width: 50, height: 50)
                Spacer().frame(width: 50)
                Text("Taken Sample Slot").font(.headline).bold()
            }
            HStack{
                Rectangle()
                    .fill(Color(wordName: "yellow")!)
                   .frame(width: 50, height: 50)
                Spacer().frame(width: 50)
                Text("Available Sample Slot").font(.headline).bold()
            }
            
        }.padding()
    }
}

struct SampleCapsuleMapLegendView_Previews: PreviewProvider {
    static var previews: some View {
        SampleCapsuleMapLegendView(box_detail: BoxItemModel())
    }
}
