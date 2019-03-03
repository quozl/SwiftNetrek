//
//  MakePacket.swift
//  Netrek
//
//  Created by Darrell Root on 3/2/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation

struct CP_PACKET {
    let type: UInt8 = 27
    let version: UInt8 = SOCKVERSION
    let udp_version: UInt8 = UDPVERSION
    let pad: UInt8 = 0
    //TODO: presumably we have to do something with this port
    let port: UInt32 = UInt32(32800).bigEndian
    
    var size: Int {
        return 8
    }
}
/*struct CP_LOGIN {
    let type: UInt8 = 8
    let query: UInt8 = 1 // 0 means something
    let pad: UInt8 = 0
    let pad2: UInt8 = 0
    var name: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8 = NAME_LEN
    var password: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8
    var login: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // 16 UInt8

    //var name = Data(count: NAME_LEN)
    //var password = Data(count: NAME_LEN)
    //var login = Data(count: NAME_LEN)
    var size: Int {
        return 52
    }
}*/
class MakePacket {
    
    static func make16Tuple(string: String) -> (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) {
        var temp: [UInt8] = []
        for _ in 0..<16 {
            temp.append(0)
        }
        for (index,char) in string.utf8.enumerated() {
            if index < 15 {
                // leaving last position with null
                temp[index] = char
            }
        }
        let information = (temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15])
        return information
    }
    static func cpPacket() -> Data {
        // packet type 27
        var packet = CP_PACKET()
        let data = Data(bytes: &packet, count: packet.size)
        return data
    }
    static func cpLogin(name: String, password:
        // ugly hack with 16-element tuple and
        // C structure header to get bit boundaries to align
        String, login: String) -> Data {
        var packet = login_cpacket()
        packet.type = 8
        packet.query = 1
        packet.name = make16Tuple(string: name)
        packet.login = make16Tuple(string: login)
        packet.password = make16Tuple(string: password)
        let data = Data(bytes: &packet, count: packet.size)
        for byte in data {
            debugPrint(byte)
        }
        return data
    }
    /*static func cpLogin(name: String, password: String, login: String) -> Data {
        var packet = CP_LOGIN()
        for (index,char) in name.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                debugPrint("index \(index) char \(UInt8(char))")
                packet.name[index] = UInt8(char)
            }
        }
        for (index,char) in password.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.password[index] = UInt8(char)
            }
        }
        for (index,char) in login.utf8.enumerated() {
            if index < NAME_LEN - 1 {
                packet.login[index] = UInt8(char)
            }
        }
        let data = Data(bytes: &packet, count: packet.size)
        for byte in data {
            debugPrint(byte)
        }
        return data
    }*/
}
