//
//  HowToTutorialsView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/15/22.
//

import SwiftUI
import Kingfisher

struct HowToTutorialsView: View {
    @State var tutorialImage : String = "https://wwwcdn.cincopa.com/blogres/wp-content/uploads/2019/02/video-tutorial-image.jpg"
    @State var testBody : String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    var body: some View {
        Section{
            NavigationView{
                VStack(alignment: .leading){
                    List{
                        // Text("Show Tutorials here in this list when clicked will show view and text")
                        
                        HStack{
                            //MARK: Put a youtube video here
                            KFImage(URL(string: tutorialImage))
                                .onSuccess { r in
                                    // r: RetrieveImageResult
                                    print("success: \(r)")
                                }
                                .onFailure { e in
                                    // e: KingfisherError
                                    print("failure: \(e)")
                                }
                                .placeholder {
                                    // Placeholder while downloading.
                                    
                                    KFImage(URL(string: tutorialImage))
                                        .resizable()
                                        .clipped()
                                        .cornerRadius(15)
                                        .frame(width: 100, height: 100)
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                                }
                            
                            //make reusable view modifier
                                .resizable()
                                .clipped()
                                .cornerRadius(15)
                                .frame(width: 125, height: 125)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                            
                            
                            VStack(alignment: .leading, spacing: 2) {
                            
                                Text("Keijaoh Campbell")
                                    .font(.footnote)
                                    .foregroundColor(Color.theme.secondaryText)
                                    .bold()
                                
                                //Title
                                Text("Using the Built in Camera for Barcode Scanning")
                                    .foregroundColor(Color.primary)
                                    .bold()
                                    .font(.title3)
                                
                                Text("\(String(testBody.prefix(125)))..")
                                    .font(.body)
                                    .foregroundColor(Color.theme.secondaryText)
                                    .minimumScaleFactor(0.6)
                                   
                                
                                Spacer()
                                
                                HStack{
                                    //Tutorial Tag Section
                                    Text("camera scanner")
                                        .bold()
                                        .font(.caption)
                                        .padding()
                                        .textInputAutocapitalization(.words)
                                        .foregroundColor(Color.white)
                                        .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).background(Color.teal).cornerRadius(15).frame(maxHeight: 25) )
                                    
                                    
                                    
                                }
                            }
                        }
                        
                    }.listStyle(.plain)
                        .navigationTitle("How to Tutorials")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationViewStyle(.stack)
                }
            }
        }
    }
}

struct HowToTutorialsView_Previews: PreviewProvider {
    static var previews: some View {
        HowToTutorialsView()
            .navigationViewStyle(.stack)
    }
}
