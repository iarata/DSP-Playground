//
//  Home.swift
//  DSP Playground
//
//  Created by Alireza Hajebrahimi on 2021/07/17.
//

import SwiftUI

struct Home: View {
    
    @State private var rectPosition = CGPoint(x: 148, y: 43)
    @GestureState private var isDragging = false
    @State private var showDetails = false
    
    @State private var clickLocatin = NSPoint(x: 0, y: 0)
    
    @State var objects = [DSPObject]()
    @State private var connections = [InitialConnection]()
    @State private var showingSheet = false
    @State private var showDeleteAlert = false
    
    @State var pub = DSPNotification().publisher()
    
    @State var showInspector = false
    @State var selectedElement = DSPObject(id: UUID(), type: .audioFile, title: "", currentPosition: CGPoint(x:0, y:0), path: "")
    
    @State var mousePosition = CGPoint(x: 0, y: 0)
    @State var mouseClicked = false
    
    @ObservedObject var connectioManager = ConnectionManager()
    @ObservedObject var objectMTG = ObjectManager()
    
    var body: some View {
        
        GeometryReader { geometry in
            HSplitView {
                ZStack {
                    ForEach(objects) {
                        if $0.type == .audioFile {
                            AudioFileOV(objectManager: objectMTG, dspObject: $0, position: rectPosition, mousePosition: mousePosition, connectionMG: connectioManager).tag($0.id)
                                .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, geometry: geometry, showInspector: $showInspector, selected: $selectedElement, dspObject: $0, objectMTG: objectMTG))
                                
                            
                        } else if $0.type == .filter {
                            FilterOV(dspObject: $0, position: rectPosition, connectionMG: connectioManager).tag($0.id)
                                .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, geometry: geometry, showInspector: $showInspector, selected: $selectedElement, dspObject: $0, objectMTG: objectMTG))
                        } else {
                            OutputDeviceOV(dspObject: $0, position: rectPosition).tag($0.id)
                                .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, geometry: geometry, showInspector: $showInspector, selected: $selectedElement, dspObject: $0, objectMTG: objectMTG))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Divider()
                        HStack {
                            Circle().frame(width: 8, height: 8).foregroundColor(Color.green)
                            Text("Ready")
                            Spacer()
                            if selectedElement.title != "" && showInspector {
                                Text("\(selectedElement.id)").font(.footnote)
                            }
                        }.padding([.horizontal, .bottom], 6)
                    }
                    if objects.isEmpty {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                (Text("Start by clicking on ") + Text(Image(systemName: "plus")) + Text(" and adding an object."))
                                    .foregroundColor(.gray.opacity(0.6))
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    
                    
                }
                .onTapGesture {
                    withAnimation {
//                        mousePosition = didPressBarItem()
                        selectedElement = DSPObject(id: UUID(), type: .audioFile, title: "", currentPosition: CGPoint(x:0, y:0), path: "")
                        showInspector = false
//                        mouseClicked.toggle()
                    }
                }
                if showInspector {
                    Inspector(objects: $objects, selected: $selectedElement, displayInspect: $showInspector).frame(maxWidth: 250, maxHeight: .infinity)

                }
            }
            
        }
        .coordinateSpace(name: "HomeView")
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Spacer()
                Button(action: {
                    withAnimation {
                        showingSheet.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                })
                .help(Text("Add Node"))
                .keyboardShortcut("e", modifiers: .command)
                
                Button(action: {
                    withAnimation {
                        showDeleteAlert.toggle()
                    }
                }, label: {
                    Image(systemName: "trash").foregroundColor(.red).opacity(objects.isEmpty ? 0.4 : 1)
                }).disabled(objects.isEmpty)
                .help(Text("Delete All"))
                .keyboardShortcut("d", modifiers: .command)
                
                Button {
                    print("Help")
                } label: {
                    Label("Help", systemImage: "questionmark.circle")
                }
                .help(Text("Help"))
                
            }
            
        }
        .navigationSubtitle(Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""))
        .sheet(isPresented: $showingSheet) {
            Objects(showSheet: $showingSheet)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Confirmation"), message: Text("Are you sure that you want to delete all the objects?"), primaryButton: .default(Text("Delete"), action: {
                objectMTG.deleteAll()
                self.showInspector = false
            }), secondaryButton: .cancel())
        }
        .onAppear {
            self.objects = objectMTG.getObjects()
        }
        
        .onReceive(pub) { (output) in
            withAnimation {
                self.objects = objectMTG.getObjects()
            }
        }
        
        
    }
}
