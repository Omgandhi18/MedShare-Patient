//
//  AllHospitalVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit

class AllHospitalVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationBarDelegate{
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tblHospitals: UITableView!
    
    var hospitalArr = [["Name" : "Hospital 1","Location" : "Vadodara","Latitude" : 0.00,"Longitude" : 0.00,"hospitalType" : "Dentist"], ["Name" : "Hospital 2","Location" : "Vadodara","Latitude" : 0.00,"Longitude" : 0.00,"hospitalType" : "Dentist"]]
    var filteredHospitals = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblHospitals.delegate = self
        tblHospitals.dataSource = self
        filteredHospitals = hospitalArr
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
        cell.lblHospitalName.text = filteredHospitals[indexPath.row]["Name"] as? String
        cell.lblLocation.text = filteredHospitals[indexPath.row]["Location"] as? String
        cell.lblType.text = "Type: \(filteredHospitals[indexPath.row]["hospitalType"] as? String ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHospital = filteredHospitals[indexPath.row]
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalDetailsStory") as! HospitalDetailsVC
        viewController.hospitalData = selectedHospital
        
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(),.large()]
        }
        
        self.present(viewController, animated: true)
    }
    @objc func makeAppointment(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "makeAppointmentStory") as! MakeAppointmentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            if searchText.isEmpty == false {
                filteredHospitals = hospitalArr.filter{($0["Name"] as! String).contains(searchText)}
            }
        else{
            filteredHospitals = hospitalArr
        }

            tblHospitals.reloadData()
    }
}
