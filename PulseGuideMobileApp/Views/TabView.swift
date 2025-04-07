//
//  TabView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import SwiftUI

struct TabView: View {
    @State var selectedIndex = 0
    
    @State private var presented = false
    
    let icons = [
        "house",
        "bolt.heart.fill",
        "graduationcap"
    ]
    
    let fillIcons = [
        "house.fill",
        "bolt.heart.fill",
        "graduationcap.fill"
    ]
    
    let labels = [
        "Home",
        "Start CPR",
        "Learn"
    ]
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedIndex {
                    case 0:
                        NavigationView {
                            HomeView()
                        }
                    case 1:
                        NavigationView {
                            VStack {
                                Text("Start CPR!")
                            }
                            .navigationTitle("Start CPR")
                        }
                    case 2:
                        NavigationView {
                            LearnView()
                        }
                    default:
                        NavigationView {
                            VStack {
                                Text("hello!")
                            }
                            .navigationTitle("Default")
                        }
                }
            }
            
            //Divider()
            
            HStack {
                ForEach(0..<3, id: \.self) { number in
                    Spacer()
                    
                    VStack {
                        Button {
                            if number == 1 {
                                presented.toggle()
                            } else {
                                self.selectedIndex = number
                            }
                        } label: {
                            if number == 1 {
                                Image(systemName: icons[number])
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                    .frame(width: 60, height: 60)
                                    .background(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            } else {
                                Image(systemName: selectedIndex == number ? fillIcons[number] : icons[number])
                                    .font(.system(size: 25))
                                    .foregroundStyle(selectedIndex == number ? .red : Color(UIColor.lightGray))
                                    .frame(width: 40)
                            }
                        }
                        
                        if number == 1 {
                            Text(labels[number])
                                .font(.caption)
                                .foregroundStyle(.red)
                        } else {
                            Text(labels[number])
                                .font(.caption)
                                .foregroundStyle(selectedIndex == number ? .red : Color(UIColor.lightGray))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $presented, content: {
            CPRStartView(isPresented: $presented)
        })
        
        
    }
}

#Preview {
    TabView()
}
