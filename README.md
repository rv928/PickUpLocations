# PickUpLocations

## Installation

- Download and install Mac OS 10.15.4 and Xcode 11.3.1  , 
- Checkout develop branch Code from Github.

## Language
- Swift 5

## Support
- App and code supports for iOS 13 and later devices(iPhone) only.

## Architeture
- Bob's VIP Clean Swift Architecture

## Tests
- Unit test cases and UI Test cases

## API and parser
- Alarmofire and SwiftyJSON

## Sample Usecase guide (Tested from simulator only, not real device): 

1. Fetched list locations from server using given API
2. Fisplayed in screen using TableView
3. Clicking on location icon app will ask user to provide location permissions.
4. After providing location permission user will able to see sorted locations (nearest location in km) while changing location from Xcode location icon (above debugger).
5. To reset sorting order I provided refresh icon, pressing on that location list will be reset.
6. Everytime you changed location from Xcode debugger, list will be refreshed.


## License
[MIT](https://choosealicense.com/licenses/mit/)
