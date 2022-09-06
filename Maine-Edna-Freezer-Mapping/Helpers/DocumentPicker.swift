//
//  DocumentPicker.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import Foundation
import SwiftUI


//Document picker section (Call UIKIT controller in SwiftUI)

struct DocumentPicker : UIViewControllerRepresentable{
    
    @Binding var fileContent : String
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller : UIDocumentPickerViewController
        if #available(iOS 14, *){
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: true)
        }
        else{
            controller = UIDocumentPickerViewController(documentTypes: [String()], in: .open)
        }
        
        /*
         let picker = UIDocumentPickerViewController(documentTypes: [], in: .open)
         picker.allowsMultipleSelection = false
         
         
         return picker
         */
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}


class DocumentPickerCoordinator : NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate{
    
    @Binding var fileContent : String
    
    init(fileContent : Binding<String>){
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller : UIDocumentPickerViewController, didPickDocumentsAt urls : [URL]){
        let fileURL = urls[0]
        
        do{
            fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch let error{
            print(error.localizedDescription)
        }
        
    }
    
}
