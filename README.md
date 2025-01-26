![DiplomaPresentationImages 001](https://github.com/user-attachments/assets/74a22658-5b2e-4cf3-b43d-c38d71349917)

<h2 align="center">Inventory manager based on QR Codes for iOS and iPad OS.</h2>

> *Note:* This project is no longer actively maintained. It was created as a showcase of the author's learning and skills developed during the _100 Days of SwiftUI_ course. While no further updates are planned, the code remains available as a reference for educational and exploratory purposes.

The goal of this project was to develop an app leveraging the device's camera to scan QR codes affixed to storage containers, enabling users to quickly view their contents and streamline the search process. The project incorporates modern machine learning techniques and advanced storage features to deliver a comprehensive and efficient solution.

![DiplomaPresentationImages 013](https://github.com/user-attachments/assets/c4f172e3-d9d3-412b-9b8d-7a7dc689418c)


# Screenshots - iOS

![iOS-SQR-Screens](https://github.com/user-attachments/assets/1b4a0418-9903-4f13-8ad6-5737967feb21)

# Screenshots - iPadOS

![iPadOS-SQR-Screens](https://github.com/user-attachments/assets/deb0d3fd-96fa-41f5-b866-205014ad3d02)

# Implementation

The app is built using the MVVM (Model-View-ViewModel) architectural pattern, incorporating SwiftData's data source implementation to enable seamless access to data outside the UI's `struct`.


## Frameworks and Core Technologies

-   **Swift**: The primary programming language used in the project.
-   **SwiftData**: Handles persistent data storage and management.
-   **SwiftUI**: The main framework for building the user interface.
-   **UIKit**: Complements SwiftUI for additional UI features.
-   **CoreML**: Powers the app's machine learning functionality.
-   **MapKit**: Integrates maps and location-based services.
-   **CoreLocation**: Determines the user's geographic location, enhancing item location features.
-   **TipKit**: Provides users with tips to improve app usage and experience.
-   **PhotosUI**: A modern photo picker framework for streamlined image selection.

## External packages

 - No external packages were used for this project.

## Challenges and Solutions


During the development of this project, several challenges were encountered and resolved. Some of the key issues include:
    
-   **Bug Fixes and Code Improvements**: A series of bug fixes were applied, including addressing QR watermark issues, improving code structure, and ensuring more efficient data handling.
    
-   **UI & UX Enhancements**: Multiple user interface improvements were made, such as redesigning the onboarding UI, updating UI elements for different devices (e.g., iPad), and adding animations to enhance the user experience.
    
-   **Location Name Disappearing**: Fixed a bug in the  `ItemDetailView`  where location names would unexpectedly disappear.
    
-   **Item Duplication and Crash Prevention**: Solved issues where adding two items with the same ML tags caused the app to crash, and improved the handling of similar items in the database.
    
-   **Photo Picker Resolution**: Enhanced the resolution and handling of images in the PhotosUI framework for better user interaction and smoother app performance.
    
-   **File Import Issues**: Fixed bugs related to importing files, including QR code exports and data handling, to ensure seamless user functionality.
    
-   **SwiftData Integration**: Improved the integration of SwiftData for persistent storage, ensuring that the data was managed correctly outside of the UI.
    
-   **CoreLocation & MapKit Usage**: Refined the integration of CoreLocation and MapKit to ensure accurate location tracking and map rendering.
    
-   **Translation and Accessibility**: Fixed translation issues (French, Ukrainian) and added accessibility features, such as reducing motion for a smoother experience across devices.
    
-   **Tag Sorting**: Fixed a bug where tags were not sorting correctly, which impacted the user’s ability to filter and manage items effectively.
    
-   **Location Editing and Item Recognition**: Worked on improving the location editing functionality and item recognition, ensuring a smoother workflow for users.

# Instalation

Follow these steps to build and run the app from source:

### 1. Clone the Repository

Clone the repository to your local machine using the following command:

`git clone https://github.com/killlilwinters/StorifyQR` 

### 2. Open the Project in Xcode

Navigate to the project directory and open the  `.xcodeproj`   file in Xcode:


### 3. Set Up Your Development Team (if needed)

In Xcode, go to the  **Signing & Capabilities**  section of your project settings and ensure that your development team is selected for the app target. You may need to set up a free or paid Apple Developer account for code signing.

### 5. Connect Your Device

Connect your iOS device to your Mac. Ensure that the device is properly recognized in Xcode.

### 6. Select Your Target Device

In the top toolbar of Xcode, select your connected device from the target device dropdown (next to the "Build and Run" button).

### 7. Build and Run

Click on the  **Run**  button (the play icon) in Xcode to build the project and launch it on your connected device.

> *Note:* If you encounter any issues with device provisioning or code signing, you may need to follow the on-screen prompts in Xcode to resolve them.

# More

Video presentation can be found by following this link:
https://youtube.com/shorts/usKSUovPsIc?feature=share


