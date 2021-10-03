//
//  HeatMapHelper.swift
//  HeatMap
//
//  Created by Nicky on 24/09/21.
//

import Foundation
import UIKit
import ReachabilitySwift

class HeatMapHelper{
    
    let reachability = Reachability()!
    var isInternetConnected = false
    
    
    class var shared : HeatMapHelper {
        struct Static {
            static let instance = HeatMapHelper()
        }
        
        return Static.instance
    }
    
    func loadJson(fromURLString urlString: String,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    func OverlayAlphaDown(dataCount: Int, index: Int) -> UIColor{
        let alphaCalculatedValue = Double(0.75/Double(dataCount))
        let alphaValue = Double(index) * alphaCalculatedValue
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: CGFloat(alphaValue))
    }
    
    // MARK: - Network Monitoring
    func startMonitoringNetworkStatus() {
        
        reachability.whenReachable = { reachability in
            if reachability.isReachableViaWiFi {
                // //print("Reachable via WiFi")
                self.isInternetConnected = true
            } else {
                // //print("Reachable via Cellular")
                self.isInternetConnected = true
            }
        }
        reachability.whenUnreachable = { _ in
            // //print("Not reachable")
            self.isInternetConnected = false
        }
        
        do {
            try reachability.startNotifier()
            
        } catch {
            // //print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        if let reachability = note.object as? Reachability{
            
            if reachability.isReachable {
                if reachability.isReachableViaWiFi {
                    // //print("Reachable via WiFi")
                    self.isInternetConnected = true
                } else {
                    // //print("Reachable via Cellular")
                    self.isInternetConnected = true
                }
            } else {
                // //print("Network not reachable")
                self.isInternetConnected = false
            }
        }
        else{
            
        }
    }
    
//    class Connectivity {
//        class var isConnectedToInternet:Bool {
//            return NetworkReachabilityManager()!.isReachable
//        }
//    }

}



extension UIColor {
    func mix(with color: UIColor, amount: CGFloat) -> UIColor {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0

        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0

        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return UIColor(
            red: red1 * (1.0 - amount) + red2 * amount,
            green: green1 * (1.0 - amount) + green2 * amount,
            blue: blue1 * (1.0 - amount) + blue2 * amount,
            alpha: alpha1
        )
    }
}
