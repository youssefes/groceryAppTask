//
//  HomeViewController.swift
//  delivery
//
//  Created by youssef on 3/14/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class mapViewController: BaseWireFrame<mapViewModel> {
    
    @IBOutlet weak var tableViewResultOfSearsh: UITableView!
    
    
    static var selectedAddre :  PublishSubject<String> = .init()
    static var selectedLocation :  PublishSubject<CLLocationCoordinate2D> = .init()
    var address = [String]()
    let cellIdentefier = "mapTableViewCell"
    @IBOutlet weak var searchBar: UISearchBar!
    var locations : [location] = []
    var locationDistanse : Double = 500
    
    var showMenu : Bool = false
    let gecoder = CLGeocoder()
    var LocationManager : CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationManger()
        setupUi()
    }
    
    func setupUi(){
        mapView.delegate = self
        searchBar.delegate = self
        tableViewResultOfSearsh.register(UINib(nibName: cellIdentefier, bundle: nil), forCellReuseIdentifier: cellIdentefier)
        tableViewResultOfSearsh.delegate = self
        tableViewResultOfSearsh.dataSource = self
        tableViewResultOfSearsh.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bind(ViewModel: mapViewModel) {
        
    }
    
    @IBAction func takeLocation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func setupLocationManger(){
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationManger(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            self.checkAuthorizationStaus()
        }else{
            print("do not allow")
        }
    }
}

extension mapViewController: CLLocationManagerDelegate{
    func checkAuthorizationStaus(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startGetLocation()
            print("allow to know location WhenInUse")
        case .denied:
            break
        case .notDetermined:
            LocationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
          startGetLocation()
         
            print("allow to know location")
        @unknown default:
            print("no more check in switch")
        }
    }
    
    func startGetLocation(){
        LocationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        guard let userLocation = LocationManager.location?.coordinate else {return}
        centerUserLocation(center: userLocation)
        mapViewController.selectedLocation.onNext(userLocation)
        getNameOfMyLocation(location: userLocation)
        centerUserLocation(center: userLocation)
        
    }
    
    func getCiteusingGecoder(nameOfLocation : String) {
        //Alexandria
        gecoder.geocodeAddressString(nameOfLocation) { (placeMarks, error) in
            if let err = error{
                print(err.localizedDescription)
            }
        
            guard let placeMarks = placeMarks, let placeMark = placeMarks.first, let location = placeMark.location else {return}
           print(location)
        }
        
        
    }
    
    func getNameOfMyLocation(location : CLLocationCoordinate2D){
        
        self.address.removeAll()
        print(location)
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
            gecoder.reverseGeocodeLocation(location) { (placesMark, error) in
                guard let placeMark = placesMark?.first else { return }
                
                // Location name
                if let locationName = placeMark.name {
                    self.address.append(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    self.address.append(street)
                    print(street)
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    self.address.append(city)
                    print(city)
                    self.address.append(city)
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                }
                // Country
                if let country = placeMark.country {
                    self.address.append(country)
                }
                
               let addressString  = self.address.joined(separator: "/")
                mapViewController.selectedAddre.onNext(addressString)
                
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStaus()
    }
    
    func centerUserLocation(center : CLLocationCoordinate2D){
        let coordinateRegin = MKCoordinateRegion(center: center, latitudinalMeters: locationDistanse * 2.0, longitudinalMeters: locationDistanse * 2.0 )
        mapView.setRegion(coordinateRegin, animated: true)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let center = location.coordinate
            centerUserLocation(center: center)
        }
    }
    
    
}

extension mapViewController : MKMapViewDelegate, UISearchBarDelegate{
  

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            locations.removeAll()
            tableViewResultOfSearsh.isHidden = true
        }
        findLocation(quary: searchText) { (locations) in
            self.locations = locations
            
            self.tableViewResultOfSearsh.isHidden = false
            DispatchQueue.main.async {
                self.tableViewResultOfSearsh.reloadData()
            }
        }
    }
    
    
    func findLocation(quary : String ,  commplation : @escaping (_ places : [location])->Void){
        
        gecoder.geocodeAddressString(quary) { (places, error) in
            guard let places = places, error == nil else {return}
            let models : [location] = places.compactMap ({ place in
                
                var name = ""
                if let locationName = place.name{
                    name += locationName
                }
                
                if let locatinArea = place.administrativeArea{
                    name += ", \(locatinArea)"
                }
                if let locality = place.locality{
                    name += ", \(locality)"
                }
                
                if let country = place.country{
                    name += ", \(country)"
                }
                let resulte = location(name: name, coordinate: place.location?.coordinate)
                
                return resulte
            })
            

            commplation(models)
        }
    }

}

extension mapViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentefier, for: indexPath) as! mapTableViewCell
        cell.nameOflbl?.text = locations[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinate = locations[indexPath.row].coordinate
        guard let coordinatefalid = coordinate else {return}
        view.endEditing(true)
        let title = locations[indexPath.row].name
        let pin = MKPointAnnotation()
        pin.coordinate = coordinatefalid
        pin.title = locations[indexPath.row].name
        centerUserLocation(center: coordinatefalid)
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinatefalid, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        tableViewResultOfSearsh.isHidden = true
        searchBar.text = ""
        mapViewController.selectedAddre.onNext(title)
        mapViewController.selectedLocation.onNext(coordinatefalid)
        
    }
    
    
}
