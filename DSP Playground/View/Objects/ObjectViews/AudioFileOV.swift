//
//  AudioFileOV.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct AudioFileOV: View {
    
    @State var filename = ""
    @State var showFileChooser = false
    @ObservedObject var objectManager = ObjectManager()
    
    @State var dspObject: DSPObject
    @State var isEditing = false
    @State var newItemName = ""
    @State var position: CGPoint
    @State var showDetails = false
    
    @State private var isHoveringMain = false
    @State private var isHoveringCircle = false
    
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
                
                .onHover(perform: { isHover in
                    withAnimation {
                        self.isHoveringMain = isHover
                    }
                })
                .padding(10)
                .cornerRadius(12)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color("AudioFile").opacity(0.2)))
                .onTapGesture {
                    self.filename = objectManager.selectFile()
                    self.objectManager.updateName(of: dspObject.id, to: self.filename, position: position)
                }
//                .contextMenu {
//                    Button {
//                        self.showDetails.toggle()
//                    } label: {
//                        HStack {
//                            Image(systemName: "info.circle")
//                            Text("Get Info")
//                        }
//                    }
//
//                    Button {
//                        self.isEditing.toggle()
//                    } label: {
//                        HStack {
//                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
//                            Text("Rename")
//                        }
//                    }
//                    Divider()
//                    Button {
//                        objectManager.deleteObject(of: dspObject.id)
//                    } label: {
//                        HStack {
//                            Image(systemName: "trash")
//                            Text("Delete")
//                        }.foregroundColor(.red)
//                    }
//                }
//                .sheet(isPresented: $showDetails) {
//                    VStack {
//                        List {
//                            HStack {
//                                Text("UUID:")
//                                Spacer()
//                                Text("\(dspObject.id)")
//                            }.background(Color.white).cornerRadius(12)
//                            HStack {
//                                Text("Type:")
//                                Spacer()
//                                Text("\(dspObject.type.rawValue)")
//                            }
//                        }
//                        Button("Close") {
//                            showDetails.toggle()
//                        }
//                    }.frame(width: 300, height: 150)
//                }

                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(isHoveringCircle || connectionMG.connecting ? Color.white : Color.white.opacity(0.5))
                    .onHover(perform: { isHovering in
                        withAnimation {
                            self.isHoveringCircle = isHovering
                        }
                    })
                    .shadow(radius: 5)
                    .offset(y: 25)
                    .onTapGesture {
                        connectionMG.connecting = true
                        connectionMG.initStart(start: dspObject.id)
                    }

                
                
        }
        
        
    }
}
