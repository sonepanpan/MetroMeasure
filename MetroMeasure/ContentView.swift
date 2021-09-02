//
//  ContentView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var parameters: AppParameters
    var body: some View {
        VStack{
            ZStack(alignment: .center){
                arViewContainer
                Image(systemName: "plus").foregroundColor(.white)
            }.ignoresSafeArea()
            ZStack{
            ControlView()
            }.frame(height: 200, alignment: .center)
        }
    }
}
