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
    @State var roomId: String = ""
    
    var body: some View {
        VStack {
            TextField("input a roomId", text: $roomId )
            VStack(spacing: 30) {
                
                HStack(alignment: .top, spacing: 50) {
                    Button(action:{
                        self.socket.establishConnection()
                    }){
                        Text("Connection")
                    }
                    
                    Button(action: {
                        self.socket.Register()
                    }){
                        Text("Register")
                    }
                    
                    Button(action: {
                        self.socket.roomJoin()
                    }){
                        Text("RoomJoin")
                    }
                }
            }
        }
        
    }
    
    class SocketConnect: NSObject{
        
        static let shared = SocketConnect()
        
        var manager: SocketManager?
        var socket: SocketIOClient!
        
        override init() {
            super.init()
            
            self.manager = SocketManager(socketURL: URL(string: "http://106.240.247.44:7605")!, config: [.log(false), .forcePolling(true)] )
            
        }
        
        func establishConnection() {
            
            socket = self.manager?.defaultSocket
            socket = self.manager?.socket(forNamespace: "/SignalServer")
            
            socket.on("knowledgetalk"){data, ack in
                print("receive ::: \(data)")
                
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

        func Register(){
            
            let sample: [String: Any] = [
                "eventOp": "Register",
                "reqNo": getReqNo(),
                "reqDate": getDate()
            ]
            
            let sendData = arrayToJSON(inputData: sample)
            socket.emit("knowledgetalk", sendData as! SocketData)
            
        }
        
        func roomJoin(){
            
            let sample: [String: Any] = [
                "eventOp": "RoomJoin",
                "reqNo": getReqNo(),
                "reqDate": getDate(),
                "roomId": ContentView().roomId
            ]
            
            let sendData = arrayToJSON(inputData: sample)
            socket.emit("knowledgetalk", sendData as! SocketData)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func arrayToJSON(inputData: [String: Any]) -> Any {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: inputData, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
        let temp = jsonString.data(using: .utf8)!
        let jsonObject = try JSONSerialization.jsonObject(with: temp, options: .allowFragments)
        
        return jsonObject
        
    } catch {
        return 0
    }
}

func getReqNo() -> String {
    var reqNo = ""
    
    for _ in 0..<7 {
        reqNo = reqNo + String(Int.random(in: 0...9))
    }
    
    return reqNo
}

func getDate() -> String {
    let today = Date()
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyyMMddHHmmss"
    let dateString = formatter.string(from: today)

    return dateString
}
