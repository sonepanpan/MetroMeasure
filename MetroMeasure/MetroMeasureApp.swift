//
//  MetroMeasureApp.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI

@main
struct MetroMeasureApp: App {
    
    @StateObject var parameters = AppParameters()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(parameters)
        }
    }
}
