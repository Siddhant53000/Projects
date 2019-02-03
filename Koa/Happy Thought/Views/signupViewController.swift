//
//  signupViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/23/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Firebase
import Lottie
class signupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = LOTAnimationView(name: "bms-rocket")
        animationView.frame = CGRect(x: 0, y: 0, width: self.animationView.frame.width, height: self.animationView.frame.height)
        //  animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
  //      animationView.layer.cornerRadius = min(signupAnimationView.frame.size.height, signupAnimationView.frame.size.width) / 2.0
        animationView.clipsToBounds = true
        self.animationView.addSubview(animationView)
        self.animationView.backgroundColor = UIColor.clear
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        animationView.play()
        signupBtn.layer.cornerRadius = 20
        signupBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) { (authResult, error) in
            
            if (authResult == nil)
            {
                let alert = UIAlertController(title: "Sorry! invalid email or password", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    return
                }))
                
                self.present(alert, animated: true)
                return
            }
            Auth.auth().currentUser!.sendEmailVerification(completion: nil)
            Auth.auth().signIn(withEmail: self.usernameField.text!, password: self.passwordField.text!) { (user, error) in
                
                let userID = Auth.auth().currentUser!.uid
                let defaults = UserDefaults.standard
                defaults.set(userID, forKey: "uID")
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func cancelSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
