//
//  MapViewController.swift
//  MyLocations
//
//  Created by 谢乾坤 on 4/19/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NSNotificationCenter.defaultCenter().addObserverForName(
                NSManagedObjectContextObjectsDidChangeNotification,
                object: managedObjectContext,
                queue: NSOperationQueue.mainQueue()){ notification in
                if self.isViewLoaded() {
                    self.updateLocations()
                }
            }
        }
    }
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        locations = try! managedObjectContext.executeFetchRequest( fetchRequest) as! [Location]
        mapView.addAnnotations(locations)
    }
    
    func regionForAnnotations(annotations: [MKAnnotation])
        -> MKCoordinateRegion {
            var region: MKCoordinateRegion
            switch annotations.count { case 0:
                region = MKCoordinateRegionMakeWithDistance( mapView.userLocation.coordinate, 1000, 1000)
            case 1:
                let annotation = annotations[annotations.count - 1]
                region = MKCoordinateRegionMakeWithDistance( annotation.coordinate, 1000, 1000)
            default:
                var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
                var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
                for annotation in annotations {
                    topLeftCoord.latitude = max(topLeftCoord.latitude,annotation.coordinate.latitude)
                    topLeftCoord.longitude = min(topLeftCoord.longitude,annotation.coordinate.longitude)
                    bottomRightCoord.latitude = min(bottomRightCoord.latitude,annotation.coordinate.latitude)
                    bottomRightCoord.longitude = max(bottomRightCoord.longitude,annotation.coordinate.longitude)
                }
                let center = CLLocationCoordinate2D( latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
                let extraSpace = 1.1
                let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace, longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
                region = MKCoordinateRegion(center: center, span: span)
            }
            return mapView.regionThatFits(region)
    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
        
    }
    
    
    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    @IBAction func showLocations() {
        let region = regionForAnnotations(locations)
        mapView.setRegion(region, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailsViewController
            controller.managedObjectContext = managedObjectContext
            
            let button = sender as! UIButton
            let location = locations[button.tag]
            controller.locationToEdit = location
        }
    }
    
    
    
}
extension MapViewController: MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 1  Because MKAnnotation is a protocol, there may be other objects apart from the Location object that want to be annotations on the map. An example is the blue dot that represents the user’s current location. You should leave such annotations alone, so you use the special “is” type check operator to determine whether the annotation is really a Location object. If it isn’t, you return nil to signal that you’re not making an annotation for this other kind of object.
        guard annotation is Location else {
            return nil
        }
        
        // 2 This looks similar to creating a table view cell. You ask the map view to re-use an annotation view object. If it cannot find a recyclable annotation view, then you create a new one.
        //Note that you’re not limited to using MKPinAnnotationView for your annotations. This is the standard annotation view class, but you can also create your own MKAnnotationView subclass and make it look like anything you want. Pins are only one option.
        let identifier = "Location"
        var annotationView =  mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            
            // 3 This sets some properties to configure the look and feel of the annotation view. Previously the pins were red, but you make them green here.
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            
            // 4  This is where it gets interesting. You create a new UIButton object that looks like a detail disclosure button (a blue circled i). You use the target-action pattern to hook up the button’s “Touch Up Inside” event with a new showLocationDetails() method, and add the button to the annotation view’s accessory view.
            let rightButton = UIButton(type: .DetailDisclosure)
            rightButton.addTarget(self, action: #selector(MapViewController.showLocationDetails(_:)), forControlEvents: .TouchUpInside)
            annotationView.rightCalloutAccessoryView = rightButton
        } else {
            annotationView.annotation = annotation
        }
        
        // 5 Once the annotation view is constructed and configured, you obtain a reference to that detail disclosure button again and set its tag to the index of the Location object in the locations array. That way you can find the Location object later in showLocationDetails() when the button is pressed.
        let button = annotationView.rightCalloutAccessoryView as! UIButton
        if let index = locations.indexOf(annotation as! Location) {
            button.tag = index
        }
        return annotationView
    }
    
    
}

extension MapViewController: UINavigationBarDelegate {
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}







