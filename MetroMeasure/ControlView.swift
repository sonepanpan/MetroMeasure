//
//  ControlView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI

struct ControlView: View {
    
    @EnvironmentObject var parameters: AppParameters
    
    var body: some View {
        HStack{
            Text(String(format: "%.1fcm", parameters.measuredHeight*100))
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding(20)
            Divider()
            Button( parameters.measuredHeight == 0 ? "CastDot" : "Reset", action: {castDot()})
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue))
                .frame(minWidth: 150)
        }.background(RoundedRectangle(cornerRadius: 25.0).foregroundColor(.white))
    }
    func castDot(){
        if let result = arViewContainer.arView.castRay(){
            parameters.measuredHeight = result
            // iPad???
            haptic()
        }
    }
    func haptic(){
        let generator =  UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
