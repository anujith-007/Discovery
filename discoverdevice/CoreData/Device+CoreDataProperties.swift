//
//  Device+CoreDataProperties.swift
//  discoverdevice
//
//  Created by Anujith on 21/06/22.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var name: String?
    @NSManaged public var ip: String?
    @NSManaged public var status: String?

}

extension Device : Identifiable {

}
