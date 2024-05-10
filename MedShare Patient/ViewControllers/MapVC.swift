//
//  MapVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 10/05/24.
//

import UIKit
import MapKit
import CoreLocation
class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lblTopLabel: UILabel!
    //MARK: Variables
    public var userLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var hospitalArr = [["Name" : "Hospital 1","Location" : "Vadodara","Latitude" : 55.930476,"Longitude" :  -3.256601,"hospitalType" : "Dentist"]]
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
        
        let hospitalLocation = MKPointAnnotation()
        hospitalLocation.coordinate = CLLocationCoordinate2D(latitude: hospitalArr[0]["Latitude"] as? Double ?? 0.00, longitude: hospitalArr[0]["Longitude"] as? Double ?? 0.00)
        
        mapView.addAnnotation(hospitalLocation)
        
        // Do any additional setup after loading the view.
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
        
        let selectedHospital = hospitalArr.first(where: {annotation.coordinate.latitude == $0["Latitude"] as! CLLocationDegrees})
       
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalDetailsStory") as! HospitalDetailsVC
        viewController.hospitalData = selectedHospital ?? [:]
        
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
