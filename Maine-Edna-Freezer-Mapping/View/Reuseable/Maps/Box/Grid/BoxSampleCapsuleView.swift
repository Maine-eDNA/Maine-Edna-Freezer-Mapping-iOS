//
//  BoxSampleCapsuleView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/29/21.
//

import SwiftUI

struct BoxSampleCapsuleView: View {
    /*@Binding var background_color : String
    @Binding var sample_code : String
    @Binding var sample_type_code : String*/
    
    
   // @State var foreground_color : String = "white"
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
  
    
    //Handle the colors here
    /*
     background_color: .constant(ColorSetter().setColorBasedOnSampleType(freezer_inventory_type: content.freezer_inventory_type)),sample_code: .constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")),sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")), foreground_color: .constant("white"),width: 50,height: 50
     */
    //InventorySampleModel
    @Binding var sampleDetail : InventorySampleModel
    
    
    @Binding var targetSamples : [InventorySampleModel]
    
    @Binding var isSelected : Bool
    
    var colorCondition : Bool{
        ((targetSamples.first(where: {$0.id == sampleDetail.id}) != nil) /*&& isSelected*/)
    }
    //MARK: need to be able select multiple
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .foregroundColor(
                    colorCondition ? Color.green :
                    Color(wordName: ColorSetter().setColorBasedOnSampleType(freezer_inventory_type: sampleDetail.freezer_inventory_type)) )
                .frame(width: width, height: height)
                
            
            Circle()
              //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
                //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(
                    
                    colorCondition ? Color.green :
                    Color(wordName: ColorSetter().setColorBasedOnSampleType(freezer_inventory_type: sampleDetail.freezer_inventory_type))
                
                ))
            VStack{//convertToSampleCode
                Text("\(convertToSampleTypeCode().capitalized)").font(.caption2)
                  .foregroundColor(Color(wordName: ColorSetter().setForegroundColor())).bold()
                Text("\(convertToSampleCode())").font(.system(size: 9))  .foregroundColor(Color(wordName: ColorSetter().setForegroundColor())).bold()
            }
        }
     
    }
}

struct BoxSampleCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleCapsuleView(sampleDetail: .constant(InventorySampleModel()), targetSamples: .constant([InventorySampleModel()]), isSelected: .constant(false))
    }
}

extension BoxSampleCapsuleView{
    
    func convertToSampleCode() -> String{
        return String(!sampleDetail.sample_barcode.isEmpty ? sampleDetail.sample_barcode.suffix(4) : "N/A")
    }
    
    func convertToSampleTypeCode() -> String{
        return String(!sampleDetail.freezer_inventory_type.isEmpty ? sampleDetail.freezer_inventory_type.prefix(1) : "N/A")
    }
}


struct BoxSampleCapsuleColorView: View {
    @Binding var background_color : Color
    @Binding var sample_code : String
    @Binding var sample_type_code : String
    @Binding var foreground_color : Color
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.red, lineWidth: 1)
                //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(background_color ))
                .frame(width: width, height: height)
                
            
            Circle()
              //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
                //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor( background_color ))
            VStack{
                Text("\(sample_type_code.capitalized)").font(.caption2).foregroundColor(foreground_color).bold()
                   
                Text("\(sample_code)").font(.system(size: 9))
                  .foregroundColor(foreground_color).bold()
            }
        }
     
    }
}
