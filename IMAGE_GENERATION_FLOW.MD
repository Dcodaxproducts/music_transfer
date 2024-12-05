# Image Generation Flow

## Overview

This document outlines the flow of the image generation process in the application, including the logic and conditions for both subscribed and free users.

## Flow Steps

1. **User Initiates Image Generation**:

   - The user taps the "Create" button, which triggers the `ImageGenerationHelper.handleTap` method.

2. **Validation**:

   - `ImageGenerationHelper.handleTap` method checks if the prompt is empty using `_isPromptEmpty`.
   - It also checks if the prompt contains offensive words using `_hasOffensiveWords`.
   - If either condition is true, a toast message is shown, and the process stops.

3. **Handle Image Generation**:

   - If the prompt is valid, `ImageGenerationHelper.handleImageGeneration` is called with the prompt text.

4. **Check Subscription and Platform**:

   - `ImageGenerationHelper.handleImageGeneration` checks if the user is on Android or is a subscribed user (`SubscriptionController.find.isPro`).
   - If true, it calls `_handleProOrAndroidUser`.
   - If false, it calls `_handleFreeUser`.

5. **Handle Pro or Android User**:

   - `_handleProOrAndroidUser` checks if the user has exceeded the daily limit for pro users (`GenerationController.find.proUserLimitExceeded`).
   - If the limit is exceeded, it calls `ImageGenerationController.find.hasShowedFreeLimitDialog` to show a dialog prompting the user to watch an ad.
   - If the user watches the ad, `generateImage` is called with `showAds: false`.
   - If the limit is not exceeded, `generateImage` is called directly.

6. **Handle Free User**:

   - `_handleFreeUser` checks if the selected model is a premium model using `_isProModel`.
   - If the model is premium, it shows the premium sheet (`showPremiumSheet`).
   - If the model is not premium, it calls `_handleFreeUserGeneration`.

7. **Handle Free User Generation**:

   - `_handleFreeUserGeneration` checks if the user has free generations left using `ImageGenerationController.find.hasShowedFreeLimitDialog`.
   - If the user has no free generations left, it shows a dialog to watch an ad or buy a subscription.
   - If the user watches the ad, `generateImage` is called with `showAds: false`.
   - If the user has free generations left, `generateImage` is called directly.

8. **Generate Image**:
   - `generateImage` calls `ImageGenerationController.find.generateImages` to generate the image.
   - If the image generation is successful, it navigates to the `PromptDetailScreen` to display the generated image.
   - It also shows a "Rate Us" dialog after a delay.

## Methods

### `ImageGenerationHelper.handleTap`

```dart
static Future<void> handleTap(Function(String) handleImageGeneration) async {
  final settings = SettingsController.find;
  final text = settings.promptController.text;

  if (_isPromptEmpty(text)) {
    showToast('please_enter_prompt'.tr);
  } else if (_hasOffensiveWords()) {
    showToast('please_remove_offensive_words'.tr);
  } else {
    handleImageGeneration(text);
  }
}
```

### \_isPromptEmpty

```dart

bool _isPromptEmpty(String text) => text.isEmpty;

```

### \_hasOffensiveWords

```dart
bool _hasOffensiveWords() => SettingsController.find.hasOffensiveWords;
```

### \_isProModel

```dart
bool _isProModel() =>
    SettingsController.find.configModel.selectedModel?.premium ?? false;
```

### \_ImageGenerationHelper.handleImageGeneration

```dart
static Future<void> handleImageGeneration(String text,
    {required Function(String, {bool showAds}) generateImage}) async {
  if (Platform.isAndroid || SubscriptionController.find.isPro) {
    await _handleProOrAndroidUser(text, generateImage: generateImage);
  } else {
    _handleFreeUser(text, generateImage: generateImage);
  }
}
```

### \_handleProOrAndroidUser

```dart
static Future<void> _handleProOrAndroidUser(String text,
    {required Function(String, {bool showAds}) generateImage}) async {
  if (GenerationController.find.proUserLimitExceeded) {
    bool hasShowedFreeLimitDialog =
        await ImageGenerationController.find.hasShowedFreeLimitDialog();
    if (hasShowedFreeLimitDialog) {
      generateImage(text, showAds: false);
    }
  } else {
    generateImage(text);
  }
}
```

### \_handleFreeUser

```dart
static void _handleFreeUser(String text,
    {required Function(String, {bool showAds}) generateImage}) {
  if (_isProModel()) {
    showPremiumSheet();
  } else {
    _handleFreeUserGeneration(text, generateImage: generateImage);
  }
}
```

### \_handleFreeUserGeneration

```dart
static Future<void> _handleFreeUserGeneration(String text,
    {required Function(String, {bool showAds}) generateImage}) async {
  bool hasShowedFreeLimitDialog =
      await ImageGenerationController.find.hasShowedFreeLimitDialog();
  if (hasShowedFreeLimitDialog) {
    generateImage(text, showAds: false);
  } else {
    showAdsDialog(
      onWatchAdPressed: () {
        pop();
        generateImage(text);
      },
    );
  }
}
```

### \_generateImage

```dart
static void generateImage(String text, {bool showAds = true, int? seed}) {
  ImageGenerationController.find
      .generateImages(text, seed: seed, showAds: showAds)
      .then(
    (response) {
      if (response != null) {
        bool fromRegenerate = seed != null;
        if (fromRegenerate) {
          pop();
        }
        launchScreen(PromptDetailScreen(response: response),
            replace: fromRegenerate);
        Future.delayed(const Duration(seconds: 2), () {
          showConditionalRateUsDialog();
        });
      }
    },
  );
}
```
