//
//  MapVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 10/05/24.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblTopLabel: UILabel!
    //MARK: Variables
    public var userLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var hospitalArr = [[String:Any]]()
    let database = Database.database().reference()
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTopLabel.text = "Hospitals\nnear you"
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
               
            }
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsUserTrackingButton = true
        
        getHospitals()
        
        // Do any additional setup after loading the view.
    }
    func getHospitals(){
        database.child("hospitals").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                print(DatabaseManager.DatabaseError.failedToFetch)
                return
            }
            hospitalArr = value
            for value in hospitalArr{
                let hospitalLocation = MKPointAnnotation()
                let hospitalAddress = value["address"] as! [String: Any]
                
                hospitalLocation.coordinate = CLLocationCoordinate2D(latitude: hospitalAddress["latitude"] as? Double ?? 0.00, longitude: hospitalAddress["longitude"] as? Double ?? 0.00)
                
                mapView.addAnnotation(hospitalLocation)
            }
            
            
        })
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MyPin"
            
            if annotation is MKUserLocation {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(named: "HospitalLocation")
                annotationView?.isUserInteractionEnabled = true

                
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
        let selectedHospital = hospitalArr.first(where: {(annotation.coordinate.latitude == ($0["address"] as! [String: Any])["latitude"] as! CLLocationDegrees) && (annotation.coordinate.longitude == ($0["address"] as! [String: Any])["longitude"] as! CLLocationDegrees)})
       
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalDetailsStory") as! HospitalDetailsVC
        viewController.hospitalData = selectedHospital ?? [:]
        viewController.userLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(),.large()]
        }
        
        self.present(viewController, animated: true)
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
