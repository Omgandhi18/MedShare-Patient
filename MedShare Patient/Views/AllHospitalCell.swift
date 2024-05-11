//
//  AllHospitalCell.swift
//  MedShare Patient
//
//  Created by Om Gandhi on 11/05/24.
//

import UIKit

class AllHospitalCell: UITableViewCell {

    @IBOutlet weak var btnDirections: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnMakeAppointment: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
