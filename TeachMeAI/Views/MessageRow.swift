import SwiftUI

struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser {
                Spacer() // Push the user's message to the right

                // User message bubble
                Text(message.text)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    .frame(maxWidth: 250, alignment: .trailing)
                    .padding(.horizontal)
            } else {
                // AI Avatar (left side)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                
                // AI message bubble
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .frame(maxWidth: 250, alignment: .leading)
                    .padding(.horizontal)
                
                Spacer() // Push the AI's message to the left
            }
        }
        .padding(.vertical, 4)
    }
}

// Preview for MessageRow
struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        // Example preview with both user and assistant messages
        VStack {
            MessageRow(message: Message(text: "Hello! How can I assist you today?", isUser: false))
            MessageRow(message: Message(text: "I need help with my project.", isUser: true))
        }
        .previewLayout(.sizeThatFits)
    }
}
