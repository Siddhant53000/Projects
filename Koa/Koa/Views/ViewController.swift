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
    
    @IBAction func sadButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        var sad = defaults.integer(forKey: "sad")
        sad += 1
        defaults.set(sad, forKey: "sad")
        print(sad)
        print(defaults.integer(forKey: "sad") )
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func happyButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        var happy = defaults.integer(forKey: "happy")
        happy += 1
        defaults.set(happy, forKey: "happy")
        print(happy)
        print(defaults.integer(forKey: "happy") )
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
        
    }
    @objc func handleHappyTap(_ sender: UITapGestureRecognizer) {
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
    }
    
    @objc func handleSadTap(_ sender: UITapGestureRecognizer) {
        let mViewController:mediaViewController = storyboard?.instantiateViewController(withIdentifier: "mediaViewController") as! mediaViewController
        
        self.present(mViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // happyButton.backgroundColor = UIColor(red: 248, green: 67.0, blue: 83)
        let happyAnimationView = LOTAnimationView(name: "heart_animation")
        happyButton.backgroundColor = UIColor(
            red: CGFloat( 248/255.0),
            green: CGFloat(67/255.0),
            blue: CGFloat(83/255.0),
            alpha: CGFloat(1.0)
        )
        happyAnimationView.frame = CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
     //   animationView.center = self.view.center
        happyAnimationView.contentMode = .scaleAspectFit
        happyAnimationView.loopAnimation = true
        view.addSubview(happyAnimationView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleHappyTap(_:)))
        
        happyAnimationView.addGestureRecognizer(tap)
        
        happyAnimationView.isUserInteractionEnabled = true
        happyAnimationView.play()
    
       
        let sadAnimationView = LOTAnimationView(name: "unhappy_french_fries")
        sadAnimationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
      //  animationView.center = self.view.center
        sadAnimationView.contentMode = .scaleAspectFit
        sadAnimationView.loopAnimation = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleSadTap(_:)))
        
        sadAnimationView.addGestureRecognizer(tap2)
        
        sadAnimationView.isUserInteractionEnabled = true
        
        view.addSubview(sadAnimationView)
        
        sadAnimationView.play()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let uID : String? = defaults.string(forKey: "uID")
        if (uID == nil)
        {
            let loginViewController:loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}

