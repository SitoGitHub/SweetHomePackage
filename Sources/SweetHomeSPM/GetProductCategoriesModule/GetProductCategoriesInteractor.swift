//
//  GetProductCategoriesInteractor.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation

protocol GetProductCategoriesInteractorInputProtocol: AnyObject {
    func fetchCategoriesData(phoneMaker: String, emailMaker: String)
    func modifyCategoryProductMaker(check: Bool, index: Int, productCategory: ProductCategory, phoneMaker: String, emailMaker: String) -> Bool
}

class GetProductCategoriesInteractor: GetProductCategoriesInteractorInputProtocol {
    
    weak var presenter: GetProductCategoriesInteractorOutputProtocol?
    let coreDataManager = CoreDataManager.shared
    var maker = Maker()
    
    deinit{
        print("GetProductCategoriesInteractor deinit")
    }
    
    func fetchCategoriesData (phoneMaker: String, emailMaker: String) {
        //           dateService.getDate { [weak self] date in
        //               self?.presenter?.didLoadDate(date: date.description)
        //           }
        let productCategories = coreDataManager.getProductCategories(category: nil)
        switch productCategories {
        case.success(let productCategories):
            self.presenter?.fetchedProductCategoriesData(productCategories: productCategories, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }
        
        let makers = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneMaker, email: emailMaker)
        switch makers {
        case.success(let makers):
            for maker in makers{
              //  maker.addToMaker_product_categories(newCategoryProductMaker)
                self.maker = maker
            }
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
        }
        
        let productCategoriesMakers = coreDataManager.getProductCategoriesMakers(categoryName: nil, maker: maker)
        switch productCategoriesMakers {
        case.success(let productCategoriesMakers):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: productCategoriesMakers, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
        }
        
       
        
        //        self.users = modelUser.users
        //        self.presenter?.didLoadDate(users: users)
        
        //        for user in modelUser.users.first!{
        //            mapView.addAnnotation(user)
        //        }
        
    }
    
    
    func modifyCategoryProductMaker(check: Bool, index: Int, productCategory: ProductCategory, phoneMaker: String, emailMaker: String) -> Bool {
        var resultModifyCategory = false
        switch check {
        case true:
            let newCategoryProductMaker = ProductCategoryMaker()
            newCategoryProductMaker.category_name = productCategory.category_name
            //coreDataManager.saveContext()
            let makers = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneMaker, email: emailMaker)
        
           // coreDataManager.saveContext()
            switch makers {
            case.success(let makers):
                for maker in makers{
             //       coreDataManager.saveContext()
                    //coreDataManager.managedObjectContext.insert(maker)
                    maker.addToMaker_product_categories(newCategoryProductMaker)
                    coreDataManager.saveContext()
            //        self.maker = maker
                }
            case .failure(let error):
                self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
            }
//            
          //  let copy = Maker.MR User.MR_createEntityInContext(localContext)!
          //  let objectID = maker.objectID
          //  let copyMaker = coreDataManager.managedObjectContext.objectwi
          //  object(with: objectID) as? Maker
           // coreDataManager.managedObjectContext.insert(maker)
            //let copy = context2.objectWithID(objectID)
          //  coreDataManager.saveContext()
            
          //  maker.addToMaker_product_categories(newCategoryProductMaker)
        
//            let objectIDProductCategory = productCategory.objectID
//            let copyProductCategory = coreDataManager.managedObjectContext.object(with: objectIDProductCategory) as? ProductCategory
//
            productCategory.addToProduct_categorie_maker(newCategoryProductMaker)
            resultModifyCategory = true
            coreDataManager.saveContext()
            
        case false:
            let result = coreDataManager.deleteProductCategoriesMakers(categoryName: productCategory.category_name, maker: maker, productCategory: productCategory)
            switch result {
            case.success(let result):
                resultModifyCategory = result
            case .failure(let error):
                self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
            }
            coreDataManager.saveContext()
        }
        return resultModifyCategory
    }
        
        //save New Maker Data
        func saveDataNewMaker(categoriesProductsMAker: [(String, Bool)]) {
            
            //        let locationManager = LocationManager()
            //
            //        locationManager.geocode(latitude: touchCoordinateMaker.latitude, longitude: touchCoordinateMaker.longitude) { placemarks, error in
            //
            //            var newMaker = Maker()
            //            let coreDataManager = CoreDataManager.shared
            //            lazy var countryLocation = CountryMaker()
            //            lazy var cityLocation = CityMaker()
            //            var countryMaker: String?
            //            var cityMaker: String?
            //
            //            let maker = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneNumberMaker, email: emailMaker)
            //
            //
            //            switch maker {
            //            case.success(let maker):
            //                guard maker.count == 0 else {
            //                    self.presenter?.existAlreadyMaker(phoneNumberMaker: phoneNumberMaker, email: emailMaker)
            //                    return
            //                }
            //
            //                newMaker = createNewMaker()
            //
            //                // get country and city names by location
            //                // getCountryCityByLacation(touchCoordinateMaker, newMaker: newMaker)
            //                //            print (Double(touchCoordinateMaker.latitude) as? NSDecimalNumber, Double(touchCoordinateMaker.latitude))
            //
            //
            //
            //
            //            case .failure(let error):
            //                self.presenter?.fetchedMakerData(maker: nil, error: error)
            //
            //            }
            //
            //            guard let placeMark = placemarks?.first else { return }
            //            // Country
            //            if let country = placeMark.country {
            //                print(country)
            //                countryMaker = country
            //
            //            }
            //            // City
            //            if let city = placeMark.subAdministrativeArea {
            //                cityMaker = city
            //                print(city)
            //            }
            //            if let country = countryMaker {
            //                let countryExist = coreDataManager.getCountry(country: country)
            //                switch countryExist {
            //                case.success(let countryExist):
            //                    if countryExist.count == 0 {
            //                        let newCountry = CountryMaker()
            //                        newCountry.country_name = country
            //                        countryLocation = newCountry
            //                    } else {
            //                        if let countryLocationMaker = countryExist.first {
            //                            countryLocation = countryLocationMaker
            //                        }
            //                    }
            //                case .failure(let error):
            //                    self.presenter?.fetchedMakerData(maker: nil, error: error)
            //                }
            //            }
            //
            //            if let city = cityMaker {
            //                let countryName = countryLocation.country_name ?? ""
            //                let cityExist = coreDataManager.getCityWithName(cityName: city, country: countryName)
            //                switch cityExist {
            //                case.success(let cityExist):
            //                    if cityExist.count == 0 {
            //                        let newCity = CityMaker()
            //                        newCity.city_name = city
            //                        cityLocation = newCity
            //                        countryLocation.addToCountry_cities([newCity])
            //                    } else {
            //                        if let cityLocationMaker = cityExist.first {
            //                            cityLocation = cityLocationMaker
            //                        }
            //                    }
            //
            //                case .failure(let error):
            //                    self.presenter?.fetchedMakerData(maker: nil, error: error)
            //                 //   print(error)
            //                }
            //            }
            //
            //            //данные для созданияя пина на карте
            //            let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, urlImageMaker: urlImageMaker, coordinate: touchCoordinateMaker)
            //
            //            //allMakersAnotation.append(MakerAnotation)
            //
            //            self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
            //
            //            cityLocation.addToCity_makers([newMaker])
            //            coreDataManager.saveContext()
            //
            //            //create New Maker
            //            func createNewMaker() -> Maker {
            //                let newMaker = Maker()
            //                newMaker.maker_name = nameMaker
            //                newMaker.maker_surname = surnameMaker
            //                // bakerSergei.baker_product_categories = ["Торты"]
            //                newMaker.date = Date()
            //                newMaker.lat = Double(touchCoordinateMaker.latitude)
            //                newMaker.long = Double(touchCoordinateMaker.longitude)
            //                newMaker.phone_number = phoneNumberMaker
            //                newMaker.email  = emailMaker
            //                newMaker.password = passwordMaker
            //                newMaker.maker_image = urlImageMaker
            //                return newMaker
            //            }
        }
        
    }
