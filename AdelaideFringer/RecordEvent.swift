//
//  RecordEvent.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 25/10/20.
//

import UIKit
import CoreData


class RecordEvent{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var eventsModel:[IndexOfEvents]?
    
    var eventslikes = [Int]()
    var eventsinterested = [Int]()

    
    //retrieve data
    func fetchEvents() {
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            
            //remove all data from eventslikes and eventsinterested
            eventslikes.removeAll()
            eventsinterested.removeAll()
            eventsModel = try context.fetch(IndexOfEvents.fetchRequest())
            for each in 0...10 {
                if (eventsModel?.count != 0){
                    eventslikes.append(Int(eventsModel![each].indexLikes))
                    eventsinterested.append(Int(eventsModel![each].indexList))
                    indexlikes = eventslikes
                    indexList = eventsinterested
                }

                

            }
        } catch {
            print("Failed")
        }


    }


    //save data

    func save(_ newlike: Int, _ newinterestedEvent:Int){
        if eventsModel?.count != 11{
            let context = appDelegate.persistentContainer.viewContext
            let newLikes = IndexOfEvents(context: context)
            newLikes.indexLikes = Int16(newlike)
            newLikes.indexList = Int16(newinterestedEvent)

            do {

                try context.save()
            } catch {
                print("Failed saving")
            }
        }

    }
    
    //update all data with the changeIndex

    func change(_ changeIndex: Int, _ newlike: Int, _ newinterestedEvent:Int){
        let context = appDelegate.persistentContainer.viewContext
        let event = eventsModel![changeIndex]
        event.indexLikes = Int16(newlike)
        event.indexList = Int16(newinterestedEvent)
        do {

            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    //update the interested events with the changeIndex
    func changeIndexList(changeIndex: Int, newinterestedEvent:Int){
        let context = appDelegate.persistentContainer.viewContext
        
        let event = eventsModel![changeIndex]
        
        event.indexList = Int16(newinterestedEvent)
        do {

            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
    }


}
