//
//  nightVisitMinutesCalculator.swift
//  nightVisit
//
//  Created by Siddhant Gupta on 11/26/18.
//  Copyright © 2018 Siddhant Gupta. All rights reserved.
//

import Foundation
class nightVisitMinutesCalculator {
    
    func minutesSpent(visit : Visit) -> (Double){
        if (visit.arrivalTime == nil || visit.departureTime == nil)
        {
            return -1;
        }
        let calendar = Calendar.current
        let arrivalHour = calendar.component(.hour, from: visit.arrivalTime!)       //The hour of the arrival time
        let departureHour = calendar.component(.hour, from: visit.departureTime!)  //The hour of departure time
        var extraMinutes = 0.0
        let minutesInHour = 60.0                                                    //Number of minutes in an hour
        let stayDuration = visit.departureTime!.timeIntervalSince(visit.arrivalTime!) //calculate duration the stay lasted
        // If start time is after end time, return -1
        if (stayDuration < 0)
        {
            return -1.0
        }
        //truncating start time and end time to relevant times for calcualtion. See methods for further explanation
        let truncatedArrivalTime = truncateArrivalTime(arrivalTime: visit.arrivalTime!)
        let truncatedDepartureTime = truncateDepartureTime(departureTime: visit.departureTime!)
        
        
        var arrivalTimeAfterCountingExtraHours = truncatedArrivalTime     //For calculation of duration of stay excluding extra hours from arrival date
        var departureTimeAfterCountingExtraHours = truncatedDepartureTime //For calculation of duration of stay excluding extra hours from departure date
        var dateAfterArrivalDate = truncatedArrivalTime
        //If the arrival was after 8pm, set the arrival date to the next day at 8pm and add the difference to extraHours
        if (arrivalHour >= 20)
        {
            dateAfterArrivalDate = calendar.date(byAdding: .day, value: 1, to: truncatedArrivalTime)!
            let arrivalTimeEndForFirstDay = calendar.date(bySettingHour: 8, minute: 00, second: 0, of: dateAfterArrivalDate)
            extraMinutes += arrivalTimeEndForFirstDay!.timeIntervalSince(truncatedArrivalTime)/minutesInHour
            arrivalTimeAfterCountingExtraHours = arrivalTimeEndForFirstDay!
        }
        else{   //If arrival hour was between midnight and 8am, arrival date is already correct so set arrival time to 8am and add the difference to extraHours
            dateAfterArrivalDate = truncatedArrivalTime
            let arrivalTimeEndForFirstDay = calendar.date(bySettingHour: 8, minute: 00, second: 0, of: dateAfterArrivalDate)
            extraMinutes += arrivalTimeEndForFirstDay!.timeIntervalSince(truncatedArrivalTime)/minutesInHour
            arrivalTimeAfterCountingExtraHours = arrivalTimeEndForFirstDay!
            
        }
        //If the departure hour is between midnight and 8am, bring departure date to 8am of same day and subtract from extraHours
        if (departureHour <= 8){
            let departureTimeStartForLastDay = calendar.date(bySettingHour: 08, minute: 00, second: 0, of: truncatedDepartureTime)
            departureTimeAfterCountingExtraHours = departureTimeStartForLastDay!
            extraMinutes -= departureTimeStartForLastDay!.timeIntervalSince(truncatedDepartureTime)/minutesInHour
        }
        else{   //If the departure hour is between 8pm to midnight, bring to 8am of same day and add number of hours between 8pm to departure time to extraTime
            let departureTimeStartForLastDay = calendar.date(bySettingHour: 20, minute: 00, second: 0, of: truncatedDepartureTime)
            extraMinutes += truncatedDepartureTime.timeIntervalSince(departureTimeStartForLastDay!)/minutesInHour
            departureTimeAfterCountingExtraHours = calendar.date(bySettingHour: 08, minute: 00, second: 0, of: truncatedDepartureTime)!
        }
        //Once the excess departure and arrival times have been stored, find the difference between arrival and departure hours and divide by 2
        var totalTimeSpentInMinutes = departureTimeAfterCountingExtraHours.timeIntervalSince(arrivalTimeAfterCountingExtraHours)/60
        totalTimeSpentInMinutes /= 2
        //Add the extraHours to the timeSpentInMinutes
        totalTimeSpentInMinutes += extraMinutes
        
        
        return totalTimeSpentInMinutes
    }
    
    
    
    //if the arrival time is before 8pm, ignore time before 8 pm and set the arrival time to 8pm
    func truncateArrivalTime(arrivalTime: Date) -> (Date){
        let calendar = Calendar.current
        let arrivalHour = calendar.component(.hour, from: arrivalTime)
        var mutableArrivalTime = arrivalTime
        
        if (arrivalHour < 20 && arrivalHour >= 8)
        {
            mutableArrivalTime = calendar.date(bySettingHour: 20, minute: 00, second: 0, of: arrivalTime)!
            return mutableArrivalTime
        }
        
        return arrivalTime
    }
    
    
    //if the departure time is after 8am, ignore time after 8 am and set the departure time to 8am
    func truncateDepartureTime(departureTime: Date) -> (Date){
        let calendar = Calendar.current
        let departureHour = calendar.component(.hour, from: departureTime)
        var mutabledepartureTime = departureTime
        
        if (departureHour >= 8 && departureHour < 20)
        {
            mutabledepartureTime = calendar.date(bySettingHour: 8, minute: 00, second: 0, of: departureTime)!
            return mutabledepartureTime
        }
        
        return departureTime
    }
    
}

