//
//  HospitalDetailsVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 10/05/24.
//

import UIKit

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
    // ["Name" : "Hospital 1","Location" : "Vadodara","Latitude" : 55.930476,"Longitude" :  -3.256601,"hospitalType" : "Dentist"]
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTopBar.layer.cornerRadius = lblTopBar.frame.size.height/2
        lblTopBar.layer.masksToBounds = true
        
        btnMakeAppointment.makeButtonRoundWithShadow()
        btnLocations.makeButtonRoundWithShadow()
        btnCall.makeButtonCurvedWithShadow(radius: 14)
        
        lblHospitalName.text = hospitalData["Name"] as? String
        lblAddress.text = hospitalData["Location"] as? String
        lblLocation.text = hospitalData["Location"] as? String
        lblType.text = "Type:- \(hospitalData["hospitalType"] as? String ?? "General")"
        // Do any additional setup after loading the view.
    }
    
    //MARK: Button methods
    
    

}
