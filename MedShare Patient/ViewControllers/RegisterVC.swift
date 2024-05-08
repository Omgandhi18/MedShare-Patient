//
//  RegisterVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 08/05/24.
//

import UIKit

class RegisterVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblSignInButton: UILabel!
    //MARK: Variables
    
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnContinue(_ sender: Any) {
    }
    

}
