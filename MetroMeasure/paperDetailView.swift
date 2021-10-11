////
////  paperDetailView.swift
////  MetroMeasure
////
////  Created by 潘婷蓁 on 2021/9/14.
////
//
//import SwiftUI
//
//struct paperDetailView: View {
//    var paper: Paper
//
//    var body: some View {
//            List{
//            Label(
//                title: {Text("工單號碼: \(paper.paperNum)")},
//                icon: { Image(systemName: "newspaper")}
//            ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//            Label(
//                title: {Text("車組號碼: \(paper.groupNum)")},
//                icon: { Image(systemName: "tram")}
//            ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//            Label(
//                title: {Text("開工日期: \(DateFormatter.displayDate.string(from: paper.startDate))")},
//                icon: { Image(systemName: "play.fill")}
//            ).cornerRadius(3.0).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//            Label(
//                title: {Text("執行人員: \(paper.operatorName)")},
//                icon: { Image(systemName: "person.fill")}
//            ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//
////            if paper.Carriages != nil{
//                ForEach(paper.Carriages!, id: \.id){ Carriage in
//                    NavigationLink(
//                        destination: carriageDetailView(Carriage: Carriage),
//                        label: {
//                                Label(
//                                title: {Text("車廂編號: \(Carriage.carriageNum)")},
//                                icon: { Image(systemName: "rectangle")}
//                            ).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).frame(width: 250, height: 50, alignment: .leading).foregroundColor(Color.black)
//                        })
//                }
//            }
//            else{
//                Text("No Carrige Records")
//            }
//        }.navigationViewStyle(StackNavigationViewStyle()).navigationTitle("\(paper.paperNum)")
//    }
//}
//
//
//struct carriageDetailView: View{
//    var Carriage: Carriage
//
//    var body: some View{
//        NavigationView{
//            ScrollView(.horizontal,showsIndicators: true)
//            {
//                HStack/*(spacing:30)*/
//                {
//                    ForEach(Carriage.Devices!, id: \.id){ Device in
//                        DeviceRow(Device: Device)
//                    }
//                }
//            }.padding(20).position(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/5)
//        }.navigationTitle(Carriage.carriageNum).navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct DeviceRow: View{
//    var Device: Device
//    var body: some View{
//        List{
//            Label(
//                title: { Text(Device.deviceNum).bold() },
//                icon: { Image(systemName: "rectangle.roundedtop")}
//            )
//            Label(
//                title: {Text("    厚度: ") + Text(Device.thicknessIsQualified ? "OK" : "NG"+",Change  \(Device.changeNum!)")},
//                icon: {}
//            )
//            if Device.heightAfter == -1{
//                Label(
//                    title: {Text("    高度: \(Device.heightBefore)")},
//                    icon: {}
//                    )
//                }
//            else{
//                Label(
//                    title: {Text("    高度:")},
//                    icon: {}
//                )
//                Label(
//                    title: {Text("      調整前: \(Device.heightBefore)")},
//                    icon: {}
//                )
//                Label(
//                    title: {Text("      調整後: \(Device.heightBefore)")},
//                    icon: {}
//                )
//            }
//        }.cornerRadius(3.0).frame(width: 250, height: 400, alignment: .leading).foregroundColor(Color.black).navigationBarHidden(true).position(x: UIScreen.main.bounds.width/3 , y: UIScreen.main.bounds.height/2)
//    }
//}
//
//extension DateFormatter {
//    static let displayDate: DateFormatter = {
//         let formatter = DateFormatter()
//         formatter.dateFormat = "YYYY/MM/dd"
//         return formatter
//    }()
//}
