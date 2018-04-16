//
//  HealthKitServices.swift
//  etiqasteps
//
//  Created by John Cheang on 12/04/2018.
//  Copyright © 2018 John Cheang. All rights reserved.
//

import HealthKit

class HealthKitServices {
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        }else {
            return nil
        }
    }()
    
    internal static func retrieveStepCount(completionHandler:@escaping (Double?, NSError?)->()){
        
        let healthStore = HKHealthStore()
        
        let calendar = NSCalendar.current
        
        let now = NSDate()
        
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: now as Date)
        
        let startDate = calendar.date(from: components)
        
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate!, wrappingComponents: false)
        
        let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: sampleType!, quantitySamplePredicate: predicate, options: .cumulativeSum){query, results, error in
            
            guard let results = results else {
                completionHandler(0.0, (error as! NSError))
                return
            }
            guard let totalSteps = results.sumQuantity() else {
                completionHandler(0.0, nil)
                return
            }
            DispatchQueue.main.async {
                completionHandler(totalSteps.doubleValue(for: HKUnit.count()), nil)
            }
        }
        
        healthStore.execute(query)
    }
}

