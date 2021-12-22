//
//  CartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/20/21.
//

import SwiftUI
import CarBode
import AVFoundation //import to access barcode types you want to scan
import Combine

struct CartView: View {
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
    @State var current_barcode : String = ""
    @State var show_barcode_scanner_btn : Bool = false
    
    
    
    var body: some View {
        //import CSV as well
        VStack(alignment: .leading){
            // Text("View to bulk return samples and bulk find samples in the freezer")
            VStack(alignment: .leading){
                Text("Target Barcodes").bold()
                List( self.target_barcodes, id: \.self){barcode in
                    Text("\(barcode)")
                }
                
            }.frame(height: 200)
            
            TextFieldLabelCombo(textValue: self.$current_barcode, label: "Barcode", placeHolder: "Enter barcode or press barcode button", iconValue: "number")
                .onReceive(Just(self.current_barcode)) { inputValue in
                    // With a little help from https://bit.ly/2W1Ljzp
                    if self.current_barcode.count > 1 {
                        self.show_barcode_scanner_btn = false
                    }
                    else{
                        show_barcode_scanner_btn = true
                    }
                }
            
            if show_barcode_scanner_btn{
                withAnimation{
                    Button(action: {
                        self.show_barcode_scanner.toggle()
                    }, label: {
                        HStack{
                            Text("Scan").font(.callout)
                            Image(systemName: "barcode")
                        }
                        .padding()
                        .foregroundColor(Color.white)
                    }).sheet(isPresented: self.$show_barcode_scanner)
                    {
                        //scanner start
                        CBScanner(
                            supportBarcode: .constant([.qr, .code128,.aztec,.code39,.dataMatrix]), //Set type of barcode you want to scan
                            scanInterval: .constant(5.0) //Event will trigger every 5 seconds
                        ){
                            //When the scanner found a barcode
                            print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                            self.target_barcodes.append($0.value)
                            
                            //close scanner
                            self.show_barcode_scanner.toggle()
                        }
                    onDraw: {
                        print("Preview View Size = \($0.cameraPreviewView.bounds)")
                        print("Barcode Corners = \($0.corners)")
                        
                        //line width
                        let lineWidth = 2
                        
                        //line color
                        let lineColor = UIColor.red
                        
                        //Fill color with opacity
                        //You also can use UIColor.clear if you don't want to draw fill color
                        let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                        
                        //Draw box
                        $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
                        
                        //scanner end
                    }
                        
                        
                    }.background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            Button(action: {
                //actions todo
            }, label: {
                HStack{
                    Text("Find all (\(self.target_barcodes.count)) Samples" )
                }.padding()
            }).background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }
    }
    
    //Function to keep text length in limits
    func limitText(_ current: String) {
        /* if self.current_barcode.count > upper {
         self.current_barcode = String(self.current_barcode.prefix(upper))
         }*/
        
        
    }
    
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
