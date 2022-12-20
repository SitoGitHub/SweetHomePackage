//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 19/12/22.
//

import MapKit

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
