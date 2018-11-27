//
//  Visit.swift
//  nightVisit
//
//  Created by Siddhant Gupta on 11/24/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import Foundation
class Visit{
    var longitude : Double?
    var latitude : Double?
    var arrivalTime : Date?
    var departureTime : Date?
    
    func setVisit(longitude: Double, latitude :Double, arrivalTime : Date?, departureTime : Date?)
    {
        self.longitude = longitude
        self.latitude = latitude
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
    }
}
