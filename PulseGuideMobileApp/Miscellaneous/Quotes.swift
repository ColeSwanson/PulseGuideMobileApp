//
//  Quotes.swift
//  PulseGuideMobileApp
//
//  Created by Matt McDonnell on 4/6/25.
//

import Foundation

struct Quotes {
    public static let lifesaverQuotes = [
        "You’re the help until help arrives.",
        "One breath, one beat, one life saved.",
        "Heroes aren’t born—they respond.",
        "You know CPR. That makes you powerful.",
        "Your hands could be someone’s second chance.",
        "Keep calm. Start compressions.",
        "Being prepared is being powerful.",
        "Every second counts. You count too.",
        "Real heroes don’t wear capes—they press hard and fast.",
        "Today, you might save a life. Be ready.",
        "Courage is starting CPR even when you're scared.",
        "Confidence saves lives—trust your training.",
        "Do your best. It might be their only chance.",
        "Push with purpose. Breathe with hope.",
        "Your quick action could change everything.",
        "You might never know the life you save. Do it anyway.",
        "You are never too small to make a big difference.",
        "Stay strong, stay steady, stay lifesaving.",
        "Not all heroes are trained—just determined.",
        "Your hands hold the power to restart a heart."
    ]
    
    public static func getRandomQuote() -> String {
        return lifesaverQuotes.randomElement() ?? ""
    }

}
