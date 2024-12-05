# Image Generation Flow

## Overview

This document outlines the flow of the image generation process in the application, including the logic and conditions for both subscribed and free users.

## Flow Steps

1. **User Initiates Image Generation**:

   - The user taps the "Create" button, which triggers the `_handleTap` method.

2. **Validation**:

   - `_handleTap` method checks if the prompt is empty using `_isPromptEmpty`.
   - It also checks if the prompt contains offensive words using `_hasOffensiveWords`.
   - If either condition is true, a toast message is shown, and the process stops.

3. **Handle Image Generation**:

   - If the prompt is valid, `_handleImageGeneration` is called with the prompt text.

4. **Check Subscription and Platform**:

   - `_handleImageGeneration` checks if the user is on Android or is a subscribed user (`SubscriptionController.find.isPro`).
   - If true, it calls `_handleProOrAndroidUser`.
   - If false, it calls `_handleFreeUser`.

5. **Handle Pro or Android User**:

   - `_handleProOrAndroidUser` checks if the user has exceeded the daily limit for pro users (`GenerationController.find.proUserLimitExceeded`).
   - If the limit is exceeded, it calls `ImageGenerationController.find.hasShowedFreeLimitDialog` to show a dialog prompting the user to watch an ad.
   - If the user watches the ad, `_generateImage` is called with `showAds: false`.
   - If the limit is not exceeded, `_generateImage` is called directly.

6. **Handle Free User**:

   - `_handleFreeUser` checks if the selected model is a premium model using `_isProModel`.
   - If the model is premium, it shows the premium sheet (`showPremiumSheet`).
   - If the model is not premium, it calls `_handleFreeUserGeneration`.

7. **Handle Free User Generation**:

   - `_handleFreeUserGeneration` checks if the user has free generations left using `ImageGenerationController.find.hasShowedFreeLimitDialog`.
   - If the user has no free generations left, it shows a dialog to watch an ad or buy a subscription.
   - If the user watches the ad, `_generateImage` is called with `showAds: false`.
   - If the user has free generations left, `_generateImage` is called directly.

8. **Generate Image**:
   - `_generateImage` calls `ImageGenerationController.find.generateImages` to generate the image.
   - If the image generation is successful, it navigates to the `PromptDetailScreen` to display the generated image.
   - It also shows a "Rate Us" dialog after a delay.

## Methods

### `_handleTap`

```dart
Future<void> _handleTap() async {
  final text = SettingsController.find.promptController.text;

  if (_isPromptEmpty(text)) {
    showToast('please_enter_prompt'.tr);
  } else if (_hasOffensiveWords()) {
    showToast('please_remove_offensive_words'.tr);
  } else {
    _handleImageGeneration(text);
  }
}
```

```dart
_isPromptEmpty

bool _isPromptEmpty(String text) => text.isEmpty;

```
