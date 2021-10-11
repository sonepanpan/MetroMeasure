////
////  ListView.swift
////  MetroMeasure
////
////  Created by 潘婷蓁 on 2021/9/8.
////
//
//import SwiftUI
//import UIKit
//
//
//struct ListView: View {
//
//    @EnvironmentObject var parameters: AppParameters
//    @State var refresh = false
//
//    var body: some View {
//        VStack(alignment: HorizontalAlignment.center, spacing: 5)
//        {
////            Section{
////                NavigationLink(destination: addNewPaperView(),
////                               label: {Text("Add to List").frame(width: 250, height: 50, alignment: .center).background(Color.green).cornerRadius(8).foregroundColor(.white)
////                               }
////                )}.padding()
//            if refresh{
//                List(parameters.papers, id: \.id){paper in
//                        NavigationLink(
//                            destination: paperDetailView(paper: paper),
//                            label: {
//                                PaperRow(title: paper.paperNum)
//                            })
//                    }
//                }
//            else{
//                List(parameters.papers, id: \.id){paper in
//                        NavigationLink(
//                            destination: paperDetailView(paper: paper),
//                            label: {
//                                PaperRow(title: paper.paperNum)
//                            })
//                    }
//            }
//        }.navigationTitle("List")
//        .navigationBarItems(trailing: Button(action: {refresh.toggle()}
//                                            ,label: {
//                                                Image(systemName: "arrow.triangle.2.circlepath").foregroundColor(Color.blue)
//                                            }))
//    }
//
//}
//
//
//struct PaperRow: View {
//    let title: String
//    var body: some View{
//        Label(
//            title: {Text(title)},
//            icon: { Image(systemName: "text.alignleft")}
//        ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//    }
//}
//
