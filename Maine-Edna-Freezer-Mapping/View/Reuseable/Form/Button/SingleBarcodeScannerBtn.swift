//
//  SingleBarcodeScannerBtn.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/2/22.
//


import SwiftUI
import CarBode
import AVFoundation //import to access barcode types you want to scan
import Combine

struct SingleBarcodeScannerBtn : View{
    
    @Binding var show_barcode_scanner : Bool
   
    @Binding var current_barcode : String
    @Binding var show_barcode_scanner_btn : Bool
    @State var supported_barcodes : [AVMetadataObject.ObjectType] = [.qr,.code128,.code39,.code39Mod43,.code93,.ean8,.interleaved2of5,.itf14,.ean13, .pdf417,.aztec,.upce,.dataMatrix]
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    //barcode preview
    @State var showBarCodePreview : Bool = false
    @State var showBarCodeDetail : Bool = false
    
    //view models
    @StateObject var vm : CartViewModel = CartViewModel()
    
    //Grid layout
    @State var buttonGridLayout = [GridItem(.flexible()),GridItem(.flexible())]
    
    var body : some View{
        
        Button(action: {
            self.show_barcode_scanner.toggle()
        }, label: {
            HStack{
                Image(systemName: "barcode")
                Text("Start Scanner").font(.callout)
                
            }.roundButtonStyle()
                .padding()
            //.foregroundColor(Color.white)
        }).sheet(isPresented: self.$show_barcode_scanner)
        {
            //ZStack Start
            ZStack{
                
                //scanner start
                CBScanner(
                    supportBarcode: self.$supported_barcodes, //Set type of barcode you want to scan
                    scanInterval: .constant(5.0) //Event will trigger every 5 seconds
                ){
                    //When the scanner found a barcode
                    print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                    
                    self.current_barcode = $0.value.lowercased()
                 
                    withAnimation {
                        //close the modal
                        self.show_barcode_scanner.toggle()
                    }
                    
                  
                    //close scanner
                    //  self.show_barcode_scanner.toggle()
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
                
                barcode_camera_preview_window
            }
            //ZStack End
            
        }//.background(Color.blue)
        // .cornerRadius(10)
        
    }
}


extension SingleBarcodeScannerBtn{
    //MARK: Done btn make up start
    
    private var finish_barcode_scanning_btn_label_top : some View{
        Section{
            Button(action: {
                withAnimation {
                    //close the modal
                    self.show_barcode_scanner.toggle()
                }
                
            }, label: {
                HStack{
                    Text("Done").foregroundColor(.white).bold().font(.title3).frame(width: 80,height: 40).background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
                
                
            })
        }
        
    }
    
    
    private var finish_barcode_scanning_btn : some View{
        Section{
            Button(action: {
                //Capture Barcode
                //close the modal
                self.show_barcode_scanner.toggle()
                
            }, label: {
                
                
                scannerbuttonlabel
                
            }).background(Color.white.opacity(0.75))
                .clipShape(Circle())
        }
        
    }
    
    //break this control up into pieces
    private var barcode_camera_preview_window : some View{

        VStack{
            
            Section{
                Spacer().frame(height: 5)
                HStack{
                    finish_barcode_scanning_btn_label_top
                    //.background(.ultraThinMaterial)
                    
                    Spacer()
                }.padding(.horizontal,5)
                .padding([.top], 20)
            }
        Section {
          // Spacer()
            
            
            VStack{
                Spacer()
                Image(systemName:"viewfinder")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .foregroundColor(Color.white)
                    .frame(height:100)
               // Spacer()
            }
            VStack {
              
                Spacer() // will spread content to top and bottom of VStack
                HStack(spacing: 45){
                    //could put another func here like flash light
                    Spacer()//.frame(maxWidth: 100)
                    finish_barcode_scanning_btn
                    Spacer()
                    
                    
                }
                Spacer()
                    .frame(height:50)  // limit spacer size by applying a frame
            }
        }
    }
        .ignoresSafeArea()
           
    }
    
    
    
    private var scannerbuttonlabel : some View{
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
            //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(Color.gray.opacity(0.15)))
                .frame(width: 100, height: 100)
            
            
            Circle()
            //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: 100 * 0.85, height: 100 * 0.85)
            //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(Color.secondary))
            VStack{
                Text("Done").font(.title2).bold().foregroundColor(.white)
                
            }
            
        }
    }
    
    

    
}



