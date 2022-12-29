//
//  MapViewController.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import UIKit
import SnapKit
import MapKit



 protocol MapViewInputProtocol: AnyObject {
    func showDate(pinMakers: [MakerAnotation])
    func setMakerImageView(imageMAker: UIImage)
    func showAlertLocation(title: String, message: String?, url: URL?, titleAction: String?, touchCoordinate: CLLocationCoordinate2D?)
    func setupBottomViewMakerData()
    func updateSliderFilterCategoriesView(productCategories: [(String, Bool)])
    func removePinMakers(pinMakers: MakerAnotation)
    var mapView: MKMapView { get }
    
}

 final class MapViewController: UIViewController {
     var mapView = MKMapView()
    var maker: MakerAnotation?
     let locationManager = CLLocationManager()
    
    lazy var sliderFilterCategoriesView = SliderFilterCategoriesView(tableView: categoriesTableView)
    let categoriesTableView = UITableView()
    let identifier = "MyCell"
    
    let sliderBottomView = SliderBottomView()
    var productCategoriesButton: [UIButton] = []
    let filterCategoriesButton = UIButton()
    lazy var viewHeight = CGFloat()
    lazy var viewWidth = CGFloat()
    lazy var heightSliderView: CGFloat = 250
    lazy var indentOfRightForSliderFilterCategoriesView: CGFloat = 80
    
    var productCategories: [(String, Bool)]? {
        didSet {
            categoriesTableView.reloadData()
        }
    }
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

// MARK: - Private functions
extension MapViewController: MKMapViewDelegate {
    func initialize() {
        createMApView()
        setupSliderButtonView()
        createFilterCategoriesButton()
        setupSliderFilterCategoriesView()
        addViewConstraints()
        presenter?.viewDidLoaded()
        addViewConstraints()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    private func createMApView(){
        mapView.delegate = self
        mapView.mapType = MKMapType.mutedStandard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        view.addSubview(mapView)
    }
    
    func setupSliderButtonView() {
        mapView.addSubview(sliderBottomView)
        sliderBottomView.routeButton.addTarget(self, action: #selector(routeToMaker), for: .touchUpInside)
    }
    
    func setupSliderFilterCategoriesView() {
        mapView.addSubview(sliderFilterCategoriesView)
    }
    
    func createFilterCategoriesButton() {
        
        filterCategoriesButton.backgroundColor = .clear //Colors.activeButtonColor.colorViewUIColor
        
        filterCategoriesButton.addTarget(self, action: #selector(isClickedFilterCategoriesButton), for: .touchUpInside)
        // routeButton.frame = CGRect(x: 50, y: 50, width: 70, height: 30)
        mapView.addSubview(filterCategoriesButton)
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
        sliderFilterCategoriesView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(-viewWidth)
            make.width.equalTo(viewWidth - indentOfRightForSliderFilterCategoriesView)
            make.top.equalTo(filterCategoriesButton.snp.bottom)
            make.bottom.equalToSuperview()
        }
        filterCategoriesButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(37)
            make.height.equalTo(37)
            make.top.equalTo(mapView.safeAreaInsets.top).inset(60)
            make.left.equalTo(mapView.safeAreaInsets.left).inset(25)
        }
    }
    
    @objc func isClickedFilterCategoriesButton() {
        
        presenter?.isClickedFilterCategoriesButton()
    }
    
    //показываем
    func showFilterCategoriesView() {
        mapView.alpha = 0.5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.sliderFilterCategoriesView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(self.viewWidth - self.viewWidth)
            }
            self.mapView.layoutIfNeeded()
        }
    }
    
    func hideFilterCategoriesView() {
        mapView.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
            self.sliderFilterCategoriesView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(-self.viewWidth)
            }
            self.mapView.layoutIfNeeded()
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
        presenter?.isTappedMakerImageView(touchCoordinate: coordinate, makerAnotation: maker)
    }
    
    //add Gesture Recognizer on the map
    func addGestureRecognizerOnMap() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shortClickOnMap))
        mapView.addGestureRecognizer(tapGesture)
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
    
    func setupMakerLabel() {
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
    func getoutSliferBottomView() {
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
    }
    
    //настройка линий маршрута
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 4
        return render
    }
    //add new location on the map
    @objc func longTap(sender: UIGestureRecognizer){
        getoutSliferBottomView()
        presenter?.isLongTappedOnMapView(sender: sender)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Some Title"
        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
}

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

// MARK: - MapViewProtocol
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
    
     func updateSliderFilterCategoriesView(productCategories: [(String, Bool)]) {
        self.productCategories = productCategories
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSectionCategoriesView ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = productCategories?[indexPath.item].0
        cell.accessoryType = productCategories?[indexPath.item].1 ?? false ? .checkmark : .none
        
        return cell
    }
}
