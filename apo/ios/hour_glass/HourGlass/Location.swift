
import Foundation

//let message: String
//if error.code == 1 {
//  message = "Log into iCloud on your device and make sure the iCloud drive is turned on for this app."
//} else {
//  message = error.localizedDescription
//}
//let alertController = UIAlertController(title: nil,
//message: message,
// preferredStyle: .alert)

//alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

//present(alertController, animated: true, completion: nil)



//extension MasterViewController: CLLocationManagerDelegate {

//   func setupLocationManager() {
//       locationManager = CLLocationManager()
//     locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

// Only look at locations within a 0.5 km radius.
//   locationManager.distanceFilter = 500.0
// locationManager.delegate = self

// CLLocationManager.authorizationStatus()
// }

// func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)  {
//  switch status {
//  case .notDetermined:
//    manager.requestWhenInUseAuthorization()
//  case .authorizedWhenInUse:
//      manager.startUpdatingLocation()
//    default:
// Do nothing.
//      print("Other status")
//    }
//  }

//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//  guard let location = locations.last else { return }

//    model.fetchEstablishments(location, radiusInMeters: 3000)
//  }
//}


import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    fileprivate let pinIdentifier = "Pin"
    
    @IBOutlet var mapView: MKMapView!
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let region = mapView.region
        
        let cla = round(region.center.latitude * 100.0) / 100.0
        let clo = round(region.center.longitude * 100.0) / 100.0
        let center = CLLocation(latitude:  cla, longitude: clo)
        
        // This works for the US hemisphere.
        let upperLeft = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta,
                                                   region.center.longitude + region.span.longitudeDelta)
        let corner = CLLocation(latitude:  upperLeft.latitude,
                                longitude: upperLeft.longitude)
        let distance = center.distance(from: corner)
        let mapCenter = CLLocation(coordinate: mapView.centerCoordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
        
        Model.sharedInstance.fetchEstablishments(mapCenter, radiusInMeters: distance) { [weak self] results, error in
            guard let error = error else {
                mapView.removeAnnotations(mapView.annotations);
                if let results = results {
                    mapView.addAnnotations(results)
                }
                return
            }
            
            let alertController = UIAlertController(title: "Error Loading Establishments",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pinView?.canShowCallout = true
        }
        
        pinView?.annotation = annotation
        
        guard let establishment = annotation as? Establishment else { return pinView }
        
        establishment.loadCoverPhoto { photo in
            guard let photo = photo else { return }
            UIGraphicsBeginImageContext(CGSize(width: 30, height: 30))
            photo.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imView = UIImageView(image: smallImage)
            pinView!.leftCalloutAccessoryView = imView
        }
        
        return pinView
    }
}
