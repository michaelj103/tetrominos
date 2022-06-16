//
//  PieceBoard.swift
//  
//
//  Created by Michael Brandt on 6/15/22.
//

class PieceBoard {
    let size: Size
    private var filledSpaces: [Bool]
    
    init(_ size: Size) {
        precondition(size.width > 0 && size.height > 0)
        self.size = size
        self.filledSpaces = [Bool](repeating: false, count: size.width * size.height)
    }
    
    func nextAvailable() -> Point? {
        guard let idx = filledSpaces.firstIndex(of: false) else {
            return nil
        }
        
        let x = idx % size.width
        let y = idx / size.width
        return Point(x: x, y: y)
    }
    
    func clear() {
        for i in 0..<filledSpaces.count {
            filledSpaces[i] = false
        }
    }
    
    func addPiece(_ piece: PieceRotation, at point: Point) -> Bool {
        assert(point.x >= 0 && point.y >= 0)
        for piecePoint in piece.pips {
            let fillPoint = Point(x: point.x + piecePoint.x, y: point.y + piecePoint.y)
            if !_canFill(at: fillPoint) {
                return false
            }
        }
        for piecePoint in piece.pips {
            let fillPoint = Point(x: point.x + piecePoint.x, y: point.y + piecePoint.y)
            _fill(at: fillPoint)
        }
        return true
    }
    
    func removePiece(_ piece: PieceRotation, at point: Point) {
        assert(point.x >= 0 && point.y >= 0)
        for piecePoint in piece.pips {
            let fillPoint = Point(x: point.x + piecePoint.x, y: point.y + piecePoint.y)
            _unfill(at: fillPoint)
        }
    }
    
    private func _canFill(at pt: Point) -> Bool {
        guard pt.x < size.width && pt.y < size.height else {
            return false
        }
        let idx = (pt.y * size.width) + pt.x
        return !filledSpaces[idx]
    }
    
    private func _fill(at pt: Point) {
        assert(pt.x >= 0 && pt.x < size.width && pt.y >= 0 && pt.y < size.height)
        let idx = (pt.y * size.width) + pt.x
        filledSpaces[idx] = true
    }
    
    private func _unfill(at pt: Point) {
        assert(pt.x >= 0 && pt.x < size.width && pt.y >= 0 && pt.y < size.height)
        let idx = (pt.y * size.width) + pt.x
        filledSpaces[idx] = false
    }
}
