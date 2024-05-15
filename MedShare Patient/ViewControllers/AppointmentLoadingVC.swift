//
//  AppointmentLoadingVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseDatabase

class AppointmentLoadingVC: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    
    var appointmentID = 0
    let database = Database.database().reference()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItems = []
        // hide the default back buttons
         self.navigationItem.hidesBackButton = true
        animationView.loopMode = .loop
        animationView.play()
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {[self] _ in
            getAppointmentDetail()
            })
       
        // Do any additional setup after loading the view.
    }
    func getAppointmentDetail(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            if let data = snapshot.value as? [[String:Any]]{
                var appointment = data.first(where: {$0["appointmentID"] as? Int == appointmentID})
                if appointment?["status"] as? String == "accepted"{
                    timer.invalidate()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirmStory") as! ConfirmVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if appointment?["status"] as? String == "change sent"{
                    timer.invalidate()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "adjustAppointmentStory") as! AdjustAppointmentVC
                    vc.appointmentData = appointment ?? [:]
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        })
    }


}
