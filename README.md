# Billing Estimate Calculator
A coding challenge to design an iOS app that estimates customer's bills. The iOS app uses a
MVC architecture and faithfully recreates the functionality exposed by a Billing Estimation Module. 

Uses Cocoapods - https://cocoapods.org/

Make sure you run - 
```
  pod install
```

Open BillingEstimateCalculator.xcworkspace 

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
- Didn't have time to make it look nice on the iPhone

Included Libraries
- JDFTooltips - https://github.com/JoeFryer/JDFTooltips
