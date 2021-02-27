//
//  File.swift
//  Adelaide Fringe
//
//  Created by Fan Liang on 28/10/20.
//

import Foundation
import CoreData

@objc(IndexOfEvents)
public class IndexOfEvents: NSManagedObject{
    
}

extension IndexOfEvents {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<IndexOfEvents> {
        return NSFetchRequest<IndexOfEvents>(entityName: "IndexOfEvents")
    }
    
    @NSManaged public var indexLikes: Int16
    @NSManaged public var indexList: Int16
}
