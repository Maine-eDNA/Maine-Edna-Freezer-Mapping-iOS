//
//  SamplePreviewPositionView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/29/22.
//

import SwiftUI

struct SamplePreviewPositionView: View {
    
    
    @Binding var column : Int
    @Binding var row : String
    @Binding var inven_type_abbrev : String
    @Binding var barcode_last_three_digits : String
    
    
    var body: some View {
        samplepositionpreviewsection
    }
}

struct SamplePreviewPositionView_Previews: PreviewProvider {
    static var previews: some View {
        SamplePreviewPositionView(column: .constant(0), row: .constant("C"), inven_type_abbrev: .constant("Filter"), barcode_last_three_digits: .constant("eSG_E01_19w_0004"))
    }
}


extension SamplePreviewPositionView{
    
    private var samplepositionpreviewsection : some View{
        VStack(alignment: .center){
            GeometryReader{
                reader in
                
                VStack{
                    //Rectangle().foregroundColor(.blue)
                    VStack{
                        Text("Column").font(.subheadline).foregroundColor(.secondary)
                        Text("\(column)").font(.subheadline).foregroundColor(.primary).bold()
                        
                    }
                    HStack{
                        VStack{
                            Text("Row").font(.subheadline).foregroundColor(.secondary)
                            Text(row).font(.subheadline).foregroundColor(.primary).bold()
                            
                        }
                        VStack{
                            ZStack{
                                
                                Circle().foregroundColor(.cyan)
                                    .frame(width: reader.size.width * 0.5, height: reader.size.height * 0.5)
                                
                                Circle().foregroundColor(.gray)
                                    .frame(width: reader.size.width * 0.40, height: reader.size.height * 0.40)
                                VStack{
                                    Text(inven_type_abbrev.prefix(1)).font(.subheadline).foregroundColor(.white)//.bold()
                                    Text(barcode_last_three_digits.suffix(4)).font(.subheadline).foregroundColor(.white).bold()
                                }
                            }
                        }
                    }
                    
                }
            }.frame(width: 200,height: 200)
        }
    }
    
    
}
