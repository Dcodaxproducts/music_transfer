# Changelog

## [2.3] - 2023-12-05 (iOS)

### Added

- **Ad Flow Sequence**:
  - First generation is free without ads.
  - Second generation triggers a reward ad.
  - Third generation triggers an interstitial ad.
  - Fourth generation triggers a reward ad.
  - Fifth generation triggers an interstitial ad.
  - Subscribed users have a daily limit of 75 generations ad-free.
  - Implemented dialog flow to prompt users to watch an ad if they have reached their free generation limit.
  - Refactored `ImageGenerationService` to handle ad flow and dialog properly.
  - Added `showAdAccordingToGeneration` method in `ModelsService` to determine ad type based on generation count.
  - Updated `HomeScreen` to handle image generation and ad flow logic.

### Removed

- **Packages**

  - flutter_staggered_animations: ^1.1.1
  - in_app_review: ^2.0.9
  - flutter_rating_bar: ^4.0.1
  - flutter_inappwebview: ^6.0.0
  - in_app_purchase: ^3.2.0

- **Features**
  - Mobile proxy implementation
  - Old ad flow sequence:
    - Removed the old implementation of ad flow sequence which was based on showing ads at specific intervals without considering the new sequence.
    - Removed model-based ad implementation.
  - Ad model and Settings model to determine separate values for android and iOS (model premium, free generations)

### Changed

- Refactored `_handleTap` method in `HomeScreen` to improve readability and maintainability.
- Updated `ImageGenerationService` to ensure the dialog is shown, the ad is loaded and shown, and then the success value is returned correctly.

### Fixed

- N/A

- **Features**

  - Mobile proxy implementation
  - Old ad flow sequence:
    - Removed the old implementation of ad flow sequence whcih was based on showing ads at specific intervals without considering the new sequence.
    - Remove model base ad implementation

## [1.0.0] - 2023-XX-XX

### Added

- **Main Features**:

  - **Localization**:
    - Added support for multiple languages.
    - Implemented localization controller to manage language settings.
  - **Firebase Notifications**:
    - Integrated Firebase for push notifications.
    - Implemented notification helper to handle notification initialization and permissions.
  - **Google Ads**:
    - Integrated Google Mobile Ads for monetization.
    - Configured ad request settings and test device IDs.
  - **Crashlytics**:
    - Integrated Firebase Crashlytics for error reporting.
    - Configured error handling to report uncaught errors to Crashlytics.
  - **Screen Util**:
    - Implemented screen util for responsive design.
    - Configured design sizes for different device types (phones, tablets, large tablets).
  - **Upgrader**:
    - Integrated upgrader for app updates.
    - Configured upgrade alert to prompt users for app updates.
  - **First Time User Flow**:
    - Welcome screen to accept privacy policy and terms and conditions.
    - Onboarding screen to guide new users through the app features.

- **Root Features**:

  - **Internet Connection Check**:
    - Checks for internet connectivity using connectivity_plus package.
    - Displays a no internet dialog if the device is not connected to the internet.
  - **History Management**:
    - Retrieves user history from shared preferences.
    - Initializes prompt history in the HistoryController.
  - **Review Check**:
    - Checks if the user has reviewed the app.
    - Displays a rate us dialog based on certain conditions.
  - **Daily Generations**:
    - Initializes daily generations for the user.
    - Fetches generation data from the backend.
  - **Ad Initialization**:
    - Fetches ad IDs from the backend and initializes ads.
    - Configures ad positions and types (Interstitial, App Open, Rewarded).
  - **Model Fetching**:
    - Retrieves models from the backend.
    - Displays models in the home screen and models screen.
  - **Inspiration Fetching**:
    - Retrieves inspirations from the backend.
    - Displays inspirations in the inspiration screen.
  - **Subscription Initialization**:
    - Initializes the subscription controller.
    - Manages subscription status and in-app purchases.
  - **App Open Ad**:
    - Loads and shows app open ads for non-premium users.
    - Configures app open ad to show when the app is resumed.
  - **Background Ad Loading**:
    - Loads ads when the app goes into the background.

- **Dashboard Features**:

  - **Subscription Screen**:
    - Shows subscription screen to non-premium users.
    - Manages subscription options and in-app purchases.
  - **App Open Ad Control**:
    - Controls the display of app open ads for first-time users.
    - Configures settings to prevent app open ads for new users.

- **Home Screen Features**:

  - **Prompt Input Field**:
    - Allows users to input prompts.
    - Includes a button to get random inspiration and a clear button.
  - **Models View**:
    - Displays popular models with a toggle favorite button.
    - Includes a 'see all' button to open the models screen.
  - **Advanced Options Widget**:
    - Includes a select aspect ratio button.
    - Opens a screen to select aspect ratio from given options.
  - **Prompt Settings**:
    - Opens the prompt settings screen.
    - Allows users to configure prompt settings such as aspect ratio, negative prompt, CFG scale, and seed.
  - **Create Button**:
    - Checks if the prompt is not empty and does not contain offensive words.
    - Shows an ad dialog for free users to watch an ad or go pro.
    - Directly generates an image for premium users.
  - **History View**:
    - Displays history with a 'see all' button to open the history screen.
    - Shows prompt history and allows users to manage their history.

- **Prompt Setting Screen**:

  - **Aspect Ratio**:
    - Allows users to select aspect ratio for image generation.
  - **Negative Prompt**:
    - Allows users to input negative prompts to exclude certain elements from the generated image.
  - **CFG Scale**:
    - Allows users to set CFG scale for image generation.
  - **Seed**:
    - Allows users to set seed for image generation to reproduce specific results.

- **Models Screen (Set Theme)**:

  - **Tabs**:
    - All models: Displays all available models.
    - Favorite models: Displays user's favorite models.

- **History Screen**:

  - **Tabs**:
    - All history: Displays all prompt history.
    - Favorites: Displays user's favorite prompts.

- **Result Screen**:

  - **Image Display**:
    - Displays the generated image with back button, report/feedback button, and edit button for upscaling or face-fixing the image.
  - **Model Info**:
    - Displays information about the model used for image generation.
  - **Prompt Display**:
    - Displays the prompt used for image generation.
  - **Actions**:
    - Copy prompt.
    - Toggle favorite.
    - Download image.
    - Delete prompt.
  - **Recreate Button**:
    - Allows users to recreate the image with the same prompt.

- **Inspiration Screen**:

  - **Inspiration Display**:
    - Shows inspirations fetched from the backend.
    - Displays inspiration images and prompts.
  - **Inspiration Dialog**:
    - Opens a dialog with the inspiration image and prompt, including a button to try it.

- **Menu/Settings Screen**:

  - **Language**:
    - Allows users to select the app language.
  - **Theme**:
    - Allows users to select the app theme (light, dark, system).
  - **Notifications**:
    - Allows users to enable or disable notifications.
  - **Privacy Policy**:
    - Displays the privacy policy.
  - **Terms of Service**:
    - Displays the terms of service.
  - **Rate Us**:
    - Allows users to rate the app.
  - **Share App**:
    - Allows users to share the app with others.

- **Subscription Screen**:
  - **Subscription Management**:
    - Allows users to manage their subscriptions.
    - Displays subscription options and handles in-app purchases.

### Changed

- N/A

### Fixed

- N/A

### Removed

- N/A
