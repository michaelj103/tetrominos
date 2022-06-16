//
//  Types.swift
//  
//
//  Created by Michael Brandt on 6/14/22.
//

struct Point : Hashable {
    let x: Int
    let y: Int
    
    func pointAbove() -> Point {
        return Point(x: x, y: y-1)
    }
    
    func pointBelow() -> Point {
        return Point(x: x, y: y+1)
    }
    
    func pointRight() -> Point {
        return Point(x: x+1, y: y)
    }
    
    func pointLeft() -> Point {
        return Point(x: x-1, y: y)
    }
    
    func pointUpLeft() -> Point {
        return Point(x: x-1, y: y-1)
    }
    
    func pointUpRight() -> Point {
        return Point(x: x+1, y: y-1)
    }
    
    func pointDownLeft() -> Point {
        return Point(x: x-1, y: y+1)
    }
    
    func pointDownRight() -> Point {
        return Point(x: x+1, y: y+1)
    }
}

struct Size {
    let width: Int
    let height: Int
}

struct PlacedPiece {
    let id: Int
    let rotation: Int
    let position: Point
}
