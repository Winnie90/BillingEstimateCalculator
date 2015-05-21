# Billing Estimate Calculator
A coding challenge to design an iOS app that estimates customer's bills. The iOS app uses a
MVC architecture and faithfully recreates the functionality exposed by a Billing Estimation Module. 

Setup 

Uses Cocoapods for dependencies - https://cocoapods.org/ 
Make sure you run - 
```
  pod install
```
Afterwards open BillingEstimateCalculator.xcworkspace in XCode not the project file.

Code signing identity is iOS Developer and Provisioning profile is set to Automatic so it should be ok to build and run.

Features
- Replicates a billing estimate calculator spreadsheet
- All calculations are updated automatically when there is a change in input
- Billing tiers can be added and removed and change the calculations
- Can enter company information to the bill

Added Features
- Bills are saved to core data so will still be there when the app is cancelled
- Can create multiple bills
- Can send a screenshot of the bill in an email
- Displays help messages to user on first play and on pressing the help button

Notes
- I've tested on the simulator and iPad Air let me know if there are problems with other devices
- I wasn't too sure if you wanted the app for iPhone as well, I can change my Storyboard to incorporate it if needed.

Included Libraries
- JDFTooltips - https://github.com/JoeFryer/JDFTooltips
