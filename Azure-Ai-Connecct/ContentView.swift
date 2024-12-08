import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                chatHistoryView
                messageInputView
            }
            .navigationTitle("Azure AI Connect")
            .navigationBarTitleDisplayMode(.inline) // Makes the title smaller
        }
    }
    
    private var chatHistoryView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
    }
    
    private var messageInputView: some View {
        VStack(spacing: 12) {
            TextEditor(text: $viewModel.userInput)
                .frame(height: 80)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    ZStack(alignment: .topLeading) {
                        if viewModel.userInput.isEmpty {
                            Text("Write your message here...")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                        }
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    }
                )
            
            Button(action: viewModel.sendMessage) {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Submit")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading || viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user { Spacer() }
            
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(message.role == .user ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(16)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.role == .user ? .trailing : .leading)
            
            if message.role == .assistant { Spacer() }
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let role: MessageRole
    let content: String
}

enum MessageRole {
    case user
    case assistant
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userInput = ""
    @Published var isLoading = false
    
    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = Message(role: .user, content: userInput)
        messages.append(message)
        
        let prompt = userInput
        userInput = ""
        isLoading = true
        
        AzureOpenAIService.shared.sendRequest(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let reply):
                    self?.messages.append(Message(role: .assistant, content: reply))
                case .failure(let error):
                    self?.messages.append(Message(role: .assistant, content: "Error: \(error.localizedDescription)"))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
