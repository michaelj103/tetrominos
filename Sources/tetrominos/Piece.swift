//
//  Piece.swift
//  
//
//  Created by Michael Brandt on 6/14/22.
//

class Piece {
    let name: String
    let rotations: [PieceRotation]
    let pipCount: Int
    
    init(_ name: String, points: [Point]) {
        self.name = name
        self.pipCount = points.count
        rotations = Piece._generateRotations(points)
    }
    
    private static func _generateRotations<S: Sequence>(_ points: S) -> [PieceRotation] where S.Element == Point {
        var rotations = [PieceRotation]()
        let baseRotation = PieceRotation(points)
        rotations.append(baseRotation)
        
        var currentPoints = _rotatedPoints(points)
        for _ in 0..<3 {
            // up to 3 more rotations
            let nextRotation = PieceRotation(currentPoints)
            if rotations.contains(nextRotation) {
                break
            }
            rotations.append(nextRotation)
            currentPoints = _rotatedPoints(currentPoints)
        }
        
        return rotations
    }
    
    private static func _rotatedPoints<S: Sequence>(_ points: S) -> [Point] where S.Element == Point {
        var rotatedPoints = [Point]()
        var minY = Int.max
        for pt in points {
            let rotatedPoint = Point(x: pt.y, y: -pt.x)
            if rotatedPoint.y < minY {
                minY = rotatedPoint.y
            }
            rotatedPoints.append(rotatedPoint)
        }
        
        for i in 0..<rotatedPoints.count {
            let currentPoint = rotatedPoints[i]
            let shiftedPoint = Point(x: currentPoint.x, y: currentPoint.y - minY)
            rotatedPoints[i] = shiftedPoint
        }
        return rotatedPoints
    }
    
}

