//
//  loginViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/19/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Firebase
import Lottie
class loginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var signupLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let signupAnimationView = LOTAnimationView(name: "soda_loader")
        signupAnimationView.frame = CGRect(x: 0, y: 0, width: self.signupView.frame.width, height: self.signupView.frame.height)
        //  animationView.center = self.view.center
        signupAnimationView.contentMode = .scaleAspectFit
        signupAnimationView.loopAnimation = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleSignupTap(_:)))
        
        signupAnimationView.addGestureRecognizer(tap2)
        
        signupAnimationView.isUserInteractionEnabled = true
        signupAnimationView.backgroundColor = UIColor.orange
        signupAnimationView.layer.cornerRadius = min(signupAnimationView.frame.size.height, signupAnimationView.frame.size.width) / 2.0
        signupAnimationView.clipsToBounds = true
        signupView.addSubview(signupAnimationView)
        
        signupAnimationView.play()
        
        
        let animationView = LOTAnimationView(name: "rocket")
        animationView.frame = CGRect(x: 0, y: 0, width: self.animationView.frame.width, height: self.animationView.frame.height)
        //  animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.layer.cornerRadius = min(signupAnimationView.frame.size.height, signupAnimationView.frame.size.width) / 2.0
        animationView.clipsToBounds = true
        self.animationView.addSubview(animationView)
        self.animationView.backgroundColor = UIColor.clear
        
        animationView.play()
        signupView.bringSubviewToFront(signupLabel)
        
        // Do any additional setup after loading the view.
    }
   
    @objc func handleSignupTap(_ sender: UITapGestureRecognizer) {
        let sViewController:signupViewController = storyboard?.instantiateViewController(withIdentifier: "signupViewController") as! signupViewController
        
        self.present(sViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
       
        Auth.auth().signIn(withEmail: self.usernameField.text!, password: self.passwordField.text!) { (user, error) in
            
            let userID = Auth.auth().currentUser!.uid
            let defaults = UserDefaults.standard
            defaults.set(userID, forKey: "uID")
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
