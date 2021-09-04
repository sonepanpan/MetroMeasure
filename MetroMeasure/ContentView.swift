//
//  ContentView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @State var isFinished: Bool = false
    
    var body: some View {
        ZStack(alignment: .center){
            arViewContainer.ignoresSafeArea()
            Image(systemName: "plus").foregroundColor(.white)
            if isFinished{
                ResultView(isFinished: $isFinished)}
            else{
                ControlView(isFinished: $isFinished)
            }
        }
    }
}
