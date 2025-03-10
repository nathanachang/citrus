import SwiftUI

struct WebSocketScreen: View {
    @StateObject private var webSocketService = WebSocketService()
    @State private var messageToSend: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("WebSocket Connection")
                .font(.title)
            
            // Connection status
            HStack {
                Circle()
                    .fill(webSocketService.isConnected ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                
                Text(connectionStatus)
                    .foregroundColor(webSocketService.isConnected ? .primary : .red)
            }
            
            // Messages list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(webSocketService.messages) { message in
                        MessageBubble(message: message)
                    }
                }
            }
            
            // Input field and send button
            HStack {
                TextField("Type your message...", text: $messageToSend)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(!webSocketService.isConnected || messageToSend.isEmpty)
            }
            .padding()
        }
        .padding()
        .onAppear {
            webSocketService.connect()
        }
        .onDisappear {
            webSocketService.disconnect()
        }
    }
    
    private var connectionStatus: String {
        if webSocketService.isConnecting {
            return "Connecting..."
        } else if let error = webSocketService.error {
            return "Error: \(error)"
        } else if webSocketService.isConnected {
            return "Connected"
        } else {
            return "Disconnected"
        }
    }
    
    private func sendMessage() {
        guard !messageToSend.isEmpty else { return }
        webSocketService.send(message: messageToSend)
        messageToSend = ""
    }
}

struct MessageBubble: View {
    let message: WebSocketMessage
    
    var body: some View {
        HStack {
            if !message.isIncoming {
                Spacer()
            }
            
            Text(message.content)
                .padding(10)
                .background(message.isIncoming ? Color.gray.opacity(0.2) : Color.blue)
                .foregroundColor(message.isIncoming ? .primary : .white)
                .cornerRadius(10)
            
            if message.isIncoming {
                Spacer()
            }
        }
    }
}
