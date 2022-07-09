//
//  FreezerIconView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/26/22.
//

import SwiftUI

struct FreezerVisualView: View {
    
    @Binding var freezerProfile : FreezerProfileModel
    @State var box_color : String = "blue"
    @State var box_text_color : String = "blue"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300

    
    var body: some View {
        VStack{
            
            iconsection
        }
    }
}

struct FreezerVisualView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerVisualView(freezerProfile: .constant(dev.freezerProfile))
            .previewLayout(.sizeThatFits)
    }
}


extension FreezerVisualView{
    
    
    private var iconsection : some View{
        Section{
            ZStack{
                VStack(alignment: .leading){
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .rotation(.degrees(45), anchor: .bottomLeading)
                            .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width, height: height * 0.15)
                            .background(Color(wordName: box_color))
                            .foregroundColor(Color(wordName: box_color))
                            .clipped()
                    }
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .rotation(.degrees(45), anchor: .bottomLeading)
                        // .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width, height: height)
                            .background(Color.white)
                            .foregroundColor(Color.white)
                            .clipped()
                    }.border(.black, width: 2)
                        .border(.black, width: 2)
                        .padding(.top, -10)
                    
                }
                VStack(alignment: .leading){
                    HStack(alignment: .top){
                        
                        Spacer().frame(width: 150,height: 10)
                        HStack{
                            Text("\(freezerProfile.freezerRatedTemp ?? 0)").foregroundColor(Color.black).font(.caption).bold()
                            Text(freezerProfile.freezerRatedTempUnits ?? "No Unit").foregroundColor(Color.black).font(.caption)
                        }
                        //
                    }
                    
                    HStack{
                        Text("\(freezerProfile.freezerLabel ?? "")").foregroundColor(Color.black).font(.title3).bold().minimumScaleFactor(0.01)
                        
                    }
                    HStack(spacing: 30){
                        VStack(alignment: .leading){
                            Text("Room").foregroundColor(Color.black).font(.callout)//.bold()
                            
                            //MARK: need to show how much space is left in the future
                            HStack{
                                Text("\(freezerProfile.freezerRoomName ?? "")").foregroundColor(Color.black).font(.callout).bold()
                                
                            }
                            
                        }
                        
                        VStack(alignment: .leading){
                            Text("Capacity").foregroundColor(Color.primary).font(.callout)
                            Text("\(calculatingFreezerCapacity())").foregroundColor(Color.black).font(.callout)
                        }
                        
                    }
                    
                    
                    
                    
                }
            }
            
            
            
            
        }
    }
    //functions part
    ///Calculating capacity as rows * width * depth capacity to get the freezer capacity
    func calculatingFreezerCapacity() -> Int{
        
        let rows = Int(freezerProfile.freezerCapacityRows ?? 0)
        let columns = Int(freezerProfile.freezerCapacityColumns  ?? 0)
        let depth = Int(freezerProfile.freezerCapacityDepth ?? 0)
        
        return Int(rows * columns * depth)
        
        
    }
    
}
