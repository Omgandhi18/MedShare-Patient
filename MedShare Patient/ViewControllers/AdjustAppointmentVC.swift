//
//  AdjustAppointmentVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AdjustAppointmentVC: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSelectAnotherSlot: UIButton!
    
    var appointmentData = [String:Any]()
    var incomingAppointments = [[String:Any]]()
    var bookedAppointments = [[String:Any]]()
    let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = []
        // hide the default back buttons
         self.navigationItem.hidesBackButton = true
        viewTop.layer.cornerRadius = 25
        viewTop.layer.masksToBounds = true
        viewTop.layer.shadowColor = UIColor.black.cgColor
        viewTop.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewTop.layer.shadowRadius = 10
        viewTop.layer.shadowOpacity = 0.25
        viewTop.clipsToBounds = false
        
        btnConfirm.layer.cornerRadius = 25
        btnConfirm.layer.masksToBounds = true
        btnConfirm.layer.shadowColor = UIColor.black.cgColor
        btnConfirm.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnConfirm.layer.shadowRadius = 10
        btnConfirm.layer.shadowOpacity = 0.25
        btnConfirm.clipsToBounds = false
        
        btnSelectAnotherSlot.layer.cornerRadius = 25
        btnSelectAnotherSlot.layer.masksToBounds = true
        btnSelectAnotherSlot.layer.shadowColor = UIColor.black.cgColor
        btnSelectAnotherSlot.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnSelectAnotherSlot.layer.shadowRadius = 10
        btnSelectAnotherSlot.layer.shadowOpacity = 0.25
        btnSelectAnotherSlot.clipsToBounds = false
        
        lblDate.text = appointmentData["suggested_date"] as? String
        lblDate.layer.cornerRadius = 20
        lblDate.layer.masksToBounds = true
        lblTime.text = appointmentData["suggested_time"] as? String
        
        lblTime.layer.cornerRadius = 20
        lblTime.layer.masksToBounds = true
        getAppointmentDetail()
    }
    func getAppointmentDetail(){
        let hospitalData = appointmentData["hospital_data"] as? [String:Any] ?? [:]
        let email = hospitalData["email"] as? String ?? ""
        
        database.child("\(email)/incoming_appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let data = snapshot.value as? [[String: Any]] else{
                return
            }
            incomingAppointments = data
        })
        database.child("\(email)/booked_appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let data = snapshot.value as? [[String: Any]] else{
                return
            }
            bookedAppointments = data
        })
    }
    func acceptAppointment(){
        let hospitalData = appointmentData["hospital_data"] as? [String:Any] ?? [:]
        let email = hospitalData["email"] as? String ?? ""
        
        var requestedArr = [[String:Any]]()
        var bookedArr = [[String:Any]]()
        incomingAppointments.reverse()
        incomingAppointments.forEach{appointment in
            var newAppointment = appointment
            if newAppointment["appointmentId"] as? Int ?? 0 == appointmentData["appointmentID"] as? Int ?? 0{
                newAppointment["status"] = "accepted"
                bookedArr.append(newAppointment)
            }
            else{
                requestedArr.append(newAppointment)
            }
            
        }
        incomingAppointments = requestedArr
        incomingAppointments.reverse()
        bookedAppointments.append(contentsOf: bookedArr)
        database.child("\(email)/incoming_appointments").setValue(incomingAppointments,withCompletionBlock: {error, _ in
            guard error == nil else{
                print("Error in setting value in incoming appointments")
                return
            }
        })
        database.child("\(email)/booked_appointments").setValue(bookedAppointments,withCompletionBlock: {error, _ in
            guard error == nil else{
                print("Error in setting value in incoming appointments")
                return
            }
        })
    }
    func setAppointmentStatusOnPatientSide(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let appointmentArr = snapshot.value as? [[String:Any]] else{
                return
            }
            var changedAppointmentArr = [[String: Any]]()
            appointmentArr.forEach{appointment in
                var newAppointment = appointment
                if newAppointment["appointmentID"] as? Int ?? 0 == appointmentData["appointmentID"] as? Int ?? 0{
                    newAppointment["status"] = "accepted"
                }
                changedAppointmentArr.append(newAppointment)
            }
            database.child("\(safeEmail)/appointments").setValue(changedAppointmentArr,withCompletionBlock: {error, _ in
                guard error == nil else{
                    print("Error in setting value in appointments")
                    return
                }
                
            })
        })
    }
    @IBAction func btnSelectAnotherSlot(_ sender: Any) {
        
    }
    @IBAction func btnConfirmAppointment(_ sender: Any) {
        acceptAppointment()
        setAppointmentStatusOnPatientSide()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
