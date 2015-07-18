//
//  NewRunViewController.swift
//  LogMyRun
//
//  Created by Issam on 18/07/15.
//  Copyright © 2015 codemysource. All rights reserved.
//

import UIKit
import CoreData

class IBNewRunViewController: UIViewController {

    var managedObjectContext : NSManagedObjectContext?
    var run:Run!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
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
        
        timeLabel.hidden = true
        distanceLabel.hidden = true
        paceLabel.hidden = true
        
    }
    
    @IBAction func startAction(sender: UIButton)
    {
       switchButtonsWithStartState(false)
        
        
        timeLabel.hidden = false
        distanceLabel.hidden = false
        paceLabel.hidden = false
    }
    
    
    @IBAction func stopAction(sender: UIButton)
    {
        //switchButtonsWithStartState(true)
        
        let actionSheetController = UIAlertController (title: "Run Stopped", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Add Cancle-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (actionSheetController) -> Void in
            print("haSave ...")
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
