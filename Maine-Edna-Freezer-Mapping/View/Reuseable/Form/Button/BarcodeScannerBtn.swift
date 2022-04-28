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
    @State var showBarCodeDetail : Bool = false
    
    //view models
    @StateObject var vm : CartViewModel = CartViewModel()
    
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
                    
                    //if barcode doesnt already exist
                    if target_barcodes != nil{
                        let targetBarcode = $0.value.lowercased()
                        if (target_barcodes.first(where: {$0 == targetBarcode}) == nil)
                        {
                            //not found
                            self.target_barcodes.append(targetBarcode.lowercased())
                        }
                        
                        
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
                    Text("Done").foregroundColor(.white).bold().font(.title3).frame(width: 80,height: 40).background(.ultraThinMaterial)
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
                        //close the modal
                        self.show_barcode_scanner.toggle()
                        
                    }, label: {
                        
                        
                        scannerbuttonlabel

                    }).background(Color.teal.opacity(0.75))
                        .clipShape(Circle())
                    Spacer().frame(width: 80)
                }
               
                scancountpreviewbox
                
                
            }.padding(.bottom,40)
                .sheet(isPresented: self.$showBarCodeDetail) {
                    VStack{
                        Text("Target Barcode details")
                        Text(vm.inventoryLocation.freezerBox?.freezer_box_label ?? "")
                    }
                }
            
        }.ignoresSafeArea()
            .sheet(isPresented: self.$showBarCodePreview){
                HStack{
                    preview_barcode_list
                }
            }
    }
    
    private var scancountpreviewbox : some View{
        VStack(alignment: .center){
            Text("Codes").bold().font(.subheadline).foregroundColor(.white).padding(.top,0)
            
            ZStack{
                Circle().frame(width: 50, height: 50).foregroundColor(.teal)
                Text("\(self.target_barcodes.count)").bold().font(.subheadline).foregroundColor(.white)
            }
            Spacer().frame(height: 3)
        }.frame(width: 80,height: 80).background(.ultraThinMaterial)
            .cornerRadius(10)
            .onTapGesture {
                //show the half modal
                self.showBarCodePreview.toggle()
            }
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
    
    
    private var preview_barcode_list : some View{
        NavigationView{
        VStack{
            
         
            //Add swipe left to delete
            //swipe right to get details about the target barcode (search the db to find data on it)
            List{
                ForEach( self.target_barcodes, id: \.self){barcode in
                Text("\(barcode)")
                    .swipeActions(edge: .leading){
                        Button(action: {
                      
                            //get the details on the current barcode
                            vm.FetchSingleInventoryLocation(_sample_barcode: barcode)
                            
                            self.showBarCodeDetail.toggle()
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
                   
                    }
            }
            
        }.listStyle(.plain)
            
                .navigationTitle("(\(self.target_barcodes.count)) Barcode\(self.target_barcodes.count > 1 ? "s" : "")")
                .navigationBarTitleDisplayMode(.inline)
        }
            .animation(.spring(), value: 2)
            .navigationViewStyle(StackNavigationViewStyle())
    }
    }
    
}



struct BarcodeScannerBtn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            BarcodeScannerBtn(show_barcode_scanner: .constant(true), target_barcodes: .constant(["eSG_E01_19w_0001","eSG_E01_19w_0004"]), current_barcode: .constant("eSG_E01_19w_0001"), show_barcode_scanner_btn: .constant(true))
            //  .environmentObject(dev.dashboardVM)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
