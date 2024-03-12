# Weather
 ===============

Welcome to the project! This README file provides simple instructions on how to set up and run the project on your local machine. The project NOT uses Swift Package Manager (SPM), or CocoaPods package managers.


Prerequisites 
----------
Before you begin, make sure you have the following installed on your system:
Xcode at least version 15.2

You can download and install Xcode from the Mac App Store.

Cloning the Repository 
----------

1. Open Xcode on your Mac

2. In the menu bar, go to "Integrate" and select "Clone...".

3. In the dialog that appears, enter the repository URL.


Opening the Project
-----
Navigate to the project directory.

Open the file project Weather.xcodeproj in Xcode.



Building and Running the Project
-----
Once the project is open in Xcode, select the target device (e.g., iPhone simulator) from the dropdown menu in the top left corner.

Click the "Run" button (a play button) or press Cmd + R to build and run the project.

The project should now compile and launch on the selected device.


Conventions, architecture, and general considerations
-----
The project is implemented using the Swift language, UIKit is used to build the user interface, the architecture used is MVC, as the most suitable for writing this kind of small projects.

A specialised class ApiClient is used to process network requests. This class encapsulates all logic related to network communication, including execution of requests to the server, processing of responses and error handling. The LocationManager class is used for requests related to obtaining location data.
