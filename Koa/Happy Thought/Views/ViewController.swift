//
//  ViewController.swift
//  Koa
//
//  Created by Siddhant Gupta on 10/15/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Lottie
class ViewController: UIViewController {
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var dateWasSaved : Bool?
    var happyAnimationView : LOTAnimationView?
    var sadAnimationView : LOTAnimationView?
    var loginShown  = 0
    var animationAdded = 0
    @IBAction func sadButton(_ sender: Any) {   //sad thought for the day
        if (self.happyAnimationView != nil)
        {
            self.happyAnimationView?.removeFromSuperview()
            self.happyAnimationView = nil
        }
        if (self.sadAnimationView != nil)
        {
            self.sadAnimationView?.removeFromSuperview()
            self.sadAnimationView = nil
        }
        networkManager.sharedInstance.putHappySad(feeling: "Sad")
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func happyButton(_ sender: Any) {     //happy thought for the day
        if (self.happyAnimationView != nil)
        {
            self.happyAnimationView?.removeFromSuperview()
            self.happyAnimationView = nil
        }
        if (self.sadAnimationView != nil)
        {
            self.sadAnimationView?.removeFromSuperview()
            self.sadAnimationView = nil
        }
      networkManager.sharedInstance.putHappySad(feeling: "Happy")
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
        
    }
    
    //handling taps on both views
    @objc func handleHappyTap(_ sender: UITapGestureRecognizer) {
        if (self.happyAnimationView != nil)
        {
            self.happyAnimationView?.removeFromSuperview()
            self.happyAnimationView = nil
        }
        if (self.sadAnimationView != nil)
        {
            self.sadAnimationView?.removeFromSuperview()
            self.sadAnimationView = nil
        }
        networkManager.sharedInstance.putHappySad(feeling: "Happy")
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
    }
    
    @objc func handleSadTap(_ sender: UITapGestureRecognizer) {
        if (self.happyAnimationView != nil)
        {
            self.happyAnimationView?.removeFromSuperview()
            self.happyAnimationView = nil
        }
        if (self.sadAnimationView != nil)
        {
            self.sadAnimationView?.removeFromSuperview()
            self.sadAnimationView = nil
        }
        networkManager.sharedInstance.putHappySad(feeling: "Sad")
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
    }
    
    //If user wanted more images for the day
    @IBAction func addButtonTap(_ sender: Any) {
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If Happy sad response is received just show landing page animation
        let defaults = UserDefaults.standard
        addButton.layer.cornerRadius = 30
        let date = NSDate(timeIntervalSince1970: TimeInterval(defaults.integer(forKey: "lastFeelingSet")))
        if (Calendar.current.isDateInToday(date as Date)) {
            let fullScreenAnimationView = LOTAnimationView(name: "duck_blue_style")
            fullScreenAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //  animationView.center = self.view.center
            fullScreenAnimationView.contentMode = .scaleAspectFit
            fullScreenAnimationView.loopAnimation = true
            fullScreenAnimationView.play()
            view.addSubview(fullScreenAnimationView)
            happyButton.isHidden = true
            sadButton.isHidden = true
            self.view.bringSubviewToFront(addButton)
            self.dateWasSaved = true
        }
        else{
            self.dateWasSaved = false
           // happyButton.backgroundColor = UIColor(red: 248, green: 67.0, blue: 83)
            happyAnimationView = LOTAnimationView(name: "heart_animation")
            happyButton.backgroundColor = UIColor(
                red: CGFloat( 248/255.0),
                green: CGFloat(67/255.0),
                blue: CGFloat(83/255.0),
                alpha: CGFloat(1.0)
            )
            happyAnimationView?.frame = CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
         //   animationView.center = self.view.center
            happyAnimationView?.contentMode = .scaleAspectFit
            happyAnimationView?.loopAnimation = true
            view.addSubview(happyAnimationView!)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleHappyTap(_:)))
            
            happyAnimationView?.addGestureRecognizer(tap)
            
            happyAnimationView?.isUserInteractionEnabled = true
            happyAnimationView?.play()
        
           
            sadAnimationView = LOTAnimationView(name: "unhappy_french_fries")
            sadAnimationView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
          //  animationView.center = self.view.center
            sadAnimationView!.contentMode = .scaleAspectFit
            sadAnimationView?.loopAnimation = true
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleSadTap(_:)))
            
            sadAnimationView?.addGestureRecognizer(tap2)
            
            sadAnimationView?.isUserInteractionEnabled = true
            
            view.addSubview(sadAnimationView!)
            
            sadAnimationView?.play()
            addButton.isHidden = true
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let uID : String? = defaults.string(forKey: "uID")
        //Adding this becuase APPLE was adamant that there needs to be an option for the user to not login even though the app is pretty much useless without that. HERE YOU GO
        if ( uID == nil && loginShown == 1 && animationAdded == 0)
        {
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            let fullScreenAnimationView = LOTAnimationView(name: "duck_blue_style")
            fullScreenAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //  animationView.center = self.view.center
            fullScreenAnimationView.contentMode = .scaleAspectFit
            fullScreenAnimationView.loopAnimation = true
            fullScreenAnimationView.play()
            view.addSubview(fullScreenAnimationView)
            let signUpbutton = UIButton(frame: CGRect(x: 10, y: 100, width: self.view.frame.width - 20, height: 100))
            signUpbutton.backgroundColor = UIColor(red: 118/255, green: 214/255, blue: 255/255, alpha: 1)

            signUpbutton.setTitle("Signup", for: .normal)
            signUpbutton.setTitleColor(UIColor.black, for: .normal)
            signUpbutton.titleLabel?.font = .systemFont(ofSize: 23)
            signUpbutton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            signUpbutton.layer.cornerRadius = 20
            signUpbutton.clipsToBounds = true
            self.view.addSubview(signUpbutton)
            animationAdded = 1
        }
        if (uID == nil && loginShown == 0)
        {
            let loginViewController:loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            
            self.present(loginViewController, animated: true, completion: nil)
            loginShown = 1
            
            
            
        }
        
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(defaults.integer(forKey: "lastFeelingSet")))
        if (Calendar.current.isDateInToday(date as Date) && dateWasSaved != true && animationAdded == 0) {
            let fullScreenAnimationView = LOTAnimationView(name: "duck_blue_style")
            fullScreenAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            //  animationView.center = self.view.center
            fullScreenAnimationView.contentMode = .scaleAspectFit
            fullScreenAnimationView.loopAnimation = true
            fullScreenAnimationView.play()
            view.addSubview(fullScreenAnimationView)
            animationAdded = 1
            happyButton.isHidden = true
            sadButton.isHidden = true
            self.view.bringSubviewToFront(addButton)

        }
    }
    
    //Shwoing login
    @objc func buttonAction(sender: UIButton!) {
        let loginViewController:loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        
        self.present(loginViewController, animated: true, completion: nil)
        loginShown = 1
    }
}

