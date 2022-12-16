//
//  User.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import Foundation
import MapKit


public enum Gender{
    case female
    case male
}


public class MakerAnotation: NSObject, MKAnnotation{
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    init (title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}

public class User: NSObject, MKAnnotation{
    public var coordinate: CLLocationCoordinate2D
    public var name: String
    public var city: String
    //public var image: UIImage
    public var gender: Gender
    public var title: String?{
        return name
    }
    public init (name: String, city: String,
                // image: UIImage,
                 gender: Gender, coordinate: CLLocationCoordinate2D){
        self.name = name
        self.city = city
        self.gender = gender
       // self.image = image
        self.coordinate = coordinate
    }
}
