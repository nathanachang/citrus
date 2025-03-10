import Foundation
import Combine

// MARK: - Models and Enums
struct WebSocketMessage: Identifiable {
    let id = UUID()
    let content: String
    let isIncoming: Bool
    let timestamp: Date = Date()
}

// MARK: - WebSocket Service
class WebSocketService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var messages: [WebSocketMessage] = []
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isConnecting: Bool = false
    @Published private(set) var error: String? = nil
    
    // MARK: - Private Properties
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private var reconnectTimer: Timer?
    
    // MARK: - Callback
    var onReceiveMessage: ((String) -> Void)?
    
    // MARK: - Initialization
    init() {}
    
    deinit {
        disconnect()
    }
    
    // MARK: - Public Methods
    func connect() {
        guard !isConnected && !isConnecting,
              let url = URL(string: "wss://echo.websocket.events") else { return }
        
        isConnecting = true
        error = nil
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        listen()
        setupPingTimer()
    }
    
    func disconnect() {
        stopPingTimer()
        stopReconnectTimer()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = false
            self?.isConnecting = false
        }
    }
    
    func send(message: String) {
        guard isConnected else {
            connect()
            return
        }
        
        webSocketTask?.send(.string(message)) { [weak self] error in
            if let error = error {
                print("WebSocket send error: \(error.localizedDescription)")
                self?.handleError(error)
            } else {
                let sentMessage = WebSocketMessage(content: message, isIncoming: false)
                DispatchQueue.main.async {
                    self?.messages.append(sentMessage)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error.localizedDescription)")
                self.handleError(error)
                
            case .success(let message):
                DispatchQueue.main.async {
                    self.isConnected = true
                    self.isConnecting = false
                    self.error = nil
                }
                
                switch message {
                case .string(let text):
                    let message = WebSocketMessage(content: text, isIncoming: true)
                    DispatchQueue.main.async {
                        self.messages.append(message)
                        self.onReceiveMessage?(text)
                    }
                    
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        let message = WebSocketMessage(content: text, isIncoming: true)
                        DispatchQueue.main.async {
                            self.messages.append(message)
                            self.onReceiveMessage?(text)
                        }
                    }
                    
                @unknown default:
                    break
                }
                
                self.listen()
            }
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = false
            self?.isConnecting = false
            self?.error = error.localizedDescription
        }
        startReconnectTimer()
    }
    
    private func setupPingTimer() {
        stopPingTimer()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
    }
    
    private func sendPing() {
        webSocketTask?.sendPing { [weak self] error in
            if let error = error {
                print("WebSocket ping error: \(error.localizedDescription)")
                self?.handleError(error)
            }
        }
    }
    
    private func stopPingTimer() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    private func startReconnectTimer() {
        stopReconnectTimer()
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            self?.connect()
        }
    }
    
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
}
