//
//  CPRStartView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/3/25.
//

import SwiftUI

struct CPRStartView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    @State private var isPushingToNext = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .red)
                
                // Title
                VStack {
                    HStack {
                        Text("Start CPR")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Call 911
                    HStack {
                        VStack {
                            HStack {
                                Image(systemName: "1.circle")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.red)
                                
                                Text("CALL 911")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 1)
                            
                            HStack {
                                Text("Call for help if you have not already.")
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        
                        Button {
                            print("tapped call")
                        } label: {
                            Label("Call", systemImage: "phone.fill")
                                .fontWeight(.medium)
                        }
                        .tint(.red)
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.black.opacity(0.3))
                    )
                    
                    
                    // Get an AED
                    VStack {
                        HStack {
                            Image(systemName: "2.circle")
                                .font(.system(size: 24))
                                .foregroundStyle(.red)
                            
                            Text("FIND AN AED")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding([.horizontal, .top])
                        .padding(.bottom, 1)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("If you see someone nearby, ask them to find one for you.")
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                                
                                Text("If you cannot find one, or are alone, continue on. Do not leave the victim.")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.bottom)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.black.opacity(0.3))
                    )
                    
                    // Ask for help
                    VStack {
                        HStack {
                            Image(systemName: "3.circle")
                                .font(.system(size: 24))
                                .foregroundStyle(.red)
                            
                            Text("ASK FOR HELP")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding([.horizontal, .top])
                        .padding(.bottom, 1)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("CPR can be tiring. If there are others near you, ask them to help you. Switch off every 2 sets.")
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                            .padding(.bottom)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.black.opacity(0.3))
                    )
                    
                    Spacer()
                    
                    // Start button
                    Button {
                        isPushingToNext = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.white)
                                .frame(height: 60)
                                .padding(.horizontal)
                            
                            Text("Start")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Text("This application cannot be used to replace proper CPR training.")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 1)
                }
                .padding()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(.black.opacity(0.5))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $isPushingToNext) {
                LiveCPRView(isPresented: $isPresented)
            }
        }
    }
}

#Preview {
    CPRStartView(isPresented: .constant(true))
}
