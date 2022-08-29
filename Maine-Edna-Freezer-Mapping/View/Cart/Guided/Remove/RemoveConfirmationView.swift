//
//  RemoveConfirmationView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import SwiftUI
import AlertToast

class RemoveConfirmationViewModel : ObservableObject{
    
    @Published var removalMessage : String = "Are you sure that you would like to permanently remove the following?"
    
    let permRemoveService : ReturnExtractionDataService = ReturnExtractionDataService()
    
    //properties to update the UI
    @Published var showResponseMsg : Bool = false
    @Published var isErrorMsg : Bool = false
    @Published var responseMsg : String = ""
    
    ///perm_remove samples from the freezer
    func permRemoveSamples(samplesToRemove : [FreezerInventoryPutModel],completion: @escaping (ServerMessageModel) -> Void){
        //have to do them one at a time
        //update this information on the UI so the user knows the progress
        let totalSampleCount : Int = samplesToRemove.count
        var numberOfSamplesToRemove : Int = totalSampleCount
        var numberOfSamplesRemoved : Int = 0
        
        for sample in samplesToRemove{
            //each sample to be removed sent to the API
            #warning("Use this logic to perm_remove samples then add new samples there when you are returning an extraction")
            permRemoveService.PermanentlyRemoveSample(_freezerInventory: sample) { response in
                
                if !response.isError{
                    //log that each sample was successfully perm_removed
                    
                    //one additional sampe removed
                    numberOfSamplesRemoved += 1
                    //one less sample left to be perm_removed
                    numberOfSamplesToRemove -= 1
                }
            }
        }
        
        //if all removed
       // if numberOfSamplesRemoved == totalSampleCount{
            
            self.responseMsg = "All Samples Successfully Removed"
            self.showResponseMsg = true
            self.isErrorMsg = false
            
            completion(ServerMessageModel(serverMessage: self.responseMsg ,  isError: false))
      //  }
        
    }
    
    
}

struct RemoveConfirmationView: View {
    
    @StateObject var remove_vm : RemoveConfirmationViewModel = RemoveConfirmationViewModel()
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    
    @Binding var sampleBarcodesToRemove : [String]
    

    
    @State var showStartOfUtilsView : Bool = false
    
    var body: some View {
        ZStack{
        VStack(alignment: .leading,spacing: 10){
            remove_confirm_msg_section
            
            samples_to_remove_section
            
            buttons_section
            
            Spacer()
        }.padding()
    }
        .background(
          //MARK: Need to send the Rack Location accross
            NavigationLink(destination:   UtilitiesView().navigationViewStyle(.stack), isActive: self.$showStartOfUtilsView,label: {EmptyView()})
      )
            .toast(isPresenting: $cart_vm.showResponseMsg){
                if self.cart_vm.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.cart_vm.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.cart_vm.responseMsg )")
                }
            }
        
    }
}

extension RemoveConfirmationView{
    
    private var remove_confirm_msg_section : some View{
        Section{
            Text("\(remove_vm.removalMessage)")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
        }
    }
    
    private var samples_to_remove_section : some View{
        List{
            ForEach(self.sampleBarcodesToRemove, id: \.self){ barcode in
                Text("\(barcode)")
                //MARK: add swipe to remove functionality to the list
                
            }
        }.listStyle(.plain)
    }
    
    //After removed, should show a summary report of what was removed
    private var buttons_section : some View{
        HStack{
            Button(action: {
                //cancel the opteration and go back to the previous page
                //go to the start of the form
                  withAnimation {
                      self.showStartOfUtilsView.toggle()
                      
                  }
            }) {
                HStack{
                    Text("No")
                }.roundedRectangleButton()
            }
            
            Spacer()
            
            Button(action: {
                
                //MARK: get the records for all the barcodes in this list
#warning("Get the records ")
                //convert string list to string separated by ,
                let barcodeStrList : String = sampleBarcodesToRemove.joined(separator: ",")
                
                // get the list  returned using completion
                self.cart_vm.FetchInventoryLocation(_sample_barcodes: barcodeStrList){ barcodesFound in
                    
                    //yes then perm_remove all the samples in the list
                    self.remove_vm.permRemoveSamples(samplesToRemove: convertInventoryLocationToPutModel(samples: barcodesFound)){ response in
                        
                        if !response.isError{
                            // Tell user all the samples were perm_removed and take the, back to the previous screen
                            
                          //go to the start of the form
                            withAnimation {
                                self.showStartOfUtilsView.toggle()
                                
                            }
                        }
                        
                    }
                }
                
                
            }) {
                HStack{
                    Text("Yes")
                }.roundedRectangleButton()
            }
        }
    }
    
    
}

extension RemoveConfirmationView{
    
    func convertInventoryLocationToPutModel(samples : [InventoryLocationResult]) -> [FreezerInventoryPutModel]{
        
        var convertedModelList : [FreezerInventoryPutModel] = [FreezerInventoryPutModel]()
        
        for sample in samples{
            //MARK: re-enable once the data is found
            convertedModelList.append(FreezerInventoryPutModel(id: sample.id, freezerBox: sample.freezerBox?.freezer_box_label_slug, sampleBarcode: sample.sampleBarcode, freezerInventoryType: sample.freezerInventoryType, freezerInventoryStatus: "perm_removed", freezerInventoryColumn: sample.freezerInventoryColumn, freezerInventoryRow: sample.freezerInventoryRow, freezerInventoryFreezeDatetime: Date().ISO8601Format()))
            
        }
        
        return convertedModelList
        
    }
}


struct RemoveConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RemoveConfirmationView(sampleBarcodesToRemove: .constant(dev.sampleBarcodesToRemove))
                .previewDevice(PreviewDevice(rawValue: device.iphone13Pro))
                .previewDisplayName(device.iphone13Pro)
            
            RemoveConfirmationView(sampleBarcodesToRemove: .constant(dev.sampleBarcodesToRemove))
                .previewDevice(PreviewDevice(rawValue: device.ipadAir4th))
                .previewDisplayName(device.ipadAir4th)
        }
    }
}
