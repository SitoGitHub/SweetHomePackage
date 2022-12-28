//
//  User.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import Foundation
import MapKit
// инфо для вывода пина на карту
public class MakerAnotation: NSObject, MKAnnotation{
    public var coordinate: CLLocationCoordinate2D
    public var nameMaker: String
    public var surnameMaker: String
    public var phoneNumberMaker: String
    public var emailMaker: String
    public var passwordMaker: String
    public var pathImageMaker: String?
    public var title: String?
    public var productCategoriesMaker: [ProductCategoryMaker]?
    
    init (surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, coordinate: CLLocationCoordinate2D, productCategoriesMaker: [ProductCategoryMaker]?){
        self.coordinate = coordinate
        self.nameMaker = nameMaker
        self.surnameMaker = surnameMaker
        self.phoneNumberMaker = phoneNumberMaker
        self.emailMaker = emailMaker
        self.passwordMaker = passwordMaker
        self.pathImageMaker = pathImageMaker
        self.title = surnameMaker + " " + nameMaker
        self.productCategoriesMaker = productCategoriesMaker
    }
}
