//
//  HomeView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 14))
                            .foregroundStyle(.red)
                        
                        Text("DAILY INSPIRATION")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(uiColor: .darkGray))
                        
                        Spacer()
                    }
                    .padding(.bottom, 1)
                    
                    Text(Quotes.getRandomQuote())
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                )
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
