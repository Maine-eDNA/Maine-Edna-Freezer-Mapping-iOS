//
//  CustomHalfSheetView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/20/22.
//


import SwiftUI


extension View{
    
    func customHalfSheet<SheetView : View>(showHalfSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView) -> some View{
        
        return self
            .background(
                CustomHalfSheetHelper(showCustomSheet: showHalfSheet, sheetView: sheetView())
            )
    }
    
}


//UIKIT SwiftUI Integration
struct CustomHalfSheetHelper<SheetView: View>: UIViewControllerRepresentable{
    
    @Binding var showCustomSheet : Bool
    var sheetView : SheetView
    
    let sheetController = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        sheetController.view.backgroundColor = .clear
        return sheetController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        
        if showCustomSheet{
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true){
                
                //main or UI Thread
                DispatchQueue.main.async {
                    self.showCustomSheet.toggle()
                }
            }
        }
    }
    
}


//UIHostingController for the CustomHalfSheet
class CustomHostingController<Content: View> : UIHostingController<Content>{
    
    override func viewDidLoad() {
        //presentation controller properties
        
        if let presentationController = presentationController as? UISheetPresentationController{
            
            presentationController.detents = [ .medium(), .large()]
            
            //the sheet grab handle
            presentationController.prefersGrabberVisible = true
            
            presentationController.preferredCornerRadius = 30
            
            
        }
        
    }
    
}

