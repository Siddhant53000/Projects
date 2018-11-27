//
//  ViewController.swift
//  nightVisit
//
//  Created by Siddhant Gupta on 11/24/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let visit = Visit()
        
        
        let startTime = "11/21/2015 7:22:00" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss" //Your date format
        let startDate = dateFormatter.date(from: startTime)
        let endTime = "11/21/2015 8:22:35" // change to your date format
        let endDate = dateFormatter.date(from: endTime)
        visit.setVisit(longitude: 10.0, latitude: 10.0, arrivalTime: startDate, departureTime: endDate)
        //print  (minutesSpent(visit: visit))
        let night = nightVisitMinutesCalculator()
        print (night.minutesSpent(visit: visit))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
  

}

