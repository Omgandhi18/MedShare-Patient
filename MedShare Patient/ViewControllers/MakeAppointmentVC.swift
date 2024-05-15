//
//  MakeAppointmentVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class MakeAppointmentVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var txtReasons: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTIme: UITextField!
    @IBOutlet weak var btnSendRequest: UIButton!
    
    var hospitalData = [String:Any]()
    var userData = [String: Any]()
    let database = Database.database().reference()
    var appointmentID = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtReasons.layer.cornerRadius = 16
        txtReasons.layer.masksToBounds = true
        
        txtDate.layer.cornerRadius = 16
        txtDate.layer.masksToBounds = true
        txtDate.addInputViewDatePicker(pickerMode: .date,target: self, selector: #selector(doneButtonDatePressed))
        
        txtTIme.layer.cornerRadius = 16
        txtTIme.layer.masksToBounds = true
        txtTIme.addInputViewDatePicker(pickerMode: .time, target: self, selector: #selector(doneButtonTimePressed))
        
        btnSendRequest.layer.cornerRadius = 25
        btnSendRequest.layer.masksToBounds = true
        btnSendRequest.layer.shadowColor = UIColor.black.cgColor
        btnSendRequest.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnSendRequest.layer.shadowRadius = 10
        btnSendRequest.layer.shadowOpacity = 0.25
        btnSendRequest.clipsToBounds = false
        getUserData()
    }
    func getUserData(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)").observeSingleEvent(of: .value, with: {[self] snapshot in
            if var data = snapshot.value as? [String:Any]{
                userData = data
            }
        })
    }
    func sendFirebaseData(){
        guard let reasons = txtReasons.text,
              let time = txtTIme.text,
              let date = txtDate.text else {
            return
        }
        if reasons.isEmpty{
            showToastAlert(strmsg: "Please enter reason for appointment", preferredStyle: .alert)
        }
        else if date.isEmpty{
            showToastAlert(strmsg: "Please select date of appointment", preferredStyle: .alert)
        }
        else if time.isEmpty{
            showToastAlert(strmsg: "Please select time of appointment", preferredStyle: .alert)
        }
        else{
            let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
            let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
            appointmentID = Int.random(in: 1000...9999)
            let hospitalNode = hospitalData["email"] as? String ?? ""
            database.child("\(hospitalNode)/incoming_appointments").observeSingleEvent(of: .value, with: {[self]snapshot in
                if var appointments = snapshot.value as? [[String:Any]]{
                    let newElement = [
                        "name":userData["full_name"] as? String ?? "",
                        "email": safeEmail,
                        "mobile_number": userData["mobile_number"] as? String ?? "",
                        "medical_info": userData["medical_info"] as? [String: Any] ?? [:],
                        "reasons": reasons,
                        "status": "requested",
                        "date_time": "\(date) \(time)",
                        "appointmentId":appointmentID
                    ]
                    appointments.reverse()
                    appointments.append(newElement)
                    appointments.reverse()
                    self.database.child("\(hospitalNode)/incoming_appointments").setValue(appointments,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            
                            return
                        }
                        self.addAppointmentIDToUserData(reasons: reasons, date: date, time: time)
                        
                    })
                }
                else{
                    let appointments:[[String: Any]] = [
                        [
                            "name":userData["full_name"] as? String ?? "",
                            "email": safeEmail,
                            "mobile_number": userData["mobile_number"] as? String ?? "",
                            "medical_info": userData["medical_info"] as? [String: Any] ?? [:],
                            "reasons": reasons,
                            "status": "requested",
                            "date_time": "\(date) \(time)",
                            "appointmentId":appointmentID
                        ]
                    ]
                    self.database.child("\(hospitalNode)/incoming_appointments").setValue(appointments,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            return
                        }
                        self.addAppointmentIDToUserData(reasons: reasons, date: date, time: time)
                        
                    })
                }
            })
        }
        
    }
    func addAppointmentIDToUserData(reasons:String, date: String, time: String){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            if var data = snapshot.value as? [[String:Any]]{
                let newElement = [
                    "appointmentID":appointmentID,
                    "hospital_data":hospitalData,
                    "reasons": reasons,
                    "status": "requested",
                    "date_time": "\(date) \(time)",
                ]
                data.reverse()
                data.append(newElement)
                data.reverse()
                self.database.child("\(safeEmail)/appointments").setValue(data,withCompletionBlock: {error, _ in
                    guard error == nil else{
                        
                        return
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "processingRequestStory") as! AppointmentLoadingVC
                    vc.appointmentID = self.appointmentID
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            else{
                let data:[[String: Any]] = [
                    [
                        "appointmentID":appointmentID,
                        "hospital_data":hospitalData,
                        "reasons": reasons,
                        "status": "requested",
                        "date_time": "\(date) \(time)",
                    ]
                ]
                self.database.child("\(safeEmail)/appointments").setValue(data,withCompletionBlock: {error, _ in
                    guard error == nil else{
                        return
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "processingRequestStory") as! AppointmentLoadingVC
                    vc.appointmentID = self.appointmentID
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
        })
    }
    @IBAction func btnSendRequest(_ sender: Any) {
        sendFirebaseData()
    }
    
    //MARK: Textfield methods
    
    @objc func doneButtonDatePressed() {
        if let  datePicker = self.txtDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.txtDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDate.resignFirstResponder()
     }
    @objc func doneButtonTimePressed() {
        if let  datePicker = self.txtTIme.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.txtTIme.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtTIme.resignFirstResponder()
     }

}
