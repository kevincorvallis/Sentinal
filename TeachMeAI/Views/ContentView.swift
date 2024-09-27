import SwiftUI
import Foundation

struct ContentView: View {
    @State private var messages: [Message] = [
        Message(text: "Hello! How can I assist you today?", isUser: false)
    ]
    @State private var inputText: String = ""
    
    // Create an instance of OpenAIService to use its methods
    private let openAIService = OpenAIService()

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(messages) { message in
                        MessageRow(message: message)
                            .padding(.vertical, 4)
                    }
                }
                .onChange(of: messages.count) {
                    if let lastMessage = messages.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding()

            // Input Bar
            HStack {
                TextField("Type a message...", text: $inputText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray5))
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .animation(.easeInOut, value: inputText)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    // This function sends the user message and gets the AI response
    func sendMessage() {
        let userMessage = Message(text: inputText, isUser: true)
        messages.append(userMessage)
        let userInput = inputText
        inputText = ""

        openAIService.sendMessageToAPI(message: userInput) { response in
            DispatchQueue.main.async {
                let aiMessageText = response ?? "Sorry, something went wrong."
                let aiMessage = Message(text: aiMessageText, isUser: false)
                messages.append(aiMessage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
