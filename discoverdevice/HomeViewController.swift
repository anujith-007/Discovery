//
//  HomeViewController.swift
//  discoverdevice
//
//  Created by Anujith on 21/06/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,NetServiceBrowserDelegate, NetServiceDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var discoveredArray: [DeviceModel] = []
    let bonjourBrowser = NetServiceBrowser()
    var discoveredService: NetService?
    var coreDataHasvalue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let array = DatabaseHandler().getDeviceData()
        if let deviceArray = array, deviceArray.count > 0 {
            discoveredArray = deviceArray
            coreDataHasvalue = true
            listTableView.reloadData()
            
        }
        bonjourBrowser.delegate = self
        startDiscovery()
    }
    
    func startDiscovery() {
        self.bonjourBrowser.searchForServices(ofType: "_airplay._tcp", inDomain: "local.")
    }
    
    // NetService Delegate and NetServiceBrowserDelegate    -----------------------------------------------------------------------
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("starting search..")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        discoveredService = service
        discoveredService?.delegate = self
        discoveredService?.resolve(withTimeout: 3)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print(errorDict)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        for i in 0..<discoveredArray.count {
            if discoveredArray[i].name == service.name {
                discoveredArray[i].status = "UnReachable"
            }
        }
        listTableView.reloadData()
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        guard let data = sender.addresses?.first else { return }
        do {
            try data.withUnsafeBytes { (pointer:UnsafePointer<sockaddr>) -> Void in
            //try data.withUnsafeBytes( { (pointer : UnsafeRawBufferPointer)-> Void in
                guard getnameinfo(pointer, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    throw NSError(domain: "domain", code: 0, userInfo: ["error":"unable to get ip address"])
                }
            }
        } catch {
            print(error)
            return
        }
        let address = String(cString:hostname)
        print("\(sender.name)  IP:\(address)")
        var device = DeviceModel()
        device.name = sender.name
        device.iPAddress = address
        device.status = "Reachable"
        if coreDataHasvalue {
            updateDeviceStatus(deviceData:device)
        } else {
            discoveredArray.append(device)
            device.status = "UnReachable"
            DatabaseHandler().saveDeviceData(data: device)
            self.listTableView.reloadData()
        }
        
        discoveredService = nil
    }
    
    func updateDeviceStatus(deviceData:DeviceModel) {
        do {
            let fetchRequest: NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Device")
                
            fetchRequest.predicate = NSPredicate(format: "name = %@", deviceData.name!)
            
            let fetchedResults = try DatabaseHandler().viewContext.fetch(fetchRequest)
            if fetchedResults.count != 0{

                for i in 0..<discoveredArray.count {
                    if discoveredArray[i].name == deviceData.name {
                        discoveredArray[i].status = "Reachable"
                    }
                }
            } else {
                var objct = deviceData
                objct.status = "UnReachable"
                discoveredArray.append(deviceData)
                DatabaseHandler().saveDeviceData(data: deviceData)
            }
            self.listTableView.reloadData()
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    // TableView Delegate and Data source     --------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let device = discoveredArray[indexPath.row]
        cell.nameLabel.text = device.name
        cell.ipAddressLabel.text = device.iPAddress
        cell.statusLabel.text = device.status
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
       
    }

}

class ListTableViewCell:UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
