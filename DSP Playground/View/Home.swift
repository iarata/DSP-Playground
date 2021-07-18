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
    
    @State private var objects = [DSPObject]()
    @State private var showingSheet = false
    @State private var showDeleteAlert = false
    
    @State var pub = DSPNotification().publisher()
    @State var objNewName = ""
    @State var isEditing = false
    
    
    
    @State var connections = ["status": ["move": CGPoint(x: 0, y: 0)]]
    @State var mousePosition = CGPoint(x: 0, y: 0)
    @State var mouseClicked = false
    
    @ObservedObject var connectioManager = ConnectionManager()

    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                ForEach(objects) {
                    if $0.type == .audioFile {
                        
                        AudioFileOV(dspObject: $0, position: rectPosition, mousePosition: mousePosition, connectionMG: connectioManager).tag($0.id)
                            .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, clickLocatin: clickLocatin, geometry: geometry, objDetails: $0, objectNewName: $objNewName, showDetails: $showDetails, isEditing: $isEditing, dspObject: $0))
                        
                    } else if $0.type == .filter {
                        FilterOV(dspObject: $0, isEditing: $isEditing, newItemName: $objNewName, position: rectPosition, connectionMG: connectioManager)
                            .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, clickLocatin: clickLocatin, geometry: geometry, objDetails: $0, objectNewName: $objNewName, showDetails: $showDetails, isEditing: $isEditing, dspObject: $0))
                    } else {
                        OutputDeviceOV(dspObject: $0, isEditing: $isEditing, newItemName: $objNewName, position: rectPosition).tag($0.id)
                            .modifier(ObjectOVModifier(rectPosition: rectPosition, isDragging: isDragging, clickLocatin: clickLocatin, geometry: geometry, objDetails: $0, objectNewName: $objNewName, showDetails: $showDetails, isEditing: $isEditing, dspObject: $0))
                    }
                }
                
//                ForEach
                
                VStack(alignment: .leading) {
                    Spacer()
                    Divider()
                    Text("Ready").padding()
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
                .help(Text("Add Object"))
                
                Button(action: {
                    withAnimation {
                        showDeleteAlert.toggle()
                    }
                }, label: {
                    Image(systemName: "trash").foregroundColor(.red).opacity(objects.isEmpty ? 0.4 : 1)
                }).disabled(objects.isEmpty)
                .help(Text("Delete All"))
                
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
                ObjectManager().deleteAll()
            }), secondaryButton: .cancel())
        }
        .onAppear {
            self.objects = ObjectManager().getObjects()
        }
        .onTapGesture {
            mousePosition = didPressBarItem()
            mouseClicked.toggle()
        }
        .onReceive(pub) { (output) in
            withAnimation {
                objects = ObjectManager().getObjects()
            }
        }
        
    }
}
