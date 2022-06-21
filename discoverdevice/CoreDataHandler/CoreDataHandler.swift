//
//  CoreDataHandler.swift
//  discoverdevice
//
//  Created by Anujith on 21/06/22.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {
    
    let viewContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func insert<T: NSManagedObject>(object: T) {
        let context = viewContext
        
        context.insert(object)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func saveDeviceData(data: DeviceModel) {
        let context: NSManagedObjectContext = viewContext

        let entityDescription: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Device", in: context)!

        let deviceInfoEntry: NSManagedObject = NSManagedObject(entity: entityDescription, insertInto: context)

        //Set your values here
        deviceInfoEntry.setValue(data.name, forKey: "name")
        deviceInfoEntry.setValue(data.iPAddress, forKey: "ip")
        deviceInfoEntry.setValue(data.status, forKey: "status")

        //Then save
        save()
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
            //Error handling
        }
    }
    
    public func getDeviceData() -> [DeviceModel]? {
        let deviceDataFetchRequest: NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Device")
        do {
            var deviceArray = [DeviceModel]()
            let fetchedData: [Any] = try viewContext.fetch(deviceDataFetchRequest)
            let deviceDataObjectArray: [NSManagedObject] = fetchedData as! [NSManagedObject]
            for device in deviceDataObjectArray {
                var deviceData: DeviceModel = DeviceModel()
                deviceData.name = device.value(forKey: "name") as? String
                deviceData.iPAddress = device.value(forKey: "ip") as? String
                deviceData.status = device.value(forKey: "status") as? String
                deviceArray.append(deviceData)
            }
            return deviceArray
        } catch {
            //Handle errors
            return nil
        }
    }
    
    
    func deleteAllDatasFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Device")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            save()
        } catch let error as NSError {
            // TODO: handle the error
            print("error")
        }
    }
    
    
}

