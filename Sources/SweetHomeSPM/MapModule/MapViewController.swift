//
//  MapViewController.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import UIKit
import SnapKit
import MapKit



public protocol MapViewInputProtocol: AnyObject {
    func showDate(pinMakers: [MakerAnotation])
    func setMakerImageView(imageMAker: UIImage)
    var mapView: MKMapView { get }
    
}

public class MapViewController: UIViewController {
    public var mapView = MKMapView()
    //var annotationView: MKAnnotationView?
    var maker: MakerAnotation?
    let locationManager = CLLocationManager()
    let sliderBottomView = SliderBottomView()
    let buttonStack = UIStackView()
    var viewHeight = CGFloat()
    lazy var heightSliderView: CGFloat = 250
    // MARK: - Public
    var presenter: MapViewOutputProtocol?
    
    
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        addGestureRecognizerOnMap()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationAnabled()
    }
    
    deinit{
        print("MapView deinit")
    }
}



// MARK: - Private functions
extension MapViewController: MKMapViewDelegate {
    func initialize() {
        createMApView()
        presenter?.viewDidLoaded()
        //  checkLocationAnabled()
    }
    private func createMApView(){
        mapView.delegate = self
        mapView.mapType = MKMapType.mutedStandard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        //mapView.center = view.center
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(self.view)
            //make.right.equalTo(self.view)
            // make.top.bottom.equalTo(self.view.snp.top)
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mapView.addSubview(sliderBottomView)
        viewHeight = view.bounds.height
            //.bounds.size
        sliderBottomView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(mapView)
            make.height.equalTo(heightSliderView)
            make.top.equalTo(viewHeight)
        }
    }
    func setupMakerImageView() {
        let pathImageMaker = maker?.pathImageMaker
        presenter?.getMakerImage(pathImage: pathImageMaker)
        sliderBottomView.recognizer.addTarget(self, action: #selector(tapForMakerImageAction(_:)))
    }
    
    
    //обработка клика на makerImageFiew action when makerImageFiew is pressed
    @objc func tapForMakerImageAction (_ gestureRecognizer: UITapGestureRecognizer){
        guard let coordinate = maker?.coordinate else { return }
        presenter?.isTappedMakerImageView(touchCoordinate: coordinate)
      
    }
    
    //add Gesture Recognizer on the map
    func addGestureRecognizerOnMap() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    func checkLocationAnabled(){
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAutorization()
        } else {
            showAlertLocation(title: "У Вас отключена служба геолокации", message: "Хотите включить?", url: URL(string: "App-prefs:root=Privacy&path=LOCATION"), titleAction: "Настройки", touchCoordinate: nil)
            
        }
    }
    
    func setupManager(){
        locationManager.delegate = self
        //точность определения местоположения
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAutorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Вы отключили в настройках использование месторасположение", message: "Вы хотите это изменить?", url: URL(string: UIApplication.openSettingsURLString), titleAction: "Настройки", touchCoordinate: nil)
            break
        case .restricted: //ограничения есть (например: родительский контроль)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
        
    }
    
    //Алерт
    func showAlertLocation(title: String, message: String?, url: URL?, titleAction: String?, touchCoordinate: CLLocationCoordinate2D?){
        var anyAction: UIAlertAction
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch titleAction {
        case "Настройки":
            anyAction = UIAlertAction(title: titleAction, style: .default) { (alert) in
                if let url = url{
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        case "Да":
            anyAction = UIAlertAction(title: titleAction, style: .default) { (alert) in
                print("регистрация")
                guard let touchCoordinate = touchCoordinate else { return }
                self.presenter?.newRegistrationIsTapped(touchCoordinate: touchCoordinate)
            }
        default: return
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(anyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MakerAnotation else {return nil}
        var viewMarker: MKMarkerAnnotationView
        let idView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView{
            view.annotation = annotation
            viewMarker = view
        } else{
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 6)
            viewMarker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return viewMarker
    }
    
    //callout AccessoryControl Tapped обработка нажатия на кнопку в аннотации
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        maker = view.annotation as? MakerAnotation
        //annotationView = view
        //routeToMaker (mapView: mapView, annotationView: view)
        
        //let sliderBottomView = SliderBottomView()
        
        
        
        // let viewMapSize = UIScreen.main.bounds.size
        //sliderView.backgroundColor = .white
        
        //  sliderView.frame = CGRect(x: 0, y: viewMapSize.height, width: viewMapSize.width, height: 250)
        
        mapView.alpha = 0.5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shortClickOnMap))
        mapView.addGestureRecognizer(tapGesture)
        
        // show sliderBottomView with animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.sliderBottomView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(self.viewHeight - self.heightSliderView)
            }
            self.mapView.layoutIfNeeded()
        }
        createProductCategoriesButton()
        sliderBottomView.routeButton.addTarget(self, action: #selector(routeToMaker), for: .touchUpInside)
        if let surname = maker?.surnameMaker, let name = maker?.nameMaker {
            sliderBottomView.makerLabel.text = surname + " " + name
        }
        setupMakerImageView()
    }
    
    //выводим название категорий для конкретного мейкера
    private func createProductCategoriesButton() {
        guard let productCategories = maker?.productCategoriesMaker else { return }
       // let productCategoryButton = UIButton()
        var productCategoriesButton: [UIButton] = [] // [productCategoryButton]
        var indexArrayButton = 0
        
        buttonStack.removeArrangedSubview(<#T##view: UIView##UIView#>)
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.spacing = 2.0
        
        sliderBottomView.addSubview(buttonStack)
       
        buttonStack.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            
            make.top.equalTo(sliderBottomView.categoryLabel.snp.bottom).offset(10)
            //make.width.equalToSuperview().multipliedBy(0.6)
        }
        for productCategory in productCategories {
            let button = UIButton()
            let categoryName = productCategory.category_name
            button.setTitle(categoryName, for: .normal)
            button.setTitleColor(Colors.activeButtonColor.colorViewUIColor, for: .normal)
            button.backgroundColor = Colors.whiteLabel.colorViewUIColor
            button.titleLabel?.font = Fonts.fontButton.fontsForViews
            productCategoriesButton.append(button)
            buttonStack.addArrangedSubview(productCategoriesButton[indexArrayButton])
            
            indexArrayButton += 1
//            productCategoriesButton[indexArrayButton].snp.makeConstraints { (make) -> Void in
//                make.width.equalToSuperview().inset(20)
//                make.height.equalTo(20)
            
        }
            
    }
    
    // убираем sliderBottomView по клику на карту hide sliderBottomView
    @objc func shortClickOnMap() {
        self.sliderBottomView.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(self.viewHeight)
        }
        mapView.alpha = 1
    }
    
    
    //построить маршрут build and show a route
    @objc func routeToMaker(){ //(mapView: MKMapView, annotationView view: MKAnnotationView){
        guard let coordinate = locationManager.location?.coordinate else {return}
        self.mapView.removeOverlays(mapView.overlays) //удаляем старый маршрут с карты
        //let maker = annotationView?.annotation as! MakerAnotation
        let startPoint = MKPlacemark(coordinate: coordinate)
        guard let maker = maker else {return}
        let endPoint = MKPlacemark(coordinate: maker.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else {return}
            for route in response.routes{
                self.mapView.addOverlay(route.polyline)
            }
        }
//        self.sliderBottomView.snp.updateConstraints { (make) -> Void in
//            make.top.equalTo(self.viewHeight)
//        }
    }
    
    //настройка линий маршрута
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 4
        return render
    }
    //add new location on the map
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
//            let locationInView = sender.location(in: mapView)
//            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
//            addAnnotation(location: locationOnMap)
            showAlertLocation(title: "Регистрация", message: "Хотите добавить нового поставщика услуг?", url: nil, titleAction: "Да", touchCoordinate: touchCoordinate)
            
            //get address, sity and contry names from location after long tap on the map
            
            // Add below code to get address for touch coordinates.
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                                                {
                placemarks, error -> Void in
                
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    print(country)
                }
            })
            
//                          let annotation = MKPointAnnotation()
//             annotation.coordinate = touchCoordinate
//             annotation.title = "Your position"
//             mapView.addAnnotation(annotation) //drops the pin
//             print("lat:  \(touchCoordinate.latitude)")
//             let num = touchCoordinate.latitude as NSNumber
//             let formatter = NumberFormatter()
//             formatter.maximumFractionDigits = 4
//             formatter.minimumFractionDigits = 4
//             _ = formatter.string(from: num)
//             print("long: \(touchCoordinate.longitude)")
//             let num1 = touchCoordinate.longitude as NSNumber
//             let formatter1 = NumberFormatter()
//             formatter1.maximumFractionDigits = 4
//             formatter1.minimumFractionDigits = 4
//             _ = formatter1.string(from: num1)
//             print( "что-то \(num),\(num1)")
//
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Some Title"
        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
}

//отслеживание месторасположения (изменение)
extension MapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    //при смене статуса авторизации
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorization()
    }
}

// MARK: - MapViewProtocol
extension MapViewController: MapViewInputProtocol {
    public func showDate(pinMakers: [MakerAnotation]){
        for pinMaker in pinMakers {
            mapView.addAnnotation(pinMaker)
        }
    }
    
    public func setMakerImageView(imageMAker: UIImage) {
        sliderBottomView.makerImageView.image = imageMAker
    }
    
}
