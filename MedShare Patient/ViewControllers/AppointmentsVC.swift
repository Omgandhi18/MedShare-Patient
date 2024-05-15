//
//  AppointmentsVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AppointmentsVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tblAppointments: UITableView!
   
    
    var appointments = [[String:Any]]()
    let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        getAppointmentDetail()
    }
    
    func getAppointmentDetail(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let data = snapshot.value as? [[String: Any]] else{
                return
            }
            appointments = data
            tblAppointments.delegate = self
            tblAppointments.dataSource = self
            tblAppointments.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentCell
        cell.viewBack.layer.cornerRadius = 20
        cell.viewBack.layer.masksToBounds = true
        
       
        
        cell.btnDirections.makeButtonRoundWithShadow()
        
       
        
        cell.selectionStyle = .none
        let hospitalData = appointments[indexPath.row]["hospital_data"] as? [String:Any] ?? [:]
        let address = hospitalData["address"] as? [String:Any]
        cell.lblHospitalName.text = hospitalData["hospital_name"] as? String
        cell.lblLocation.text = "\(address?["address_line_1"] as? String ?? ""), \(address?["city"] as? String ?? "")"
        cell.lblReasons.text = appointments[indexPath.row]["reasons"] as? String
        cell.lblDateTime.text = appointments[indexPath.row]["date_time"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }

}
