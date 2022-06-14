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
                Text("\(freezer_profile.freezerLabel ?? "")").font(.title3).bold()
            }
            HStack{
                VStack(alignment: .leading)
                {
                    Text("\(freezer_profile.freezerRoomName ?? "")").font(.subheadline).foregroundColor(Color.theme.secondaryText).bold()
                    #warning("Fix this")
                    /*   Text("Max Capacity").font(.title3).bold()
                   Text("\(calc_max_capacity(max_row: freezer_profile.freezerCapacityRows ?? 0, max_col: freezer_profile.freezerCapacityColumns ?? 0))").font(.body)*/
                }
                Spacer().frame(width: 40)
                VStack(alignment: .leading)
                {
                    Text("Max Depth").font(.subheadline).foregroundColor(Color.theme.secondaryText).bold()
                    Text("\(freezer_profile.freezerCapacityDepth ?? 0)").font(.title3).font(.subheadline).foregroundColor(Color.primary)
                }
            }
        }
            Spacer()
        }.background(Color.theme.background.opacity(0.001)).padding()
    }
    
    //May need to add it to its own file
    //NEED TO DO THE CONVERSION
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
