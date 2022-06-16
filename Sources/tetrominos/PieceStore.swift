//
//  PieceStore.swift
//  
//
//  Created by Michael Brandt on 6/15/22.
//

class PieceStore {
    private var pieces = [Piece]()
    private var idByName = [String:Int]()
    
    private var initialCountsByID = [Int]()
    private var currentCountsByID = [Int]()
    private(set) var numIDs = 0
    
    init() {
        _registerDefaultPieces()
    }
    
    func totalPips() -> Int {
        var sum = 0
        for (id, count) in initialCountsByID.enumerated() {
            let piece = pieces[id]
            sum += (piece.pipCount * count)
        }
        return sum
    }
    
    func getID(for name: String) -> Int? {
        let lower = name.lowercased()
        return idByName[lower]
    }
    
    func getPiece(for id: Int) -> Piece {
        return pieces[id]
    }
    
    func registerInitialCount(_ id: Int, count: Int) -> Bool {
        guard id < pieces.count, count > 0 else {
            return false
        }
        
        initialCountsByID[id] += count
        currentCountsByID[id] += count
        return true
    }
    
    func clearRegistrations() {
        for i in 0..<pieces.count {
            initialCountsByID[i] = 0
            currentCountsByID[i] = 0
        }
    }
    
    func clearCheckouts() {
        currentCountsByID = initialCountsByID
    }
    
    func checkOutPiece(_ id: Int) -> Bool {
        guard id < pieces.count else {
            return false
        }
        
        let currentCount = currentCountsByID[id]
        if currentCount > 0 {
            currentCountsByID[id] = currentCount - 1
            return true
        } else {
            return false
        }
    }
    
    func checkInPiece(_ id: Int) {
        guard id < pieces.count else {
            preconditionFailure()
        }
        
        let newCount = currentCountsByID[id] + 1
        precondition(newCount <= initialCountsByID[id])
        currentCountsByID[id] = newCount
    }
    
    private func _registerDefaultPieces() {
        let tPiece = Piece("T", points: [Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 2, y: 1)])
        _registerPiece(tPiece)
        let lPiece = Piece("L", points: [Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 0, y: 2), Point(x: 1, y: 2)])
        _registerPiece(lPiece)
        let jPiece = Piece("J", points: [Point(x: 1, y: 0), Point(x: 1, y: 1), Point(x: 1, y: 2), Point(x: 0, y: 2)])
        _registerPiece(jPiece)
        let iPiece = Piece("I", points: [Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 0, y: 2), Point(x: 0, y: 3)])
        _registerPiece(iPiece)
        let sPiece = Piece("S", points: [Point(x: 1, y: 0), Point(x: 2, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)])
        _registerPiece(sPiece)
        let zPiece = Piece("Z", points: [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 1, y: 1), Point(x: 2, y: 1)])
        _registerPiece(zPiece)
        let oPiece = Piece("O", points: [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)])
        _registerPiece(oPiece)
        
        initialCountsByID = [Int](repeating: 0, count: pieces.count)
        currentCountsByID = [Int](repeating: 0, count: pieces.count)
        numIDs = pieces.count
    }
    
    private func _registerPiece(_ piece: Piece) {
        let id = pieces.count
        pieces.append(piece)
        idByName[piece.name.lowercased()] = id
    }
}

