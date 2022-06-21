//
//  DetailsViewController.swift
//  discoverdevice
//
//  Created by Anujith on 21/06/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var ipDataModel = PublicIPModel()
    var ipDetailsModel = IPDetailsModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager().fetchPublicIP { (model) in
            self.ipDataModel = model
            if let ipAddress = model.ip {
                self.fetchIPDetailsAPI(ip:ipAddress)
            }
        }
    }
    
    func fetchIPDetailsAPI(ip:String) {
        NetworkManager().fetchPublicIPDetails(ipAddress: ip)  { (model) in
            self.ipDetailsModel = model
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        ipAddressLabel.text = ipDetailsModel.ip
        cityLabel.text = ipDetailsModel.city
        regionLabel.text = ipDetailsModel.region
        countryLabel.text = ipDetailsModel.country
        organizationLabel.text = ipDetailsModel.org
        locationLabel.text = ipDetailsModel.loc
    }

}
