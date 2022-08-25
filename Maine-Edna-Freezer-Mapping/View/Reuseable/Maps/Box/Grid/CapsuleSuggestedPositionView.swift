//
//  CapsuleSuggestedPositionView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/1/22.
//

import SwiftUI

struct CapsuleSuggestedPositionView: View {
    //MARK: need to add the theme settings (add it to a file)
    @Binding var single_lvl_rack_color : String
    @Binding var sample_code : String
    @Binding var sample_type_code : String
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    @Binding var showMenu : Bool
    //show the details of this sample
    @Binding var showSampleDetail : Bool
    
    //MARK: Press and hold triggers a a multi context menu to select an action
    var body: some View {
        VStack{
            
            Button(action: {
                //open context menu
                print("Pressed")
                
                withAnimation {
                    showMenu.toggle()
                }
            }, label: {
                sample_capsule_section
            })
            .sheet(isPresented: $showMenu) {
              /*  if #available(iOS 16.0, *){
                 
                    list_of_actions_section
                    
                    //make the sheet take less space
                    .presentationDetents([.height(300)])
                }
                else {*/
                    // Fallback on earlier versions
                    list_of_actions_section
                //}
            }
             
            /*Text("tes")
                .contextMenu {
                      Button {
                          print("This is a clash need to resolve it")
                      } label: {
                          Label("Clash", systemImage: "globe")
                      }

                      Button {
                          print("Enable geolocation")
                      } label: {
                          Label("Info", systemImage: "location.circle")
                      }
                    Button {
                        print("Enable geolocation")
                    } label: {
                        Label("Suggest", systemImage: "location.circle")
                    }
                    
                    Button {
                        print("Enable geolocation")
                    } label: {
                        Label("Swap", systemImage: "location.circle")
                    }
                    
                  }*/
            
        }
  
    }
}


struct CapsuleSuggestedPositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        CapsuleSuggestedPositionView(single_lvl_rack_color: .constant("orange"), sample_code: .constant("0002"),sample_type_code: .constant("F"), showMenu: .constant(false), showSampleDetail: .constant(false))
    }
}

extension CapsuleSuggestedPositionView{
    
    private var list_of_actions_section : some View{
        List{
            Button {
                print("This is a clash need to resolve it")
                //MARK: perform the action
                
                //then close the modal
                
                withAnimation {
                    showMenu = false
                }
            } label: {
                //MARK: Make this HStack Reusable
                HStack{
                    Label("Clash", systemImage: "globe")
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Hint").font(.caption).foregroundColor(.secondary).bold()
                        Text("move \(sample_code) to a new position").font(.caption2).foregroundColor(.secondary)
                    }
                }
            }
            
            Button {
                print("Enable geolocation")
                //MARK: perform the action
                withAnimation {
                    self.showSampleDetail.toggle()
                }
                //then close the modal
                
                withAnimation {
                    showMenu = false
                }
            } label: {
                Label("Info", systemImage: "info.circle")
            }
            Button {
                print("Enable geolocation")
                //MARK: perform the action
                
                //then close the modal
                
                withAnimation {
                    showMenu = false
                }
            } label: {
                Label("Suggest", systemImage: "location.circle")
            }
            
            Button {
                print("Enable geolocation")
                //MARK: perform the action
                
                //then close the modal
                
                withAnimation {
                    showMenu = false
                }
            } label: {
                Label("Swap", systemImage: "location.circle")
            }
            
        }.listStyle(.inset)
    }
    
    private var sample_capsule_section : some View{
       
        Section{
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
            //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(Color(wordName: "yellow") ?? Color.orange))
                .frame(width: width, height: height)
            
            
            Circle()
            //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
            //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(Color(wordName: single_lvl_rack_color) ?? Color.orange))
            VStack{
                Text("\(sample_type_code.capitalized)").font(.caption2).foregroundColor(.white).bold()
                Text("\(sample_code)").font(.system(size: 9)).foregroundColor(.white).bold()
            }
        }
    }
    }
    
}


/*
 
 .contextMenu {
       Button {
           print("Change country setting")
       } label: {
           Label("Choose Country", systemImage: "globe")
       }

       Button {
           print("Enable geolocation")
       } label: {
           Label("Detect Location", systemImage: "location.circle")
       }
   }
 */



