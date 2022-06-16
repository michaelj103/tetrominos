//
//  PiecePrinter.swift
//  
//
//  Created by Michael Brandt on 6/15/22.
//

class PiecePrinter {
    
    static func GenerateString(_ piece: PieceRotation) -> String {
        let printer = PiecePrinter(piece.size)
        
        for y in 0..<(piece.size.height) {
            for x in 0..<(piece.size.width) {
                let pt = Point(x: x, y: y)
                let characters = piece.characters(at: pt)
                printer.addCharacters(characters, piecePoint: pt)
            }
        }
        
        let string = printer.generateString()
        return string
    }
    
    static func GenerateString(_ dimensions: Size, placements: [PlacedPiece], store: PieceStore) -> String {
        let printer = PiecePrinter(dimensions)
        
        for placement in placements {
            let piece = store.getPiece(for: placement.id)
            let rotation = piece.rotations[placement.rotation]
            for point in rotation.pips {
                let characters = rotation.characters(at: point)
                let boardPoint = Point(x: point.x + placement.position.x, y: point.y + placement.position.y)
                printer.addCharacters(characters, piecePoint: boardPoint)
            }
        }
        
        let string = printer.generateString()
        return string
    }
        
    private let size: Size
    private var characters: [Character]
    private let charSize: Size
    
    private init(_ size: Size) {
        precondition(size.width > 0 && size.height > 0)
        self.size = size
        
        let charactersWide = size.width * 3
        let charactersHigh = size.height * 2
        self.characters = [Character](repeating: " ", count: charactersWide * charactersHigh)
        self.charSize = Size(width: charactersWide, height: charactersHigh)
    }
    
    private func addCharacters(_ inChars: [Character], piecePoint: Point) {
        let firstRowStart = ((piecePoint.y * 2) * charSize.width) + (piecePoint.x * 3)
        let secondRowStart = firstRowStart + charSize.width
        
        characters[firstRowStart] = inChars[0]
        characters[firstRowStart+1] = inChars[1]
        characters[firstRowStart+2] = inChars[2]
        
        characters[secondRowStart] = inChars[3]
        characters[secondRowStart+1] = inChars[4]
        characters[secondRowStart+2] = inChars[5]
    }
    
    private func generateString() -> String {
        var string = ""
        string.reserveCapacity((charSize.width + 1) * (charSize.height))
        for y in 0..<(charSize.height) {
            for x in 0..<(charSize.width) {
                let idx = (charSize.width * y) + x
                string.append(characters[idx])
            }
            string.append("\n")
        }
        return string
    }
}


fileprivate extension PieceRotation {
    func characters(at point: Point) -> [Character] {
        var characters = [Character](repeating: " ", count: 6)
        guard self.contains(point) else {
            return characters
        }
        
        let blank = Character(" ")
        let upperLeftCorner = Character("\u{250C}")
        let upperRightCorner = Character("\u{2510}")
        let lowerLeftCorner = Character("\u{2514}")
        let lowerRightCorner = Character("\u{2518}")
        let horizontal = Character("\u{2500}")
        let vertical = Character("\u{2502}")
        
        // have a pip at this point, printing is based on adjacent
        let pipAbove = self.contains(point.pointAbove())
        let pipBelow = self.contains(point.pointBelow())
        let pipRight = self.contains(point.pointRight())
        let pipLeft = self.contains(point.pointLeft())
        
        
        // top left corner
        if pipAbove && pipLeft {
            characters[0] = self.contains(point.pointUpLeft()) ? blank : lowerRightCorner
        } else if pipAbove && !pipLeft {
            characters[0] = vertical
        } else if !pipAbove && pipLeft {
            characters[0] = horizontal
        } else if !pipAbove && !pipLeft {
            characters[0] = upperLeftCorner
        }
        
        // top
        if pipAbove {
            characters[1] = blank
        } else {
            characters[1] = horizontal
        }
        
        // top right corner
        if pipAbove && pipRight {
            characters[2] = self.contains(point.pointUpRight()) ? blank : lowerLeftCorner
        } else if pipAbove && !pipRight {
            characters[2] = vertical
        } else if !pipAbove && pipRight {
            characters[2] = horizontal
        } else if !pipAbove && !pipRight {
            characters[2] = upperRightCorner
        }
        
        // bottom left corner
        if pipBelow && pipLeft {
            characters[3] = self.contains(point.pointDownLeft()) ? blank : upperRightCorner
        } else if pipBelow && !pipLeft {
            characters[3] = vertical
        } else if !pipBelow && pipLeft {
            characters[3] = horizontal
        } else if !pipBelow && !pipLeft {
            characters[3] = lowerLeftCorner
        }
        
        // bottom
        if pipBelow {
            characters[4] = blank
        } else {
            characters[4] = horizontal
        }
        
        // bottom right corner
        if pipBelow && pipRight {
            characters[5] = self.contains(point.pointDownRight()) ? blank : upperLeftCorner
        } else if pipBelow && !pipRight {
            characters[5] = vertical
        } else if !pipBelow && pipRight {
            characters[5] = horizontal
        } else if !pipBelow && !pipRight {
            characters[5] = lowerRightCorner
        }
        
        return characters
    }
}

