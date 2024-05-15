//
//  AppointmentCell.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 12/05/24.
//

import UIKit

class AppointmentCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var btnDirections: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblReasons: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
