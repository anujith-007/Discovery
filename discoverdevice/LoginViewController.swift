//
//  LoginViewController.swift
//  discoverdevice
//
//  Created by Anujith on 18/06/22.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var singInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    @IBAction func singInButtonClicked(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: "1079337906273-qbil7i1fpeu3j6dn6k6u4dfbgubkeq3c.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }

            //let userId = user?.userID                  // For client-side use only!
            let idToken = user?.authentication.idToken
            print(idToken as Any)
            UserDefaults.standard.setValue(idToken!, forKey: "access_token")
            print("success")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
