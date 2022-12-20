//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 19/12/22.
//

import Contacts
import MapKit

extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}

extension CLPlacemark {
    var mailingAddress: String? {
        postalAddress?.mailingAddress
    }
}

extension CNPostalAddress {
    var mailingAddress: String {
        Formatter.mailingAddress.string(from: self)
    }
}
