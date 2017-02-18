//
//  OutputViewController.swift
//  DSmithBirthdayPiApp
//
//  Created by David Smith1 on 6/4/16.
//  Copyright © 2016 David Smith. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {
    @IBOutlet weak var outputLabel: UILabel!
    var outputString = "";
    var piString = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.text = outputString;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let inputVC: InputViewController = segue.destinationViewController as! InputViewController;
        inputVC.piString = piString;
    }
    
}