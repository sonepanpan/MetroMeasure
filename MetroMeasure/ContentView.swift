//
//  ContentView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    
    @EnvironmentObject var parameters: AppParameters
    @State var isFinished: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: "house")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: .center)
                    .padding()
                
                NavigationLink(
                    destination: MeasureView(),
                    label: {
                        Text("Measure")
                            .frame(width: 150, height: 90, alignment: .center)
                            .background(Color.blue).foregroundColor(.white)
                            .cornerRadius(8)
                    }).padding()
                NavigationLink(
                    destination: ListView(),
                    label: {
                        Text("History")
                            .frame(width: 150, height: 90, alignment: .center)
                            .background(Color.blue).foregroundColor(.white)
                            .cornerRadius(8)
                    }).padding()
                
            }.navigationBarBackButtonHidden(true)
        }
        
    }
}
