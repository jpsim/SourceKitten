//
//  SHA1.swift
//  SourceKittenFramework
//
//  https://github.com/idrougge/sha1-swift
//
// SHA-1 implementation in Swift 4
// $AUTHOR: Iggy Drougge
// $VER: 2.3.1

import Foundation

/// Left rotation (or cyclic shift) operator
infix operator <<< : BitwiseShiftPrecedence
private func <<< (lhs:UInt32, rhs:UInt32) -> UInt32 {
    return lhs << rhs | lhs >> (32-rhs)
}

public struct SHA1 {
    // One chunk consists of 80 big-endian longwords (32 bits, unsigned)
    private static let CHUNKSIZE=80
    // SHA-1 magic words
    private static let h0:UInt32 = 0x67452301
    private static let h1:UInt32 = 0xEFCDAB89
    private static let h2:UInt32 = 0x98BADCFE
    private static let h3:UInt32 = 0x10325476
    private static let h4:UInt32 = 0xC3D2E1F0
    
    /**************************************************
     * SHA1.context                                   *
     * The context struct contains volatile variables *
     * as well as the actual hashing function.        *
     **************************************************/
    private struct context {
        // Initialise variables:
        var h:[UInt32]=[SHA1.h0,SHA1.h1,SHA1.h2,SHA1.h3,SHA1.h4]
        
        // Process one chunk of 80 big-endian longwords
        mutating func process(chunk:inout ContiguousArray<UInt32>) {
            for i in 0..<16 {
                chunk[i] = chunk[i].bigEndian // The numbers must be big-endian
            }
            //chunk=chunk.map{$0.bigEndian}   // The numbers must be big-endian
            for i in 16...79 {                // Extend the chunk to 80 longwords
                chunk[i] = (chunk[i-3] ^ chunk[i-8] ^ chunk[i-14] ^ chunk[i-16]) <<< 1
            }
            
            // Initialise hash value for this chunk:
            var a,b,c,d,e,f,k,temp:UInt32
            a=h[0]; b=h[1]; c=h[2]; d=h[3]; e=h[4]
            f=0x0; k=0x0
            
            // Main loop
            for i in 0...79 {
                switch i {
                case 0...19:
                    f = (b & c) | ((~b) & d)
                    k = 0x5A827999
                case 20...39:
                    f = b ^ c ^ d
                    k = 0x6ED9EBA1
                case 40...59:
                    f = (b & c) | (b & d) | (c & d)
                    k = 0x8F1BBCDC
                case 60...79:
                    f = b ^ c ^ d
                    k = 0xCA62C1D6
                default: break
                }
                temp = a <<< 5 &+ f &+ e &+ k &+ chunk[i]
                e = d
                d = c
                c = b <<< 30
                b = a
                a = temp
                //print(String(format: "t=%d %08X %08X %08X %08X %08X", i, a, b, c, d, e))
            }
            
            // Add this chunk's hash to result so far:
            h[0] = h[0] &+ a
            h[1] = h[1] &+ b
            h[2] = h[2] &+ c
            h[3] = h[3] &+ d
            h[4] = h[4] &+ e
        }
    }
    
    /**************************************************
     * processData()                                  *
     * All inputs are processed as NSData.            *
     * This function splits the data into chunks of   *
     * 16 longwords (64 bytes, 512 bits),             *
     * padding the chunk as necessary.                *
     **************************************************/
    private static func process(data: inout Data) -> SHA1.context? {
        var context=SHA1.context()
        var w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE) // Initialise empty chunk
        let ml=data.count << 3                                        // Message length in bits
        var range = Range(0..<64)                                     // A chunk is 64 bytes
        
        // If the remainder of the message is more than or equal 64 bytes
        while data.count >= range.upperBound {
            //print("Reading \(range.count) bytes @ position \(range.lowerBound)")
            w.withUnsafeMutableBufferPointer{ dest in
                _=data.copyBytes(to: dest, from: range)               // Retrieve one chunk
            }
            context.process(chunk: &w)                                // Process the chunk
            range = Range(range.upperBound..<range.upperBound+64)     // Make range for next chunk
        }
        
        // Handle remainder of message that is <64 bytes in length
        w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE) // Initialise empty chunk
        range = Range(range.lowerBound..<data.count)                  // Range for remainder of message
        w.withUnsafeMutableBufferPointer{ dest in
            _=data.copyBytes(to: dest, from: range)                   // Retrieve remainder
        }
        let bytetochange=range.count % 4                              // The bit to the right of the
        let shift = UInt32(bytetochange * 8)                          // last bit of the actual message
        w[range.count/4] |= 0x80 << shift                             // should be set to 1.
        // If the remainder overflows, a new, empty chunk must be added
        if range.count+1 > 56 {
            context.process(chunk: &w)
            w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE)
        }
        
        // The last 64 bits of the last chunk must contain the message length in big-endian format
        w[15] = UInt32(ml).bigEndian
        context.process(chunk: &w)                                    // Process the last chunk
        
        // The context (or nil) is returned, containing the hash in the h[] array
        return context
    }
    
    /**************************************************
     * hexString()                                    *
     * Render the hash as a hexadecimal string        *
     **************************************************/
    private static func hexString(_ context:SHA1.context?) -> String? {
        guard let c=context else {return nil}
        return String(format: "%08X %08X %08X %08X %08X", c.h[0], c.h[1], c.h[2], c.h[3], c.h[4])
    }
    
    /**************************************************
     * dataFromFile()                                 *
     * Fetch the contents of a file as NSData         *
     * for processing by processData()                *
     **************************************************/
    private static func dataFromFile(named filename:String) -> SHA1.context? {
        guard var file = try? Data(contentsOf: URL(fileURLWithPath: filename)) else {return nil}
        return process(data: &file)
    }
    
    /**************************************************
     * PUBLIC METHODS                                 *
     **************************************************/
    
    /// Return a hexadecimal hash from a file
    static public func hexString(fromFile filename:String) -> String? {
        return hexString(SHA1.dataFromFile(named: filename))
    }
    
    /// Return the hash of a file as an array of Ints
    public static func hash(fromFile filename:String) -> [Int]? {
        return dataFromFile(named: filename)?.h.map{Int($0)}
    }
    
    /// Return a hexadecimal hash from NSData
    public static func hexString(from data: inout Data) -> String? {
        return hexString(SHA1.process(data: &data))
    }
    
    /// Return the hash of NSData as an array of Ints
    public static func hash(from data: inout Data) -> [UInt32]? {
        return process(data: &data)?.h
    }
    
    /// Return a hexadecimal hash from a string
    public static func hexString(from str:String) -> String? {
        guard var data = str.data(using: .utf8) else { return nil }
        return hexString(SHA1.process(data: &data))
    }
    
    /// Return the hash of a string as an array of Ints
    public static func hash(from str:String) -> [Int]? {
        guard var data = str.data(using: .utf8) else { return nil }
        return process(data: &data)?.h.map{Int($0)}
    }
}
