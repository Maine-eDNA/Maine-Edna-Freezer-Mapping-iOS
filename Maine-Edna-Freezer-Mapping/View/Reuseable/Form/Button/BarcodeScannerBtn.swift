//
//  BarcodeScannerBtn.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/28/21.
//

import SwiftUI
import CarBode
import AVFoundation //import to access barcode types you want to scan
import Combine

struct BarcodeScannerBtn : View{
    
    @Binding var show_barcode_scanner : Bool
    @Binding var target_barcodes : [String]
    @Binding var current_barcode : String
    @Binding var show_barcode_scanner_btn : Bool
    @State var supported_barcodes : [AVMetadataObject.ObjectType] = [.qr,.code128,.code39,.code39Mod43,.code93,.ean8,.interleaved2of5,.itf14,.ean13, .pdf417,.aztec,.upce,.dataMatrix]
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    //barcode preview
    @State var showBarCodePreview : Bool = false
    
    var body : some View{
        
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
            //ZStack Start
            ZStack{
                
            //scanner start
            CBScanner(
                supportBarcode: self.$supported_barcodes, //Set type of barcode you want to scan
                scanInterval: .constant(5.0) //Event will trigger every 5 seconds
            ){
                //When the scanner found a barcode
                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                self.target_barcodes.append($0.value)
                
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
            
        }.background(Color.blue)
            .cornerRadius(10)
        
    }
}


extension BarcodeScannerBtn{
    //break this control up into pieces
    private var barcode_camera_preview_window : some View{
        //Text("TEST").font(.title).foregroundColor(.primary)
        VStack(alignment: .center, spacing: 10){
            Spacer().frame(height: 5)
            HStack{
                Button(action: {
                    //close the modal
                    self.show_barcode_scanner.toggle()
                    
                }, label: {HStack{
                    Text("Done").font(.title3).frame(width: 80,height: 40).background(.thinMaterial)
                        .cornerRadius(10)
                }})//.background(.ultraThinMaterial)
                   
                Spacer()
            }.padding(.horizontal,5)
            Spacer()
        HStack{
            Spacer()//.frame(width: 100)
            HStack{
           
            Button(action: {
                //Capture Barcode
                
            }, label: {
                Text("Scan").foregroundColor(.white)
                    .padding().frame(width: 100, height: 100, alignment: .center)
            }).background(Color.teal)
                .clipShape(Circle())
                Spacer().frame(width: 100)
            }
           // HStack{
            //    Spacer()
                VStack(alignment: .center){
                    Text("Codes").bold().font(.subheadline).foregroundColor(.primary)
                  
                    ZStack{
                        Circle().frame(width: 50, height: 50).foregroundColor(.teal)
                        Text("\(self.target_barcodes.count)").font(.title3).foregroundColor(.white)
                    }
                    Spacer().frame(height: 3)
                }.frame(width: 80,height: 80).background(.thinMaterial)
                .cornerRadius(10)
                    .onTapGesture {
                        //show the half modal
                        self.showBarCodePreview.toggle()
                    }
          //  }
            
            
        }.padding(.bottom,30)
        
        }.ignoresSafeArea()
            .sheet(isPresented: self.$showBarCodePreview){
                HStack{
                    preview_barcode_list
                }
            }
    }
    
    
    private var preview_barcode_list : some View{
        
        VStack{
            
            Text("\(self.target_barcodes.count) Barcodes").bold()
            //Add swipe left to delete
            //swipe right to get details about the target barcode (search the db to find data on it)
            List( self.target_barcodes, id: \.self){barcode in
                Text("\(barcode)")
                    .swipeActions(edge: .leading){
                        Button(action: {
                            //clear temp container
                            //  self.current_target_sample = InventorySampleModel() //deallocate object and reset it
                            
                            //will show the details of this item what ever was found
                            //Capture the current value
                          /*  if let target = self.all_unfiltered_stored_box_samples.filter({sample in return sample.sample_barcode == barcode}).first{
                                
                                //Translator Func
                              //  self.TranslateSampleData(_target: target)
                                
                            }
                            else{
                                self.current_target_sample.sample_barcode = "" //deallocate object and reset it
                            }
                            self.show_sample_detail.toggle()*/
                        }, label:{
                            HStack{
                                Image(systemName: "info.circle")
                                
                            }
                        }).tint(.blue)
                        
                        
                        
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            //remove from list
                            if let target_code = self.target_barcodes.firstIndex(of: barcode)
                            {
                                print("Index \(target_code)")
                                self.target_barcodes.remove(at: target_code)
                            }
                            //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                        }, label:{
                            HStack{
                                Image(systemName: "trash")
                                
                            }
                        }).tint(.red)
                        Button(action: {
                            //remove from list
                            /*if let target_code = self.target_barcodes.firstIndex(of: barcode)
                            {
                                print("Index \(target_code)")
                                self.target_barcodes.remove(at: target_code)
                            }*/
                            //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                        }, label:{
                            HStack{
                                Text("Preview") //preview what the record is
                                
                            }
                        }).tint(.blue)
                    }
            }
            
        }.animation(.spring(), value: 2)
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
}
