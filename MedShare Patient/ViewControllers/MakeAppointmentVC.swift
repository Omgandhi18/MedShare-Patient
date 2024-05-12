//
//  MakeAppointmentVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit

class MakeAppointmentVC: UIViewController {

    @IBOutlet weak var txtReasons: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTIme: UITextField!
    @IBOutlet weak var btnSendRequest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtReasons.layer.cornerRadius = 16
        txtReasons.layer.masksToBounds = true
        
        txtDate.layer.cornerRadius = 16
        txtDate.layer.masksToBounds = true
        
        txtTIme.layer.cornerRadius = 16
        txtTIme.layer.masksToBounds = true
        
        btnSendRequest.layer.cornerRadius = 25
        btnSendRequest.layer.masksToBounds = true
        btnSendRequest.layer.shadowColor = UIColor.black.cgColor
        btnSendRequest.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnSendRequest.layer.shadowRadius = 10
        btnSendRequest.layer.shadowOpacity = 0.25
        btnSendRequest.clipsToBounds = false
    }
    
    @IBAction func btnSendRequest(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "processingRequestStory") as! AppointmentLoadingVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

}
