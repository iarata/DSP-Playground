//
//  AudioFileOV.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct AudioFileOV: View {
    
    @State var fileDetail = ""
    @State var objectManager: ObjectManager
    
    @State var pub = DSPNotification().publisher()
    
    @State var dspObject: DSPObject
    @State var position: CGPoint
//    @Binding var showInspector: Bool
    
    @State var mousePosition: CGPoint
    @State var connectionMG: ConnectionManager
    

    var body: some View {
            ZStack {
                HStack {
                    Image(systemName: dspObject.type.rawValue).foregroundColor(Color("AudioFileText")).font(.system(size: 20))
                    VStack(alignment: .leading) {
                        Text(dspObject.title ?? "Rename this").bold().foregroundColor(Color("AudioFileText"))
                        Text("\(dspObject.id)").font(.footnote).opacity(0.4)
                    }
                }
                
                .padding(10)
                .cornerRadius(12)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("AudioFileBg")))
                .contextMenu {

                    Button {

                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Get Info")
                        }
                    }

                    Button {

                    } label: {
                        HStack {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            Text("Rename")
                        }
                    }
                    Divider()
                    Button {
                        objectManager.deleteObject(of: dspObject.id)
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }.foregroundColor(.red)
                    }
                }
        }
            .onReceive(pub) { (output) in
                if let updateOBJ = objectManager.getObject(id: dspObject.id) {
                    dspObject = updateOBJ
                }
            }
            .onAppear {
                
            }
        
        
        
    }
    
    // MARK: NSPanel Opener
    func selectFile() -> String {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Select an audio file"
        panel.allowedFileTypes = ["mp3", "aac", "wav", "flac", "alac", "dsd"]
        if panel.runModal() == .OK {
            self.fileDetail = panel.url?.lastPathComponent ?? "none"
        }
        return panel.url?.lastPathComponent ?? "none"
    }
}
