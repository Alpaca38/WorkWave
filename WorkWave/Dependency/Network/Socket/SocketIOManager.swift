//
//  SocketManager.swift
//  WorkWave
//
//  Created by 조규연 on 1/13/25.
//

import Foundation
import SocketIO

enum SocketType<ModelType: Decodable>: String {
    case channel
    case dm
    
    var namespace: String {
        switch self {
        case .channel:
            return "/ws-channel"
        case .dm:
            return "/ws-dm"
        }
    }
}

final class SocketIOManager<ModelType: Decodable>: AsyncSequence {
    private var id: String
    private var type: SocketType<ModelType>
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    
    typealias Element = Result<ModelType, SocketError>
    typealias AsyncIterator = AsyncStream<Element>.AsyncIterator
    
    private var stream: AsyncStream<Element>
    private var continuation: AsyncStream<Element>.Continuation
    
    init(id: String, socketInfo: SocketType<ModelType>) {
        self.id = id
        self.type = socketInfo
        
        var continuation: AsyncStream<Element>.Continuation!
        self.stream = AsyncStream<Element> { continuation = $0 }
        self.continuation = continuation
        
        configureSocket()
        configureConnectionEvents()
        configureSocketEvents()
        connect()
    }
    
    deinit {
        print("Socket Deinit")
        disconnect()
    }
    
    func makeAsyncIterator() -> AsyncStream<Element>.AsyncIterator {
        return stream.makeAsyncIterator()
    }
    
    private func configureSocket() {
        guard let baseURL = URL(string: String(APIKey.baseURL)) else {
            print("baseURL 없음")
            return
        }
        
        socketManager = SocketManager(
            socketURL: baseURL,
            config: [.log(false), .compress]
        )
        socket = socketManager?.socket(forNamespace: "\(type.namespace)-\(id)")
    }
    
    private func configureConnectionEvents() {
        guard let socket else { return }
        
        socket.on(clientEvent: .connect) { _, _ in
            print("소켓 연결 감지")
        }
        
        socket.on(clientEvent: .disconnect) { _, _ in
            print("소켓 연결 해제 감지")
        }
        
        socket.on(clientEvent: .reconnect) { _, _ in
            print("소켓 재연결 감지")
        }
    }
    
    private func configureSocketEvents() {
        guard let socket else { return }
        socket.on(type.rawValue) { [weak self] dataArray, _ in
            guard let self = self, let data = dataArray.first else {
                print("소켓 데이터 없음")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let decodedData = try JSONDecoder().decode(ModelType.self, from: jsonData)
                continuation.yield(.success(decodedData))
                print("소켓 데이터 보내기 성공")
            } catch {
                print("소켓 데이터 디코딩 실패")
                continuation.yield(.failure(.messageSendFailed))
            }
        }
    }
    
    private func connect() {
        print("소켓 연결")
        socket?.connect()
    }
    
    private func disconnect() {
        print("소켓 연결 끊기")
        // 비동기 스트림 종료
        continuation.finish()
        socket?.disconnect()
        socket?.off(clientEvent: .connect)
        socket?.off(clientEvent: .disconnect)
        socket?.off(clientEvent: .reconnect)
        socket?.off(type.rawValue)
        socket = nil
        socketManager = nil
    }
}

enum SocketError: Error {
    case messageSendFailed
}
