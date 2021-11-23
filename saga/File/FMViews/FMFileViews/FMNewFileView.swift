//
//  FMNewFileView.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import SwiftUI

struct FMNewFileView: View {
    @EnvironmentObject var context: FMContext
    var node: FMNode
    @State var fileName: String = "new_image"
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            TextField("New File Name", value: $fileName, formatter: FileNameFormatter())
                .padding()
            Divider()
            HStack {
                SwiftUI.Button("Ok") {
//                    if let newImage = FM.shared.addFile(
//                        of: .png,
//                        to: node.url.appendingPathComponent("\(fileName).png"),
//                        node: node) {
//                    }
                    isPresented = false
                }
                Spacer()
                SwiftUI.Button("Cancel") {
                    isPresented = false
                }
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

class FileNameFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            let components = string.components(separatedBy: ".")
            if components.count > 0 {
                return components[0]
            } else {
                return string
            }
        }
        return nil
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject
        return true
    }
}
