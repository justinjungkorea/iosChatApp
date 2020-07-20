//
//  ContentView.swift
//  iOSChat
//
//  Created by justin dongwook Jung on 2020/07/20.
//  Copyright © 2020 justin dongwook Jung. All rights reserved.
//

import SwiftUI
import SocketIO

struct ContentView: View {
    let socket = SocketConnect();
    var body: some View {
        VStack(spacing: 50) {
            Button(action:{
                self.socket.establishConnection()
            }){
                Text("Connection")
            }
            
            Button(action: {
                self.socket.sendMessage()
            }){
                Text("Send")
            }
        }
    }
    
    class SocketConnect: NSObject{
        
        static let shared = SocketConnect()
        
        var manager = SocketManager(socketURL: URL(string: "http://192.168.35.94:7605")!, config: [.log(true), .reconnects(true), .forceWebsockets(true), .secure(true)] )
        
        var socket: SocketIOClient!
        
        override init() {
            super.init()
        }
        
        func establishConnection() {
            manager.defaultSocket.on(clientEvent: .connect){data, ack in
                print(data);
            }
            socket = self.manager.socket(forNamespace: "/SignalServer")

            socket.connect()
        }
        
        func closeConnection() {
            socket.disconnect()
        }
        
        
        
        func sendMessage(){
            
            struct RegisterData: Codable {
                let eventOp: String
                let reqNo: String
                let reqDate: String
            }
            
            let sample = RegisterData(eventOp: "Register", reqNo: "12213123", reqDate: "20200720213012")
           
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(sample)
                
            } catch {
                
            }
            
            socket.emit("knowledgetalk", sample as! SocketData)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

