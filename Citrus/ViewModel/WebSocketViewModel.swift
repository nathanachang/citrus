//
//  WebSocketViewModel.swift
//  Citis
//
//  Created by Paul Minyoo Kim on 2/17/25.
//

import Foundation

class WebSocketViewModel: ObservableObject {
    @Published var receivedMessage: String = "Waiting for messages..."
    
    @Published var messageToSend: String = ""
    
    private var webSocketService = WebSocketService()
    
    init() {
        webSocketService.onReceiveMessage = { [weak self] message in
            self?.receivedMessage = message
        }
        connectToWebSocket()
    }
    func connectToWebSocket() {
        webSocketService.connect()
    }
    
    func disconnect() {
        webSocketService.disconnect()
    }
    
    func send(message: String) {
        webSocketService.send(message: message)
    }
}
