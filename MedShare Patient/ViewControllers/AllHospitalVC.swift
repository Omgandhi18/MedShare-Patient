//
//  AllHospitalVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class AllHospitalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationBarDelegate, DataDelegate, CLLocationManagerDelegate{
    
    
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tblHospitals: UITableView!
    
    var hospitalArr = [[String:Any]]()
    let database = Database.database().reference()
    var filteredHospitals = [[String: Any]]()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
               
            }
        }
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
            filteredHospitals = hospitalArr
            tblHospitals.delegate = self
            tblHospitals.dataSource = self
            tblHospitals.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allHospitalCell", for: indexPath) as! AllHospitalCell
        cell.viewBackground.layer.cornerRadius = 20
        cell.viewBackground.layer.masksToBounds = true
        
        cell.btnMakeAppointment.makeButtonRoundWithShadow()
        
        cell.btnDirections.makeButtonRoundWithShadow()
        
        cell.btnMakeAppointment.tag = indexPath.row
        cell.btnMakeAppointment.addTarget(self, action: #selector(makeAppointment(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        let address = filteredHospitals[indexPath.row]["address"] as? [String:Any]
        cell.lblHospitalName.text = filteredHospitals[indexPath.row]["hospital_name"] as? String
        cell.lblLocation.text = "\(address?["address_line_1"] as? String ?? ""), \(address?["city"] as? String ?? "")"
        cell.lblType.text = "Type: \(filteredHospitals[indexPath.row]["type"] as? String ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHospital = filteredHospitals[indexPath.row]
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalDetailsStory") as! HospitalDetailsVC
        viewController.hospitalData = selectedHospital
        viewController.delegate = self
        viewController.userLocation = CLLocation(latitude: locationManager.location?.coordinate.latitude ?? 0.00, longitude: locationManager.location?.coordinate.longitude ?? 0.00)
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(),.large()]
        }
        
        self.present(viewController, animated: true)
    }
    func sendData(data: [String : Any], isAppointment: Bool) {
        if isAppointment{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "makeAppointmentStory") as! MakeAppointmentVC
            vc.hospitalData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func makeAppointment(_ sender: UIButton){
        let data = filteredHospitals[sender.tag]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "makeAppointmentStory") as! MakeAppointmentVC
        vc.hospitalData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            if searchText.isEmpty == false {
                filteredHospitals = hospitalArr.filter{($0["hospital_name"] as! String).contains(searchText)}
            }
        else{
            filteredHospitals = hospitalArr
        }

            tblHospitals.reloadData()
    }
}
