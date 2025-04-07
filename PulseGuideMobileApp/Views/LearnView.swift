//
//  LearnView.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Button(action: {
                    if let url = URL(string: "https://cpr.heart.org/en/courses/heartsaver-first-aid-cpr-aed-course-options") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "graduationcap")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red)
                                
                                Text("SUGGESTED LEARNING")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(uiColor: .darkGray))
                                
                                Spacer()
                            }
                            .padding(.bottom, 1)
                            
                            Text("Get CPR Certified")
                                .font(.system(size: 20, weight: .bold))
                                .multilineTextAlignment(.leading)
                            
                            Text("Search the American Heart Association catalog for a class near you.")
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                    )
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Learn")
        }
    }
}

#Preview {
    LearnView()
}
