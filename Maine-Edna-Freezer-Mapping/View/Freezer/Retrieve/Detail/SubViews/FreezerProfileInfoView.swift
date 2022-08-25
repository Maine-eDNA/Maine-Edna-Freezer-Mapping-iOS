//
//  FreezerProfileInfoView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/22/22.
//

import SwiftUI
import AlertToast

struct FreezerProfileInfoView: View {
    @Binding var freezerProfile : FreezerProfileModel
    @Environment(\.dismiss) var dismiss
    @StateObject var freezerDelete_vm : FreezerDeletionViewModel = FreezerDeletionViewModel()
    
    @State var showDeleteFreezerConfirm : Bool = false
    
    let twoColumn : [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    //clean up by putting in another file
    var freezerTotalCapacity : Int{
        if let colCap = self.freezerProfile.freezerCapacityColumns, let rowCap = freezerProfile.freezerCapacityRows{
            return (colCap * rowCap )
        }
        else{
            return 0
        }
    }
    
    var createdDateTime : String{
        if let dateStr = self.freezerProfile.createdDatetime{
            return Date(dateString: dateStr).asShortDateString()
            
        }
        else{
            return Date().asShortDateString()
        }
    }
    var modifiedDateTime : String{
        if let dateStr = self.freezerProfile.modifiedDatetime{
            return Date(dateString: dateStr).asShortDateString()
            
        }
        else{
            return Date().asShortDateString()
        }
    }
    
    var freezerDepth : Float{
        if let depth = self.freezerProfile.freezerDepth{
            return Float(depth) ?? 0.00
        }
        else{
            return 0.00
        }
    }
    
    var freezerLength : Float{
        if let depth = self.freezerProfile.freezerLength{
            return Float(depth) ?? 0.00
        }
        else{
            return 0.00
        }
    }
    
    var freezerWidth : Float{
        if let depth = self.freezerProfile.freezerLength{
            return Float(depth) ?? 0.00
        }
        else{
            return 0.00
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading,spacing: 10){
                freezer_title_header
                //quick actions
                freezer_quick_actions
                
                //specs and location
                freezer_profile_spec_location
                
                //other freezer stats
                other_freezer_profile_stats
               
                //other info
                other_info
                
                Spacer()
            }.padding()
                .alert(isPresented:$showDeleteFreezerConfirm) {
                          Alert(
                            title: Text("Are you sure you want to delete \(self.freezerProfile.freezerLabel)?"),
                              message: Text("There is no undo"),
                              primaryButton: .destructive(Text("Delete")) {
                                  print("Deleting action...")
                                  
                                  //delete (remove) Freezer
                                  //after testing that it works I need to add alert to ensure user wants to
                                  if let id = freezerProfile.id{
                                      freezerDelete_vm.deleteFreezer(_freezerId: "\(id)"){response in
                                          
                                          if !response.isError{
                                              //go back to the previous screen
                                              dismiss()
                                          }
                                      }
                                  }
                                
                              },
                              secondaryButton: .cancel()
                          )
                      }
                .toast(isPresenting: $freezerDelete_vm.showResponseMsg){
                    if self.freezerDelete_vm.isErrorMsg{
                        return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.freezerDelete_vm.responseMsg )")
                    }
                    else{
                        return AlertToast(type: .regular, title: "Response", subTitle: "\(self.freezerDelete_vm.responseMsg )")
                    }
                }
        }
    }
}

extension FreezerProfileInfoView{
    
    private var freezer_title_header : some View{
        VStack(alignment: .leading){
            Text("\(freezerProfile.freezerLabel)")
                .font(.title)
                .foregroundColor(Color.primary)
                .bold()
                .minimumScaleFactor(0.6)
            
        }
        
        
    }
    
    private var freezer_quick_actions : some View{
        VStack(alignment: .leading){
            Text("Quick Actions")
                .font(.title2)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
                .minimumScaleFactor(0.6)
            
            LazyVGrid(columns: twoColumn, alignment: .leading) {
                
                Button {
                    //update Freezer
                } label: {
                    HStack{
                        Image(systemName: "pencil")
                        Text("Freezer")
                    }.roundedRectangleButton()
                }

                Button {
                    withAnimation {
                        self.showDeleteFreezerConfirm.toggle()
                    }
                    
                    
                } label: {
                    //MARK: should disable if the user doesnt have the rights to delete the data
                    HStack{
                        Image(systemName: "trash")
                        Text("Freezer")
                    }.roundedRectangleButton()
                }
                
            }
            
        }
        
        
    }
    
    private var freezer_profile_spec_location : some View{
        VStack(alignment: .leading){
            Text("Specifications and Location")
                .font(.title3)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
                .minimumScaleFactor(0.6)
            
            LazyVGrid(columns: twoColumn, alignment: .leading) {
                //location
                VStack(alignment: .leading) {
                    Text("Location")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerRoomName ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                //temperature rating
                VStack(alignment: .leading) {
                    Text("Temperature Rating")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerRatedTemp ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                //temperature units
                VStack(alignment: .leading) {
                    Text("Temperature Units")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerRatedTempUnits ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                VStack(alignment: .leading) {
                    Text("Total Capacity")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(freezerTotalCapacity)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
            }
            
        }
        
    }
    
    private var other_freezer_profile_stats : some View{
        VStack(alignment: .leading){
            Text("Dimensions")
                .font(.title3)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
                .minimumScaleFactor(0.6)
            
            LazyVGrid(columns: twoColumn, alignment: .leading) {
                //rows
                VStack(alignment: .leading) {
                    Text("Rows")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerCapacityRows ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                //columns
          
                VStack(alignment: .leading) {
                    Text("Columns")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerCapacityColumns ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                //depth
                VStack(alignment: .leading) {
                    Text("Depth")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(freezerDepth,specifier: "%0.2f")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                //capacity depth
                VStack(alignment: .leading) {
                    Text("Capacity Depth")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerCapacityDepth ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                
                //units
                VStack(alignment: .leading) {
                    Text("Units")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.freezerDimensionUnits ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                //length
                VStack(alignment: .leading) {
                    Text("Length")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(freezerLength ,specifier: "%0.2f")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                //Width
                VStack(alignment: .leading) {
                    Text("Width")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(freezerWidth,specifier: "%0.2f")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                
            }
        }
    }
    
    private var other_info : some View{
        VStack(alignment: .leading){
            Text("Other Information")
                .font(.title3)
                .foregroundColor(Color.theme.secondaryText)
                .bold()
                .minimumScaleFactor(0.6)
            
            LazyVGrid(columns: twoColumn, alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Author")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(self.freezerProfile.createdBy ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                VStack(alignment: .leading) {
                    Text("Created on")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(createdDateTime)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
                VStack(alignment: .leading) {
                    Text("Modified on")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .minimumScaleFactor(0.6)
                        
                    Text("\(modifiedDateTime)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                        .bold()
                        .minimumScaleFactor(0.6)
                }
                
            }
            
            
        }
        
    }
    
}

struct FreezerProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerProfileInfoView(freezerProfile: .constant(dev.freezerProfile))
    }
}
