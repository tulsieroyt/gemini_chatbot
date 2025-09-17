<div align="center">
  <h1>Flutter Gemini Chatbot</h1>
  <p>
    A sleek, real-time chatbot application built with Flutter and powered by Google's Gemini Pro model. Engage in dynamic, intelligent conversations with a state-of-the-art AI.
  </p>
  
  <!-- Badges -->
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" alt="Flutter Version">
    <img src="https://img.shields.io/badge/Google-Gemini_Pro-4285F4?logo=google" alt="Gemini Pro">
    <img src="https://img.shields.io/github/license/tulsieroyt/gemini_chatbot?color=brightgreen" alt="License">
    <img src="https://img.shields.io/badge/PRs-Welcome-blueviolet" alt="PRs Welcome">
  </p>
</div>

## Features

This chatbot isn't just a simple message-and-response app. It's packed with features to provide a rich user experience.

*   **Real-time Interaction:** Get instant responses from the Gemini Pro API.
*   **Markdown Rendering:** Displays formatted text, links, code blocks, and lists beautifully.
*   **Intuitive UI:** A clean, chat-bubble interface that's easy and enjoyable to use.
*   **Loading & Error States:** Clear visual indicators for when the AI is thinking or if an error occurs.
*   **Cross-Platform:** Built with Flutter for a consistent experience on both Android and iOS.
*   **Lightweight & Performant:** Optimized for smooth performance.


## Core Technologies

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Language:** [Dart](https://dart.dev/)
*   **AI Model:** [Google Gemini Pro](https://ai.google.dev/)
*   **API Client:** [`google_generative_ai`](https://pub.dev/packages/google_generative_ai) package
*   **UI:** [`flutter_markdown`](https://pub.dev/packages/flutter_markdown) for rendering responses.

## Getting Started

This guide will walk you through setting up and running the project locally.

### 1. Prerequisites

*   **Flutter SDK:** Make sure you have the latest stable version of Flutter installed.
*   **Gemini API Key:** You need an API key from Google AI Studio. You can get one for free [here](https://makersuite.google.com/app/apikey).

### 2. Clone the Repository

```sh
git clone https://github.com/tulsieroyt/gemini_chatbot.git
cd gemini_chatbot
```

### 3. Install Dependencies

From the project's root directory, run:

```sh
flutter pub get
```

### 4. Configure Your API Key

**This is the most important step.** You need to provide your Gemini API key to the application.

1.  Navigate to the `lib/` directory.
2.  Create a new file named `constants.dart`.
3.  Add the following code to the `constants.dart` file, replacing `"YOUR_API_KEY"` with your actual Gemini API key:

    ```dart
    // lib/constants.dart

    const String apiKey = "YOUR_API_KEY";
    ```
4.  The project is already set up to use this file, which is ignored by Git (`.gitignore`) to keep your key safe.

### 5. Run the App

Connect a device or start an emulator and run the application:

```sh
flutter run
```

## Project Structure

The codebase is organized to be simple and easy to navigate.

```
lib/
├── constants.dart      # Contains your private API key (you must create this)
├── home_screen.dart    # The main UI and logic for the chat screen
└── main.dart           # The entry point of the Flutter application
```

## Contributing

Contributions are highly encouraged and welcome! If you have ideas for improvements or want to fix a bug, feel free to:

1.  **Fork** the repository.
2.  Create a new **branch** for your feature or fix.
3.  Make your changes and **commit** them with a clear message.
4.  Push your branch and open a **Pull Request**.

Don't forget to star the project if you find it useful!

## License

This project is licensed under the **MIT License**. See the [`LICENSE`](https://github.com/tulsieroyt/gemini_chatbot/blob/master/LICENSE) file for more details.

---

<div align="center">
  <p>Built with ❤️ and a passion for AI by Tulsie Chandra Barman.</p>
</div>
