
import Foundation

class Cloud {

    var container: CKContainer?
    var publicDB: CKDatabase?
    var privateDB: CKDatabase?
    
    func syncCloud(timerBox: TimerBox) {
        
        self.container = CKContainer.default()
        
        self.publicDB = self.container?.publicCloudDatabase
        self.privateDB = self.container?.privateCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "TimerBox", predicate: predicate)
        
        CKContainer.default().accountStatus { (accountStat, error) in
            if (accountStat == .available) {

                self.publicDB?.perform(query, inZoneWith: nil,//recordZone.zoneID,
                    completionHandler: ({results, error in
                        
                        if (error != nil) {
                            NSLog("%@", "Cloud Access Error")
                        } else {
                            if results!.count > 0 {
                                
                                
                                for result in results! as [CKRecord] {
                                    
                                    timerBox.addTimer(timerType: TimerCore.Status(rawValue: result.object(forKey: "timerStatus") as! Int)!, timerStamp: result.object(forKey: "timerStamp") as! TimeInterval, timerSpan: result.object(forKey: "timerSpan") as! TimeInterval)
                                    
                                    timerBox.timerBox[0].timerName = result.object(forKey: "timerName") as! String
                                }
                            } else {
                                NSLog("%@", "No match found")
                            }
                            
                            DispatchQueue.main.async() {
                                
                                //self.statusLabel?.text = "STARTING APPLICATION..."
                                //      delay(1.0) {
                                //self.performSegue(withIdentifier: "ControlPanelLoad", sender: self)
                                //    }
                            }
                        }
                    }))
            }
            else {
                //self.statusLabel?.text = "STARTING APPLICATION..."
                DispatchQueue.main.async() {
                    //self.performSegue(withIdentifier: "ControlPanelLoad", sender: self)
                }
            }
        }
    }}


class Model {
    
    // MARK: - Properties
    let EstablishmentType = "Establishment"
    let NoteType = "Note"
    static let sharedInstance = Model()
    //var delegate: ModelDelegate?
    var items: [Establishment] = []
    // let userInfo: UserInfo
    
    // Define databases.
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        //  userInfo = UserInfo(container: container)
    }
    
    @objc func refresh() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Establishment", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
            //        self.delegate?.errorUpdating(error! as NSError)
                    print("Cloud Query Error - Refresh: \(error)")
                }
                return
            }
            
            self.items.removeAll(keepingCapacity: true)
            
            for record in results! {
                let establishment = Establishment(record: record, database: self.publicDB)
                self.items.append(establishment)
            }
            
            DispatchQueue.main.async {
           //     self.delegate?.modelUpdated()
            }
        }
    }
    
    func establishment(_ ref: CKReference) -> Establishment! {
        let matching = items.filter { $0.record.recordID == ref.recordID }
        return matching.first
    }
    
    func fetchEstablishments(_ location:CLLocation, radiusInMeters:CLLocationDistance) {
        // 1
        let radiusInKilometers = radiusInMeters / 1000.0
        // 2
        let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location", location, radiusInKilometers)
        // 3
        let query = CKQuery(recordType: EstablishmentType, predicate: locationPredicate)
        // 4
        publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            if let error = error {
                DispatchQueue.main.async {
             //       self.delegate?.errorUpdating(error as NSError)
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            
            self.items.removeAll(keepingCapacity: true)
            results?.forEach({ (record: CKRecord) in
                self.items.append(Establishment(record: record,
                                                database: self.publicDB))
            })
            
            DispatchQueue.main.async {
             //   self.delegate?.modelUpdated()
            }
        }
    }
    
    func fetchEstablishments(_ location: CLLocation,
                             radiusInMeters: CLLocationDistance,
                             completion: @escaping (_ results: [Establishment]?, _ error: NSError?) -> ()) {
        
        let radiusInKilometers = radiusInMeters / 1000.0
        
        // Apple Campus location = 37.33182, -122.03118
        let location = CLLocation(latitude: 37.33182, longitude: -122.03118)
        let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location", location, radiusInKilometers)
        
        let query = CKQuery(recordType: EstablishmentType,
                            predicate:  locationPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            var res: [Establishment] = []
            
            defer {
                DispatchQueue.main.async {
                    completion(res, error as NSError?)
                }
            }
            
            guard let records = results else { return }
            
            for record in records {
                let establishment = Establishment(record: record , database:self.publicDB)
                res.append(establishment)
            }
        }
    }
    
    func fetchNotes(_ completion: @escaping (_ notes: [CKRecord]?, _ error: NSError?) -> () ) {
        
        let query = CKQuery(recordType: NoteType, predicate: NSPredicate(value: true))
        
        privateDB.perform(query, inZoneWith: nil) { results, error in
            completion(results, error as NSError?)
        }
    }
    
    func fetchNote(_ establishment: Establishment, completion:(_ note: String?, _ error: NSError?) ->()) {
        completion(nil, nil)
    }
    
    func addNote(_ note: String, establishment: Establishment!, completion: (_ error: NSError?)->()) {
        completion(nil)
    }
}


import Foundation
import UIKit
import CloudKit
import CoreLocation

func upload(_ db: CKDatabase,
            imageName: String,
            placeName: String,
            latitude:  CLLocationDegrees,
            longitude: CLLocationDegrees,
            healthy: Bool,
            kidsMenu: Bool,
            ratings: [UInt]) {
    
    let imURL = Bundle.main.url(forResource: imageName, withExtension: "jpeg")
    let coverPhoto = CKAsset(fileURL: imURL!)
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    let establishment = CKRecord(recordType: "Establishment")
    establishment.setObject(coverPhoto, forKey: "CoverPhoto")
    establishment.setObject(placeName as CKRecordValue?, forKey: "Name")
    establishment.setObject(location, forKey: "Location")
    establishment.setObject(healthy as CKRecordValue?, forKey: "HealthyOption")
    establishment.setObject(kidsMenu as CKRecordValue?, forKey: "KidsMenu")
    
    
    db.save(establishment, completionHandler: { record, error in
        
        guard error == nil else {
            print("error setting up record \(error)")
            return
        }
        
        print("saved: \(record)")
        
        for rating in ratings {
            
            let ratingRecord = CKRecord(recordType: "Rating")
            ratingRecord.setObject(rating as CKRecordValue?, forKey: "Rating")
            
            let ref = CKReference(record: record!, action: CKReferenceAction.deleteSelf)
            ratingRecord.setObject(ref, forKey: "Establishment")
            
            db.save(ratingRecord, completionHandler: { record, error in
                guard error == nil else {
                    print("error setting up record \(error)")
                    return
                }
            })
        }
        
    })
}

func doWorkaround() {
    
    let container = CKContainer.default()
    let db = container.publicCloudDatabase;
    
    // Apple Campus location = 37.33182, -122.03118
    
    upload(db, imageName: "pizza",
           placeName: "Ceasar's Pizza Palace",
           latitude: 37.332, longitude: -122.03,
           healthy: false,
           kidsMenu: true,
           ratings: [0, 1, 2])
    
    upload(db, imageName: "chinese",
           placeName: "King Wok",
           latitude: 37.1, longitude: -122.1,
           healthy: true,
           kidsMenu: false,
           ratings: [])
    
    upload(db, imageName: "steak",
           placeName: "The Back Deck",
           latitude: 37.4, longitude: -122.03,
           healthy: true,
           kidsMenu: true,
           ratings: [5, 5, 4])
}

import Foundation
import CloudKit
import MapKit

class Establishment: NSObject, MKAnnotation {
    
    var record: CKRecord!
    var name: String!
    var location: CLLocation!
    weak var database: CKDatabase!
    var assetCount = 0
    
    var healthyChoice: Bool {
        guard let hasHealthyChoice = record["HealthyOption"] as? NSNumber else { return false }
        return hasHealthyChoice.boolValue
    }
    
    var kidsMenu: Bool {
        guard let hasKidsMenu = record["KidsMenu"] as? NSNumber else { return false }
        return hasKidsMenu.boolValue
    }
    
    // MARK: - Map Annotation Properties
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String? {
        return name
    }
    
    // MARK: - Initializers
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        
        self.name = record["Name"] as? String
        self.location = record["Location"] as? CLLocation
    }
    
    func fetchRating(_ completion: @escaping (_ rating: Double, _ isUser: Bool) -> ()) {
        //   Model.sharedInstance.userInfo.userID() { [weak self] userRecord, error in
        //   self?.fetchRating(userRecord, completion: completion)
        // }
    }
    
    func fetchRating(_ userRecord: CKRecordID!, completion: (_ rating: Double, _ isUser: Bool) -> ()) {
        // Capability not yet implemented.
        completion(0, false)
    }
    
    func fetchNote(_ completion: @escaping (_ note: String?) -> ()) {
        Model.sharedInstance.fetchNote(self) { note, error in
            completion(note)
        }
    }
    
    func fetchPhotos(_ completion: @escaping (_ assets: [CKRecord]?) -> ()) {
        let predicate = NSPredicate(format: "Establishment == %@", record)
        let query = CKQuery(recordType: "EstablishmentPhoto", predicate: predicate)
        
        // Intermediate Extension Point - with cursors
        database.perform(query, inZoneWith: nil) { [weak self] results, error in
            defer {
                completion(results)
            }
            
            guard error == nil,
                let results = results else {
                    return
            }
            
            self?.assetCount = results.count
        }
    }
    
    //  func changingTable() -> ChangingTableLocation {
    //  let changingTable = record["ChangingTable"] as? NSNumber
    // var val: UInt = 0
    // guard let changingTableNum = changingTable else {
    // return ChangingTableLocation(rawValue: val)
    // }
    // val = changingTableNum.uintValue
    //return ChangingTableLocation(rawValue: val)
    // }
    
    // func seatingType() -> SeatingType {
    // let seatingType = record["SeatingType"] as? NSNumber
    // var val: UInt = 0
    // guard let seatingTypeNum = seatingType else {
    // return SeatingType(rawValue: val)
    // }
    // val = seatingTypeNum.uintValue
    // return SeatingType(rawValue: val)
    // }
    
    func loadCoverPhoto(completion:@escaping (_ photo: UIImage?) -> ()) {
        // 1
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            var image: UIImage!
            defer {
                completion(image)
            }
            // 2
            guard let asset = self.record["CoverPhoto"] as? CKAsset else {
                return
            }
            
            let imageData: Data
            do {
                imageData = try Data(contentsOf: asset.fileURL)
            } catch {
                return
            }
            image = UIImage(data: imageData)
        }
    }
}
