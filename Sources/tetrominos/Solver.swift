//
//  Solver.swift
//  
//
//  Created by Michael Brandt on 6/15/22.
//

fileprivate enum SolverState {
    case Placing
    case Backtracking
    case Done
}

class Solver {
    private let board: PieceBoard
    private let store: PieceStore
    private var placedPieces = [PlacedPiece]()
    private var state = SolverState.Placing
    
    private var maxSolutions: Int = Int.max
    private var allSolutions = [[PlacedPiece]]()
    
    init(_ dimensions: Size, store: PieceStore) {
        self.board = PieceBoard(dimensions)
        self.store = store
    }
    
    func run(maxSolutions: Int = Int.max) -> [[PlacedPiece]] {
        board.clear()
        store.clearCheckouts()
        placedPieces = []
        state = .Placing
        self.maxSolutions = maxSolutions
        
        // basic sanity check first. Does the number of pips in available pieces match
        // the number we need to fill on the board and is that number non-zero
        let totalPips = store.totalPips()
        guard totalPips > 0 && totalPips == (board.size.width * board.size.height) else {
            print("Available pieces can't fill the board exactly")
            return []
        }
        
        _runInternal()
        return allSolutions
    }
    
    private func _runInternal() {
        while true {
            switch state {
            case .Placing:
                _placeNextPiece(startingID: 0, startingRotation: 0)
            case .Backtracking:
                _backtrack()
            case .Done:
                return
            }
        }
    }
    
    private func _placeNextPiece(startingID: Int, startingRotation: Int) {
        guard let nextPoint = board.nextAvailable() else {
            // we've placed all the pieces, so this is a solution
            allSolutions.append(placedPieces)
            if allSolutions.count >= maxSolutions {
                // We have the max requested solutions. Stop trying
                state = .Done
            } else {
                // Remove the last placed piece and keep looking for solutions
                state = .Backtracking
            }
            return
        }
        
        for pieceID in startingID..<store.numIDs {
            if !store.checkOutPiece(pieceID) {
                continue
            }
                        
            // checked out the piece
            let piece = store.getPiece(for: pieceID)
            let initialRotation = pieceID == startingID ? startingRotation : 0
            for (rotationID, rotation) in piece.rotations[initialRotation...].enumerated() {
                if rotation.topPipX > nextPoint.x {
                    // off the edge
                    continue
                }
                let rotationIDOffset = rotationID + initialRotation
                let placementPoint = Point(x: nextPoint.x - rotation.topPipX, y: nextPoint.y)
                if board.addPiece(rotation, at: placementPoint) {
                    // placed a piece! "recurse"
                    let placementState = PlacedPiece(id: pieceID, rotation: rotationIDOffset, position: placementPoint)
                    placedPieces.append(placementState)
//                    print("Placed \(piece.name)\(rotationIDOffset) at (\(placementPoint.x), \(placementPoint.y))")
                    return
                }
            }
            
            store.checkInPiece(pieceID)
        }
        
        // failed to place anything. Start backtracking
        state = .Backtracking
    }
    
    private func _backtrack() {
        if placedPieces.isEmpty {
            // We've backtracked from empty, there's nothing else we can do
            state = .Done
            return
        }
        // undo the last placement
        let lastPlacement = placedPieces.removeLast()
        let piece = store.getPiece(for: lastPlacement.id)
        let pieceRotation = piece.rotations[lastPlacement.rotation]
//        print("Removing \(piece.name)\(lastPlacement.rotation) from (\(lastPlacement.position.x), \(lastPlacement.position.y))")
        board.removePiece(pieceRotation, at: lastPlacement.position)
        store.checkInPiece(lastPlacement.id)
        
        // and start placing from where we left off
        state = .Placing
        _placeNextPiece(startingID: lastPlacement.id, startingRotation: lastPlacement.rotation + 1)
    }
}
