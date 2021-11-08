//
//  APIFunctions.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/10/9.
//
//
import Foundation

class MetroDataController {
    func GetMetroData(groupNum: String, carriageNum: String, deviceNum: String, completion: @escaping (Histories) -> Void) {
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
           GetMetroData (POST http://140.114.53.174:8443/Thingworx/Things/TyMetro_thing/Services/GetMetroData)
         */

        guard var URL = URL(string: "http://140.114.53.174:8443/Thingworx/Things/TyMetro_thing/Services/GetMetroData") else {return}
        let URLParams = [
            "GroupNum": groupNum,
            "CarriageNum": carriageNum,
            "DeviceNum": deviceNum,
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"

        // Headers

        request.addValue("Basic aWVTdHVkZW50OmllU3R1ZGVudDJ3c3ghUUFa", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("3c2e981a-0359-4800-94b3-a86bccfb0e85", forHTTPHeaderField: "appKey")

        // JSON Body

        request.httpBody = try! JSONSerialization.data(withJSONObject: URLParams, options: [])

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                guard let jsonData = data else {return}
                
                do {
                    //response content
                    print("test POST")
                    
//                    guard let data = data else {return}
//                    guard let rawData = String(data: data, encoding: .utf8) else {return}
//                    print("rawData:\n\(rawData)")

                    let Data = try JSONDecoder().decode(Histories.self, from: jsonData)
                    completion(Data)
                }
                catch{
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
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


extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)

    }

}
