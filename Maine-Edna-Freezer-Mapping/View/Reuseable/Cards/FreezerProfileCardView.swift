//
//  FreezerProfileCardView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import SwiftUI

struct FreezerProfileCardView: View {
    var freezer_profile : FreezerProfileModel
    
    var body: some View {
        HStack{
            
        VStack(alignment: .leading){
            HStack{
                Text("\(freezer_profile.freezer_label)").font(.title2).bold()
            }
            HStack{
                VStack(alignment: .leading)
                {
                    Text("Max Capacity").font(.title3).bold()
                    Text("\(calc_max_capacity(max_row: freezer_profile.freezer_max_rows, max_col: freezer_profile.freezer_max_columns))").font(.body)
                }
                Spacer().frame(width: 40)
                VStack(alignment: .leading)
                {
                    Text("Max Depth").font(.title3).bold()
                    Text("\(freezer_profile.freezer_max_depth)").font(.title2)
                }
            }
        }
            Spacer()
        }.padding()
    }
    
    //May need to add it to its own file
    func calc_max_capacity(max_row : Int, max_col : Int) -> Int
    {
        return max_row * max_col
    }
}

struct FreezerProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerProfileCardView(freezer_profile: FreezerProfileModel())
    }
}
