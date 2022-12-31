//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 19/12/22.
//

//import Foundation
import MapKit
// MARK: - LocationManagerProtocol
protocol LocationManagerProtocol: AnyObject {
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)
}
// MARK: - LocationManager
final class LocationManager {
    
}
// MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol{
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
