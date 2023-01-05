//
//  MapViewController.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import UIKit
import SnapKit
import MapKit


// MARK: - MapViewInputProtocol
 protocol MapViewInputProtocol: AnyObject {
    func showDate(pinMakers: [MakerAnotation])
    func setMakerImageView(imageMAker: UIImage)
    func showAlertLocation(title: String, message: String?, url: URL?, titleAction: String?, touchCoordinate: CLLocationCoordinate2D?)
    func setupBottomViewMakerData()
    func removePinMakers(pinMakers: MakerAnotation)
    var mapView: MKMapView { get }
    
}
// MARK: - MapViewController
 final class MapViewController: UIViewController {
     // MARK: - properties
     var mapView = MKMapView()
    var maker: MakerAnotation?
     let locationManager = CLLocationManager()
    
    let sliderBottomView = SliderBottomView()
    var productCategoriesButton: [UIButton] = []
    let filterCategoriesButton = UIButton()
    let zoomInButton = UIButton()
    let zoomOutButton = UIButton()
     
    let zoomButtonStack = UIStackView()
     
    lazy var viewHeight = CGFloat()
    lazy var viewWidth = CGFloat()
    lazy var heightSliderView: CGFloat = 250
    lazy var indentOfRightForSliderFilterCategoriesView: CGFloat = 80
    
    lazy var isHiddenFilterCategoriesView = true
    
    var presenter: MapViewOutputProtocol?
    
    // MARK: - View lifecycle
     override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        addGestureRecognizerOnMap()
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLocationAnabled()
    }
}

// MARK: - private functions
extension MapViewController: MKMapViewDelegate {
    private func initialize() {
        createMApView()
        setupSliderButtonView()
        createZoomInOutButton()
        createFilterCategoriesButton()
        addViewConstraints()
        presenter?.viewDidLoaded()
    }
    private func createMApView(){
        mapView.delegate = self
        mapView.mapType = MKMapType.mutedStandard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        view.addSubview(mapView)
    }
    
    private func setupSliderButtonView() {
        mapView.addSubview(sliderBottomView)
        sliderBottomView.routeButton.addTarget(self, action: #selector(routeToMaker), for: .touchUpInside)
        sliderBottomView.phoneButton.addTarget(self, action: #selector(isClickedphoneButton), for: .touchUpInside)
        sliderBottomView.emailButton.addTarget(self, action: #selector(isClickeEmailButton), for: .touchUpInside)
    }
    
    private func createFilterCategoriesButton() {
        filterCategoriesButton.backgroundColor = .clear
        filterCategoriesButton.setImage(UIImage(named: "layers", in: .module, compatibleWith: nil), for: .normal)
        filterCategoriesButton.addTarget(self, action: #selector(isClickedFilterCategoriesButton), for: .touchUpInside)
        mapView.addSubview(filterCategoriesButton)
    }
    
    private func createZoomInOutButton() {
        
        zoomInButton.backgroundColor = .clear
        zoomInButton.setImage(UIImage(named: "zoom-in", in: .module, compatibleWith: nil), for: .normal)
        zoomInButton.addTarget(self, action: #selector(isClickedFZoomInButton), for: .touchUpInside)
        
        zoomOutButton.backgroundColor = .clear
        zoomOutButton.setImage(UIImage(named: "zoom-out", in: .module, compatibleWith: nil), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(isClickedFZoomOutButton), for: .touchUpInside)
        
        zoomButtonStack.axis = .vertical
        zoomButtonStack.distribution = .equalSpacing
        zoomButtonStack.alignment = .leading
        zoomButtonStack.spacing = 6.0
        
        zoomButtonStack.addArrangedSubview(zoomInButton)
        zoomButtonStack.addArrangedSubview(zoomOutButton)
        
        view.addSubview(zoomButtonStack)
    }
    
    private func addViewConstraints() {
        mapView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        viewHeight = view.bounds.height
        sliderBottomView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(mapView)
            make.height.equalTo(heightSliderView)
            make.top.equalTo(viewHeight)
        }
        filterCategoriesButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37)
            make.height.equalTo(37)
            make.top.equalTo(mapView.safeAreaInsets.top).inset(60)
            make.left.equalTo(mapView.safeAreaInsets.left).inset(25)
        }
        zoomInButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37)
            make.height.equalTo(37)
        }
        zoomOutButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37)
            make.height.equalTo(37)
        }
        zoomButtonStack.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(mapView.safeAreaInsets.right).inset(20)
            make.centerY.equalTo(mapView.snp.centerY)
        }
    }
    
    @objc func isClickedFilterCategoriesButton() {
        presenter?.isClickedFilterCategoriesButton()
    }
    
    private func hideFilterCategoriesView() {
        
        presenter?.isShortViewMapTapped()
    }
    
    private func setupMakerImageView() {
        let pathImageMaker = maker?.pathImageMaker
        presenter?.getMakerImage(pathImage: pathImageMaker)
        sliderBottomView.recognizer.addTarget(self, action: #selector(tapForMakerImageAction(_:)))
    }
    
    //обработка клика на ZoomInButton
    @objc func isClickedFZoomInButton() {
        presenter?.isClickedFZoomInButton()
    }
    
    @objc func isClickedFZoomOutButton() {
        presenter?.isClickedFZoomOutButton()
    }
    
    //обработка клика на makerImageFiew action when makerImageFiew is pressed
    @objc func tapForMakerImageAction (_ gestureRecognizer: UITapGestureRecognizer){
        guard let coordinate = maker?.coordinate else { return }
        presenter?.isTappedMakerImageView(touchCoordinate: coordinate, makerAnotation: maker)
    }
    
    //add Gesture Recognizer on the map
    private func addGestureRecognizerOnMap() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shortClickOnMap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func checkLocationAnabled(){
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAutorization()
        } else {
            showAlertLocation(title: "У Вас отключена служба геолокации", message: "Хотите включить?", url: URL(string: "App-prefs:root=Privacy&path=LOCATION"), titleAction: "Настройки", touchCoordinate: nil)
            
        }
    }
    
    private func setupManager(){
        locationManager.delegate = self
        //точность определения местоположения
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkAutorization(){
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
    
    private func setupMakerLabel() {
        if let surname = maker?.surnameMaker, let name = maker?.nameMaker {
            sliderBottomView.makerLabel.text = surname + " " + name
        }
    }
    
    //выводим название категорий для конкретного мейкера
    private func setupListOfCategoryLabel() {
        sliderBottomView.listOfCategoryLabel.text = ""
        guard let productCategories = maker?.productCategoriesMaker else { return }
        var text = String()
        for productCategory in productCategories {
            if let categoryName = productCategory.category_name{
                text += categoryName + "  "
            }
        }
        sliderBottomView.listOfCategoryLabel.text = text
    }
    
    // убираем sliderBottomView и FilterCategoriesView по клику на карту hide sliderBottomView
    @objc func shortClickOnMap() {
        getoutSliferBottomView()
        hideFilterCategoriesView()
        isHiddenFilterCategoriesView = true
    }
    
    // убираем sliderBottomView
    private func getoutSliferBottomView() {
        self.sliderBottomView.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(self.viewHeight)
        }
        mapView.alpha = 1
    }
    
    //построить маршрут build and show a route
    @objc func routeToMaker(){
        guard let coordinate = locationManager.location?.coordinate else {return}
        self.mapView.removeOverlays(mapView.overlays) //удаляем старый маршрут с карты
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
    }
    
    // make phone call
    @objc func isClickedphoneButton() {
        guard let maker = maker else { return }
        presenter?.isClickedPhoneButton(makerAnotation: maker)
    }
    // send email
    @objc func isClickeEmailButton(){
        guard let maker = maker else { return }
        presenter?.isClickedEmailButton(makerAnotation: maker)
    }

    //add new location on the map
    @objc func longTap(sender: UIGestureRecognizer){
        getoutSliferBottomView()
        presenter?.isLongTappedOnMapView(sender: sender)
    }
    
    private func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Some Title"
        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - functions mapView
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        maker = view.annotation as? MakerAnotation
        
        hideFilterCategoriesView()
        isHiddenFilterCategoriesView = true
        
        mapView.alpha = 0.5
        // show sliderBottomView with animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.sliderBottomView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(self.viewHeight - self.heightSliderView)
            }
            self.mapView.layoutIfNeeded()
        }
        setupBottomViewMakerData()
    }
    
    //настройка линий маршрута
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 4
        return render
    }
}
// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    //отслеживание месторасположения (изменение)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    //при смене статуса авторизации
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorization()
    }
}

// MARK: - MapViewInputProtocol
extension MapViewController: MapViewInputProtocol {
     func showDate(pinMakers: [MakerAnotation]){
        for pinMaker in pinMakers {
            maker = pinMaker
            mapView.addAnnotation(pinMaker)
        }
    }
    
     func removePinMakers(pinMakers: MakerAnotation){
        mapView.removeAnnotation(pinMakers)
    }
    
     func setMakerImageView(imageMAker: UIImage) {
        sliderBottomView.makerImageView.image = imageMAker
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
    
    //обновляем данные на Makerа на bottomView
     func setupBottomViewMakerData() {
        setupListOfCategoryLabel()
        setupMakerLabel()
        setupMakerImageView()
    }
    
}
