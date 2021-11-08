//
//  thicknessView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/11/5.
//

import Foundation
import AVFoundation
import SwiftUI

struct thicknessView: View{
    @EnvironmentObject var parameters: AppParameters
//    @Binding var isThicknessFinished: Bool
    @Binding var check: MeasureView.item

    var body: some View{
        VStack(alignment: .center){
            Toggle("Thickness Qualified?", isOn: $parameters.measuredThickness).foregroundColor(.white).onChange(of: parameters.measuredThickness, perform: { value in
                if parameters.measuredThickness{
                    parameters.measuredChangeNum = 0
                }
                else{
                    parameters.measuredChangeNum = 1
                }
            }).frame(width: 250, height: 50, alignment: .center)
            HStack{
               
//                Button(action: {
//                    if parameters.measuredChangeNum > 1{
//                        parameters.measuredChangeNum -= 1
//                    }
//                })
//                {Image(systemName: "minus").foregroundColor(.white)
//                    .frame(width: 60, height: 60)
//                    .font(.title)
//                    .background(parameters.measuredThickness ? Color.gray : Color.red)
//                    .opacity(0.85)
//                    .cornerRadius(30)
//                    .padding(20)
//                }.disabled(parameters.measuredThickness)
            
                Text(String(format: " %d", parameters.measuredChangeNum))
                    .frame(width: 100, height: 50, alignment: .center)
                    .font(.largeTitle)
                    .foregroundColor(.white)
//                    .padding(20)
                
//                Button(action: {
//                    parameters.measuredChangeNum += 1
//                })
//                {Image(systemName: "plus").foregroundColor(.white)
//                    .frame(width: 60, height: 60)
//                    .font(.title)
//                    .background(parameters.measuredThickness ? Color.gray : Color.green)
//                    .opacity(0.85)
//                    .cornerRadius(30)
//                    .padding(20)
//                }.disabled(parameters.measuredThickness)
            }
            
            
            Button(action: {
                check = MeasureView.item.height
            })
            {Image(systemName: "arrow.right").foregroundColor(.white)
                .frame(width: 130, height: 50)
                .font(.title)
                .background(Color.blue)
                .opacity(0.85)
                .cornerRadius(10)
                .padding(18)
                
            }
        }.position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/10*7.5)
    }

    
}
