//
//  SettingsView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var defaultWatchMode = false
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color(uiColor: .systemGroupedBackground))
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Form {
                    Section {
                        Toggle("Watch Mode", isOn: $defaultWatchMode)
                    } header: {
                        Text("CPR Defaults")
                    } footer: {
                        Text("Watch Mode will enable connection to the Apple Watch for live CPR feedback.")
                    }
                    
                    Section("Reset") {
                        Button("Reset Statistics") {
                            print("reset")
                        }
                    }
                    
                    Section("About") {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Image("Rounded Logo")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .padding(.trailing)
                                
                                
                                VStack(alignment: .leading) {
                                    Spacer()
                                    
                                    Text("PulseGuide")
                                        .font(.system(size: 24, weight: .bold))
                                    
                                    Text("Version 1.0")
                                    
                                    Spacer()
                                    Spacer()
                                }
                            }
                            .padding(.bottom)
                            
                            Text("Developed by")
                                .bold()
                            
                            Text("Mukundan Kasturirangan")
                            Text("Faith Maue")
                            Text("John Pope")
                            Text("Cole Swanson")
                        }
                        .padding(.vertical)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("You cannot do a kindness too soon, for you never know how soon it will be too late.")
                            .font(.system(size: 14, weight: .medium))
                        
                        Text("- Ralph Waldo Emerson")
                            .font(.system(size: 12, weight: .light))
                    }
                    .foregroundStyle(.gray)
                    .listRowBackground(Color.clear)
                }
                
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
