#  FavoritePets
## App
FavoritePets gets a list of pets using https://api.thedogapi.com/v1/images/search to displays their image and using https://api.thedogapi.com/v1/breeds to displays their breed.

## Build and Run
* Xcode 15.1 & Swift 5.9 Minimum version is iOS 17.2
* Open FavoritePets.xcworkspace

## Technology Stack
* Swift, UIKit, AutoLayout, UIPageControl, UITableView, UICollectionView, URLSession and Kingfisher.

## Architecture
### MVVM Architecture
* ViewModel contains the business logic, requests data from the API
* ViewModels communicate with the ViewController using the delegate pattern. The ViewModel has a weak reference to a ViewModelDelegate which the ViewController implements.
* ViewModel communicates with the API via Actions. Action is an abstraction to a Service. The Action abstraction is used to mock the service in testing ViewModels. 

### View Hierarchy
* Embeded UICollection View into custom cells of UITableView. The cell can be different kind of custom collection cells.
* Pull-up to loading. Loading 20 items of BreedsCell each time.

### ImageService && NameService
* Responsible for communicating with the APIs and coordinating requests and responses. 
* Uses DispatchQueues to perform the processing in the background, since the APIs are asynchronous and it shouldn't be run on the Main queue. 
* PetsResponse is a domain transfer object that's separate from the Pet model that the app is using. This is to allow for the API response to evolve in structure and data independent of the app's models.

## 3rd Party Dependencies
* CocoaPods for dependency management.
* Kingfisher 3rd party library for asynchronously fetching of images. This is done behind and UIImageView extension which makes it easier to swap it with a different 3rd party or refactor into something bespoke for the app.

## Notes
* Uses Swift's Standard Library's Decodable and JSONDecoder for parsing.
* Displays a placeholder image if there was an issue in getting the image.
* print is used as a substitute with logging non fatal errors or issues.
* There is only 1 error enum: PetsError which is done for simplicity. This can be improved by splitting it out by layer from Networking to Service to DataProcessing.
