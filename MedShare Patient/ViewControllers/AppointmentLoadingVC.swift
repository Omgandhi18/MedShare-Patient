//
//  AppointmentLoadingVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit
import Lottie

class AppointmentLoadingVC: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.loopMode = .loop
        animationView.play()
        // Do any additional setup after loading the view.
    }
    


}
