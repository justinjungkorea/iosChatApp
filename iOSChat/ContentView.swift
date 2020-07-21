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
        
        var manager: SocketManager?
        var socket: SocketIOClient!
        
        override init() {
            super.init()
            
            self.manager = SocketManager(socketURL: URL(string: "http://106.240.247.44:7605")!, config: [.log(true), .reconnects(true), .forceWebsockets(true)] )
            
        }
        
        func establishConnection() {
            
            socket = self.manager?.defaultSocket
            socket = self.manager?.socket(forNamespace: "/SignalServer")
            
            socket.on("knowledgetalk"){data, ack in
                print(data)
            }
            
            socket.on(clientEvent: .connect){data, ack in
                print("socket connected!")
            }
            
            socket.on(clientEvent: .error){data, ack in
                print("socket error")
            }
            
            socket.on(clientEvent: .disconnect){data, ack in
                print("socket disconnect")
            }
            
            socket.on(clientEvent: .reconnect){data, ack in
                print("socket reconnect")
            }
            
            socket.connect()
                       
        }
        
        func addHandlers(){
            
        }
        
        
        func sendMessage(){
            
            let sample: [String: Any] = [
                "eventOp": "Register",
                "reqNo": "12213123",
                "reqDate": "20200720213012"
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: sample, options: [])
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                
                socket.emit("knowledgetalk", jsonString)
                
            } catch {
                
            }
            
            
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

