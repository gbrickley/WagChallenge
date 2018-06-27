# WagChallenge

## Installation
The app should run as is.  The deployment target is set to iOS 10.0.  If you have any questions or issues, you can contact me at gbrickley88@gmail.com

## Customization
- The [Constants.h](WagChallenge/Constants.h) file holds values that we may want the ability to easily change.  You can change the website that users are loaded from and also the number of users fetched at a time.  If you change the `STACK_EXCHANGE_SITE_NAME` to an invalid website name, you can view the error handling I included.

## Thoughts / Considerations
- As opposed to just loading one page, I added in some very basic pagination.  Once you scroll to the bottom of the table view, the next page is loaded.
- Right now images are downloaded and save permanently in the `Documents` directory so that they are available for offline use.  Depending on requirements and memory considerations, it may make sense to save them in a temporary directory so that they are available for offline use during the current app session, but then cleared from memory later on.
- I used a very simple setup to map the JSON API data to the `CHLUser` model, mainly in order to demonstrate my understanding of how objects are initialized and constructed.  In a larger scale project it may be beneficial to use a JSON mapping library to speed up development. 

## Third-party libraries
I used three, installed using CocoaPods:
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - Although the newer iOS versions have much better built in networking tools, this is still my go-to for networking.  A very well built and maintained framework with lots of built in additional features to make networking simple and reliable.
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - I've used this quite often on past projects.  A nice way to quickly create nice looking progress indicators.
- [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - Another favorite of mine, this UIScrollView/UITableView superclass provides delegate methods that allow you to customize your view in the case that your data set is empty. 
