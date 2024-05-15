//
//  ConfirmVC.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit
import Lottie

class ConfirmVC: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var btnGoHome: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItems = []
        // hide the default back buttons
         self.navigationItem.hidesBackButton = true
        animationView.loopMode = .playOnce
        animationView.play()
        btnGoHome.makeButtonCurvedWithShadow(radius: 16)
    }

    @IBAction func btnGoHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
