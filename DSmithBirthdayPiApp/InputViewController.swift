//
//  ViewController.swift
//  DSmithBirthdayPiApp
//
//  Created by David Smith1 on 6/4/16.
//  Copyright © 2016 David Smith. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    @IBOutlet weak var inputDate: UIDatePicker!
    
    var outputString: String = "";
    var piString = "";
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Loads pi.txt file and put the contents into a String
        if let piFile = Bundle.main.path(forResource: "pi", ofType: "txt") {
            do {
                piString = try NSString(contentsOfFile: piFile, usedEncoding: nil) as String
                piString = piString.replacingOccurrences(of: "\n", with: ""); // Removes all \n in string
                piString.remove(at: piString.characters.index(after: piString.startIndex));    // Removes the "." in the string
            } catch {
                // Contents could not be loaded
            }
        } else {
            // pi.txt not found!
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // If the user uses the date picker
    @IBAction func datePickerButton(_ sender: UIButton) {

        var checkRange: Range<String.Index>;
        var userDateStringMonth = "";
        var userDateStringDay = "";
        var userDateStringYear = "";
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMddyy"
        
        var convertedDate = dateFormatter.string(from: inputDate.date)
        dateFormatter.dateFormat = "yy"
        userDateStringYear = dateFormatter.string(from: inputDate.date)
        
        // Converting input into more easily searchable terms while adjusting possible output formats
        if convertedDate[convertedDate.characters.index(convertedDate.startIndex, offsetBy: 0)] == "0" {
            dateFormatter.dateFormat = "M"
            userDateStringMonth = dateFormatter.string(from: inputDate.date)
            if convertedDate[convertedDate.characters.index(convertedDate.startIndex, offsetBy: 2)] == "0" {
                convertedDate.remove(at: convertedDate.characters.index(convertedDate.startIndex, offsetBy: 2))
                dateFormatter.dateFormat = "d"
                userDateStringDay = dateFormatter.string(from: inputDate.date)
            }else {
                dateFormatter.dateFormat = "dd"
                userDateStringDay = dateFormatter.string(from: inputDate.date)
            }
            convertedDate.remove(at: convertedDate.characters.index(convertedDate.startIndex, offsetBy: 0))
        }else if convertedDate[convertedDate.characters.index(convertedDate.startIndex, offsetBy: 2)] == "0" {
            convertedDate.remove(at: convertedDate.characters.index(convertedDate.startIndex, offsetBy: 0))
            dateFormatter.dateFormat = "MM"
            userDateStringMonth = dateFormatter.string(from: inputDate.date)
            dateFormatter.dateFormat = "d"
            userDateStringDay = dateFormatter.string(from: inputDate.date)
        }else {
            dateFormatter.dateFormat = "MM"
            userDateStringMonth = dateFormatter.string(from: inputDate.date)
            dateFormatter.dateFormat = "dd"
            userDateStringDay = dateFormatter.string(from: inputDate.date)
        }
        
        if piString.contains(convertedDate) {
            checkRange = piString.range(of: convertedDate)!;
            outputString = "Your date of \(userDateStringMonth)/\(userDateStringDay)/\(userDateStringYear) \n is at digit \(piString.characters.distance(from: piString.startIndex, to: checkRange.lowerBound)) of Pi.";
        } else{
            outputString = "Could not find that date in the first\n10 million of digits of Pi.";
        }
        presentOutput();
    }
    
    // If the user uses the text field
    @IBAction func piTriviaButton(_ sender: UIButton) {
        /* For possible future use
         if( inputDigit.text?.characters.count > 7){ // Catches big inputs to prevent overflow
         outputString = "No valid digit entered. \n Please enter a number less than 8 digits long. "
         presentOutput()
         return
         }
         var validDate: Bool = true;
         let searchDigit = inputDigit.text;
         let searchDigitInt = Int(searchDigit!);
         var tempStringMonth = "";
         var tempStringYear = "";
         var tempStringDay = "";
         var tempStringWhole = ""
         
         if(searchDigit != "" && searchDigitInt <= 9999993 ){    // Checks to make sure input is in range
         if(searchDigitInt < 6500000){
         tempStringWhole = piString.substringWithRange(piString.startIndex.advancedBy(searchDigitInt!)..<piString.startIndex.advancedBy(searchDigitInt! + 8));
         }else{
         tempStringWhole = piString.substringWithRange(piString.endIndex.advancedBy(-10000001 + searchDigitInt!)..<piString.endIndex.advancedBy(-10000001 + searchDigitInt! + 8));
         }
         
         // Checks for MM/DD/YYYY
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex]);
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(1)]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(2)]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(3)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(4)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(5)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(6)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(7)]);
         var tempNumMonth = Int(tempStringMonth);
         var tempNumDay = Int(tempStringDay);
         
         // Series of checks to ensure date is valid, does not count leap years
         if (tempNumMonth > 12 || tempNumMonth < 1){
         validDate = false;
         }
         if (tempNumMonth == 1 || tempNumMonth == 3 || tempNumMonth == 5 || tempNumMonth == 7 || tempNumMonth == 8 || tempNumMonth == 10 || tempNumMonth == 12 ){
         if (tempNumDay > 31){
         validDate = false;
         }
         }
         if (tempNumMonth == 4 || tempNumMonth == 6 || tempNumMonth == 9 || tempNumMonth == 11 ){
         if (tempNumDay > 30){
         validDate = false;
         }
         }
         if (tempNumMonth == 2){
         if (tempNumDay > 29){
         validDate = false;
         }
         }
         if (validDate == false){    // Checks for MM/D/YYYY
         // Resetting strings due to use of append
         tempStringMonth = "";
         tempStringDay = "";
         tempStringYear = "";
         
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex]);
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(1)]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(2)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(3)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(4)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(5)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(6)]);
         tempNumMonth = Int(tempStringMonth);
         tempNumDay = Int(tempStringDay);
         
         // Series of checks to ensure date is valid, does not count leap years
         if (tempNumMonth > 12){
         validDate = false;
         }
         if (tempNumDay == 0){
         validDate = false;
         }
         }
         if (validDate == false){    // Checks for M/DD/YYYY
         // Resetting strings due to use of append
         tempStringMonth = "";
         tempStringDay = "";
         tempStringYear = "";
         
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(1)]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(2)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(3)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(4)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(5)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(6)]);
         tempNumMonth = Int(tempStringMonth);
         tempNumDay = Int(tempStringDay);
         
         // Series of checks to ensure date is valid, does not count leap years
         if (tempNumMonth == 0){
         validDate = false;
         }
         if (tempNumMonth == 1 || tempNumMonth == 3 || tempNumMonth == 5 || tempNumMonth == 7 || tempNumMonth == 8 || tempNumMonth == 10 || tempNumMonth == 12 ){
         if (tempNumDay > 31){
         validDate = false;
         }
         }
         if (tempNumMonth == 4 || tempNumMonth == 6 || tempNumMonth == 9 || tempNumMonth == 11 ){
         if (tempNumDay > 30){
         validDate = false;
         }
         }
         if (tempNumMonth == 2){
         if (tempNumDay > 29){
         validDate = false;
         }
         }
         }
         if (validDate == false){    // Checks for M/D/YYYY
         // Resetting strings due to use of append
         tempStringMonth = "";
         tempStringDay = "";
         tempStringYear = "";
         
         tempStringMonth.append(tempStringWhole[tempStringWhole.startIndex]);
         tempStringDay.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(1)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(2)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(3)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(4)]);
         tempStringYear.append(tempStringWhole[tempStringWhole.startIndex.advancedBy(5)]);
         tempNumMonth = Int(tempStringMonth);
         tempNumDay = Int(tempStringDay);
         
         // Series of checks to ensure date is valid, does not count leap years
         if (tempNumMonth == 0){
         validDate = false;
         } else if (tempNumDay == 0){
         validDate = false;
         } else{
         validDate = true;
         }
         }
         if (validDate == false){
         outputString = "The date at that digit of Pi \n is not a real date.";
         }else{
         outputString = "The date at that digit of Pi \n is \(tempStringMonth)/\(tempStringDay)/\(tempStringYear).";
         }
         }else{
         outputString = "No valid digit entered. \n Please enter a digit less than 9,999,994. "
         }
         */
        
        switch count{ // Rotates through different facts on a set rotation
        case 1:
            outputString = "Albert Einstein was born on Pi Day (3/14/1879) in Ulm Wurttemberg, Germany."
        case 2:
            outputString = "In 1995, Hiroyoki Gotu memorized 42,195 places of Pi and is considered the current Pi champion."
        case 3:
            outputString = "The first 144 digits of Pi add up to 666."
        case 4:
            outputString = "Scholars often consider Pi the most important and intriguing number in all of mathematics."
        case 5:
            outputString = "Pi was first rigorously calculated by one of the greatest mathematicians of the ancient world, Archimedes of Syracuse (287-212 B.C.). Archimedes was so engrossed in his work that he did not notice that Roman soldiers had taken the Greek city of Syracuse. When a Roman soldier approached him, he yelled in Greek “Do not touch my circles!” The Roman soldier simply cut off his head and went on his business."
        case 6:
            outputString = "In 2002, a Japanese scientist found 1.24 trillion digits of Pi using a powerful computer called the Hitachi SR 8000, breaking all previous records."
        case 7:
            outputString = "Thirty-nine decimal places of Pi suffice for computing the circumference of a circle girding the known universe with an error no greater than the radius of a hydrogen atom."
        case 8:
            outputString = "104348/33215 is the most accurate fraction of Pi, which is equal to the .00000001056th percentile."
        case 9:
            outputString = "At position 763 there are six nines in a row, which is known as the Feynman Point."
        case 10:
            outputString = "Pi has about 6.4 billion known digits which would take a person roughly 133 years to recite without stopping.  The world record holder for the most memorized digits of Pi took nine hours to recite over 42,000 digits of Pi."
        case 11:
            outputString = "Before the π symbol was used, mathematicians would describe Pi in round-about ways such as “quantitas, in quam cum multipliectur diameter, proveniet circumferential,” which means “the quantity which, when the diameter is multiplied by it, yields the circumference.”"
        case 12:
            outputString = "Many mathematicians claim that it is more correct to say that a circle has an infinite number of corners than to view a circle as being cornerless."
        case 13:
            outputString = "Pi has been studied by the human race for almost 4,000 years. By 2000 B.C., Babylonians established the constant circle ratio as 3-1/8 or 3.125. The ancient Egyptians arrived at a slightly different value of 3-1/7 or 3.143."
        case 14:
            outputString = "A Givenchy men’s cologne named Pi is marketed as highlighting the sexual appeal of intelligent and visionary men."
        case 15:
            outputString = "In the Greek alphabet, Pi is the 16th letter. In the English alphabet, p is also the 16th letter."
        case 16:
            outputString = "The symbol for Pi (π) has been used regularly in its mathematical sense only for the past 250 years."
            count = 0
        default:
            outputString = "Error, please alert the developer."
        }
        count = count + 1
        //        let factPicker = Int(arc4random_uniform(15) + 1) // Random picker
        
        presentOutput();
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Outputs as an Alert Message
    func presentOutput(){
        let alert = UIAlertController(title: "Results", message: outputString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "More Pi!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




