//
//  ContentView.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    
    @ObservedObject var monitor = NetworkMonitor()
    @EnvironmentObject var parameters: AppParameters
    @State var isFinished: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding()
                Text(monitor.isConnected ? "Network Connected!" : "Please connect Network first").onAppear(perform: {
                    UIApplication.shared.isIdleTimerDisabled = true
                })

                
                
                NavigationLink(
                    destination: addNewPaperView(),
                    label: {
                        Text("Measure")
                            .frame(width: 150, height: 90, alignment: .center).font(.title3)
                            .background(monitor.isConnected ? Color.blue : Color.gray).foregroundColor(.white)
                            .cornerRadius(8)
                    }).padding().disabled(!monitor.isConnected)
                    

                NavigationLink(
                    destination: SearchHistoryView(),
                    label: {
                        Text("Search")
                            .frame(width: 150, height: 90, alignment: .center).font(.title3)
                            .background(monitor.isConnected ? Color.blue : Color.gray).foregroundColor(.white)
                            .cornerRadius(8)
                    }).padding().disabled(!monitor.isConnected)
                
//                NavigationLink(
//                    destination: PlaneDetection(),
//                    label: {
//                        Text("Test")
//                            .frame(width: 150, height: 90, alignment: .center).font(.title3)
//                            .background(monitor.isConnected ? Color.blue : Color.gray).foregroundColor(.white)
//                            .cornerRadius(8)
//                    }).padding().disabled(!monitor.isConnected)

                
//                NavigationLink(
//                    destination: ListView(),
//                    label: {
//                        Text("History")
//                            .frame(width: 150, height: 90, alignment: .center).font(.title3)
//                            .background(Color.blue).foregroundColor(.white)
//                            .cornerRadius(8)
//                    }).padding()
//
            }
//            ÷.navigationBarBackButtonHidden(true)
                .navigationBarTitle("Home")
//                .navigationBarHidden(true)
        }
        
    }
}
