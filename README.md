# Azure-AI-Connect iOS App

Azure-AI-Connect is a Swift-based iOS app that enables users to interact with OpenAI's GPT-4 model using Azure's AI service. This app allows users to send prompts and receive AI-generated responses in an intuitive chat interface.

## Features
- Chat-based interaction with OpenAI's GPT-4 model via Azure OpenAI Service.
- Elegant UI with a chat history view and an input field for user prompts.
- Dynamically updates messages with real-time AI responses.
- Handles network errors gracefully.
- Securely loads sensitive API keys using a `config.plist` file to avoid hardcoding secrets.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd Azure-AI-Connect
```

### 2. Configure API Keys

The app uses a `config.plist` file to securely store the Azure API key. To set up your API key:

1. Locate the `example.config.plist` file in the project.
2. Duplicate the file and rename it to `config.plist`.
3. Add your Azure API key:
   ```plist
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>AZURE_API_KEY</key>
       <string>your-azure-api-key-here</string>
   </dict>
   </plist>
   ```

4. Ensure `config.plist` is **ignored in Git** by checking the `.gitignore` file:
   ```
   config.plist
   ```

### 3. Prerequisites
- **Xcode 14+** (or latest version)
- **macOS 12+**
- An active Azure account with OpenAI Service access.

### 4. Setting Up Azure OpenAI Service

1. Log in to the [Azure Portal](https://portal.azure.com/).
2. Create an **Azure OpenAI Service** resource.
3. Deploy the GPT-4 model and note down the deployment name (e.g., `gpt-4o`).
4. Retrieve the **API endpoint** and **API key** from the Azure OpenAI Service dashboard.
5. Update the `endpoint` in `AzureOpenAIService.swift`:
   ```swift
   private let endpoint = "https://<your-resource-name>.openai.azure.com/openai/deployments/<deployment-id>/chat/completions?api-version=2024-08-01-preview"
   ```

### 5. Build and Run the App

1. Open the project in Xcode:
   ```bash
   open Azure-Ai-Connect.xcodeproj
   ```

2. Select a simulator or your connected iOS device.
3. Build and run the app using the Play button in Xcode.

## How the App Works

1. **Chat Interaction**:
   - The app provides a user-friendly chat interface.
   - Users can type a message in the input box and tap the "Submit" button.
   - The app sends the message as a prompt to Azure OpenAI and displays the AI-generated response in the chat.

2. **Code Workflow**:
   - `AzureOpenAIService`:
     - Handles HTTP requests to Azure OpenAI.
     - Processes responses and error handling.
   - `ChatViewModel`:
     - Manages chat messages and loading states.
   - `ContentView`:
     - Displays the chat UI and integrates with the `ChatViewModel`.

## Code Structure

### 1. Files Overview
- **`Azure_Ai_ConnectApp.swift`**:
  - The entry point of the app. Configures the main `ContentView`.

- **`AzureOpenAIService.swift`**:
  - Handles network calls to Azure OpenAI Service.
  - Securely loads the API key from `config.plist`.

- **`ContentView.swift`**:
  - Provides the main chat UI, including the message input and chat history.

- **`example.config.plist`**:
  - A template configuration file for storing API keys.

### 2. Core Classes
#### AzureOpenAIService
- Handles API requests using `URLSession`.
- Sends user prompts to the Azure OpenAI endpoint.
- Processes AI-generated responses and returns them to the app.

#### ChatViewModel
- A `@StateObject` class that manages:
  - The list of messages (`[Message]`).
  - The user's current input (`userInput`).
  - Loading state (`isLoading`).
- Sends prompts using `AzureOpenAIService` and updates the UI with responses.

#### MessageBubble
- A reusable SwiftUI view for rendering individual chat messages.

## Example Screenshot

<img src="https://github.com/AjinkyaSambare/Azure_Ai_Chat/blob/main/image.png" alt="Azure AI Connect Screenshot" width="300"/>

## Known Issues
- Ensure your device or simulator has an active internet connection.
- Handle potential API quota limits in Azure OpenAI.

## Future Improvements
- Add support for voice input and responses.
- Save chat history locally for future reference.
- Dark mode compatibility.

## Credits
- Developed by Ajinkya, Intern at Idealabs, under the guidance of the Idealabs team, 2024.
- Powered by [Azure OpenAI Service](https://azure.microsoft.com/en-us/services/cognitive-services/openai-service/).

## License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
