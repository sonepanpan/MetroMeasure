//
//  APIFunctions.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/10/9.
//
//
import Foundation
import SwiftUI

class MetroDataController {
    func PutMetroData(paper: Paper, carrige: Carriage, device: Device) {
        /* Configure session, choose between:
           * defaultSessionConfiguration
           * ephemeralSessionConfiguration
           * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
           PutMetroData (PUT http://140.114.53.174:8443/Thingworx/Things/TyMetro_thing/Services/PutMetroData)
         */

        guard var URL = URL(string: "http://140.114.53.174:8443/Thingworx/Things/TyMetro_thing/Services/PutMetroData") else {return}
        let URLParams = [
            "GroupNum": paper.groupNum,
            "PaperNum": paper.paperNum,
            "startDate": DateFormatter.displayDate.string(from: paper.startDate),
            "OperatorName": paper.operatorName,
            "CarriageNum": carrige.carriageNum,
            "DeviceNum": carrige.deviceNum,
            "ThicknessIsQualified": device.thicknessIsQualified ? "1" : "0",
            "ChangeNum": String(device.changeNum),
            "HeightBefore": String(format: "%.2f", device.heightBefore),
            "HeightAfter": String(format: "%.2f", device.heightAfter),
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "PUT"

        // Headers

        request.addValue("Basic aWVTdHVkZW50OmllU3R1ZGVudDJ3c3ghUUFa", forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        // JSON Body
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: URLParams, options: [])
    
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                 
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}


extension DateFormatter {
    static let displayDate: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "YYYY/MM/dd"
         return formatter
    }()
}
