//
//  RemoveConfirmationView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import SwiftUI

class RemoveConfirmationViewModel : ObservableObject{
    
    @Published var removalMessage : String = "Are you sure that you would like to permanently remove the following?"
    
}

struct RemoveConfirmationView: View {
    
    @StateObject var remove_vm : RemoveConfirmationViewModel = RemoveConfirmationViewModel()
    
    @Binding var sampleBarcodesToRemove : [String]
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            remove_confirm_msg_section
            
            samples_to_remove_section
            
            buttons_section
            
            Spacer()
        }.padding()
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
               
           }) {
               HStack{
                   Text("No")
               }.roundedRectangleButton()
           }
            
            Spacer()
            
            Button(action: {
                //yes then perm_remove all the samples in the list
                #warning("Next")
                
            }) {
                HStack{
                    Text("Yes")
                }.roundedRectangleButton()
            }
        }
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
