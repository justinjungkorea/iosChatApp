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
        
        override init() {
            super.init()
            
            self.manager = SocketManager(socketURL: URL(string: "https://knowledgetalk.co.kr:7101")!, config: [.log(true), .reconnects(true), .forceWebsockets(true)] )
            
        }
        
        func establishConnection() {
            var socket: SocketIOClient!
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
            
            socket.connect(timeoutAfter: 15){
                print("can't connect to socket")
            }
                       
        }
        
        func addHandlers(){
            
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
            
//            socket.emit("knowledgetalk", ["messge": "test"])
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

