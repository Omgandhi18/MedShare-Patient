//
//  HospitalDetailsVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 10/05/24.
//

import UIKit
import CoreLocation
class HospitalDetailsVC: UIViewController {
//MARK: Outlets
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnMakeAppointment: UIButton!
    @IBOutlet weak var btnLocations: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTopBar: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    //MARK: Variables
    
    var hospitalData = [String:Any]()
    var userLocation = CLLocation(latitude: 0, longitude: 0)
    // ["Name" : "Hospital 1","Location" : "Vadodara","Latitude" : 55.930476,"Longitude" :  -3.256601,"hospitalType" : "Dentist"]
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTopBar.layer.cornerRadius = lblTopBar.frame.size.height/2
        lblTopBar.layer.masksToBounds = true
        
        btnMakeAppointment.makeButtonRoundWithShadow()
        btnLocations.makeButtonRoundWithShadow()
        btnCall.makeButtonCurvedWithShadow(radius: 14)
        
        lblHospitalName.text = hospitalData["hospital_name"] as? String
        let hospitalAddress = hospitalData["address"] as? [String:Any]
        lblLocation.text = "\(hospitalAddress?["city"] as? String ?? ""), \(hospitalAddress?["country"] as? String ?? "")"
        if hospitalAddress?["address_line_1"] as? String == ""{
            lblAddress.text = "\(hospitalAddress?["address_line_1"] as? String ?? ""), \(hospitalAddress?["city"] as? String ?? ""), \(hospitalAddress?["postal_code"] as? String ?? "")"
        }
        else{
            lblAddress.text = "\(hospitalAddress?["address_line_1"] as? String ?? ""), \(hospitalAddress?["address_line_2"] as? String ?? ""), \(hospitalAddress?["city"] as? String ?? ""), \(hospitalAddress?["postal_code"] as? String ?? "")"
        }
        lblPhoneNumber.text = hospitalData["mobile_number"] as? String
        lblType.text = "Type:- \(hospitalData["type"] as? String ?? "General")"
        // Do any additional setup after loading the view.
        let distanceInMeters = userLocation.distance(from: CLLocation(latitude: hospitalAddress?["latitude"] as? Double ?? 0.00, longitude: hospitalAddress?["longitude"] as? Double ?? 0.00))
        print(distanceInMeters)
        lblDistance.text = "Distance: \(String(format: "%.2f", distanceInMeters * 0.00062137)) miles"
    }
    
    //MARK: Button methods
    
    

}
