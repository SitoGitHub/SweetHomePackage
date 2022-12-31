//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 19/12/22.
//

import Contacts
import MapKit

// MARK: - extension Formatter
extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}
// MARK: - extension CLPlacemark
extension CLPlacemark {
    var mailingAddress: String? {
        postalAddress?.mailingAddress
    }
}
// MARK: - extension CNPostalAddress
extension CNPostalAddress {
    var mailingAddress: String {
        Formatter.mailingAddress.string(from: self)
    }
}
