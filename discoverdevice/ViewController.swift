//
//  ViewController.swift
//  discoverdevice
//
//  Created by Anujith on 18/06/22.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let reachability = try! Reachability()

        if reachability.connection == Reachability.Connection.unavailable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UserDefaults.standard.removeObject(forKey: "access_token")
                DatabaseHandler().deleteAllDatasFromCoreData()
                self.navigateToLogin()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.checkAccessToken()
            }
        }

    }
    
    func checkAccessToken() {
        if UserDefaults.standard.value(forKey: "access_token") != nil {
            self.navigateToHome()
        } else {
            self.navigateToLogin()
        }
    }
    
    func navigateToLogin() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func navigateToHome() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }


}

