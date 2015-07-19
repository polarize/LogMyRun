//
//  NewRunViewController.swift
//  LogMyRun
//
//  Created by Issam on 18/07/15.
//  Copyright © 2015 codemysource. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import HealthKit


class IBNewRunViewController: UIViewController {

    var managedObjectContext : NSManagedObjectContext?
    var run:Run!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var seconds = 0.0
    var distance = 0.0
    
    lazy var locationManager : CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        //Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        
        return _locationManager
        
    }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        // Do any additional setup after loading the view.
    }
    
    func initUI()
    {
        timeLabel.text = "00:00:00"
        distanceLabel.text = "--"
        paceLabel.text = "--"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switchButtonsWithStartState(true)
        
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func startAction(sender: UIButton)
    {
       switchButtonsWithStartState(false)
        
       seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        
        startLocation()
    }
    
    
    @IBAction func stopAction(sender: UIButton)
    {
        //switchButtonsWithStartState(true)
        
        let actionSheetController = UIAlertController (title: "Run Stopped", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Add Cancle-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (actionSheetController) -> Void in
            print("Save ...")
            self.saveRun()
            self.performSegueWithIdentifier("ShowRunDetail", sender: nil)
        }))
        
        //Add Discard-Action
        actionSheetController.addAction(UIAlertAction(title: "Discard", style: UIAlertActionStyle.Default, handler: { (actionSheetController) -> Void in
            print("Discard ...")
        }))
        
        //present actionSheetController
        presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
    
    func switchButtonsWithStartState(start:Bool)
    {
        if start
        {
            stopButton.enabled = false
            stopButton.alpha = 0.5
            startButton.enabled = true
            startButton.alpha = 1.0


        }else
        {
            stopButton.enabled = true
            stopButton.alpha = 1.0
            startButton.enabled = false
            startButton.alpha = 0.5

        }
    }
   // MARK: - Location Handler
    func startLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func eachSecond(timer : NSTimer) {
        seconds++
        
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        
        timeLabel.text = secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = distanceQuantity.description
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds/distance)
        paceLabel.text = paceQuantity.description
        
        
    }
    
     // MARK: - Start log the run
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations as [CLLocation] {
            if location.horizontalAccuracy < 20 {
                //Update distance
                if self.locations.count > 0
                {
                    distance += location.distanceFromLocation(self.locations.last!)
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
    
    // MARK: - Save the run
    
    func saveRun()
    {
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext!) as! Run
        savedRun.distance = distance
        savedRun.duration = seconds
        savedRun.timestamp = NSDate()
        
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext!) as! Location
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        savedRun.locations = NSOrderedSet(array: savedLocations)
        run = savedRun
        
        //handle errors
//        var error : NSError?
//        let success = managedObjectContext!.save()
        
        do {
            try managedObjectContext!.save()
        } catch {
            print("Could not save the run!")
        }
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let detailViewController = segue.destinationViewController as? IBRunDetailViewController {
            detailViewController.run = run
        }
    }
    

}

// MARK: - CLLocationManagerDelegate
extension IBNewRunViewController : CLLocationManagerDelegate {
    
}
