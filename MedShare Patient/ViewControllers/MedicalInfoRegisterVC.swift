//
//  MedicalInfoRegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit

class MedicalInfoRegisterVC: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var txtAge: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtAllergies: UITextField!
    @IBOutlet weak var txtBloodGroup: UITextField!
    
    @IBOutlet weak var txtInsurance: UITextField!
  
    @IBOutlet weak var btnRegister: UIButton!
    
    //MARK: Variables
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        
    }
}
