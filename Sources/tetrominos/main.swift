import Darwin
import TetrominoCore

let size = getDimensions()
let store = PieceStore()
addPieces(store)
let solver = Solver(size, store: store)
let maxSolutions = 1
let solutions = solver.run(maxSolutions: maxSolutions)

if solutions.count > 0 && solutions[0].count > 0 {
    if solutions.count > 1 {
        // only print solution descriptor if we found multiple
        let solutionDescriptor = solutions.count < maxSolutions ? "" : "at least "
        print("Found \(solutionDescriptor)\(solutions.count) solution\(solutions.count == 1 ? "" : "s")")
    }
    let firstSolution = solutions[0]
    let solutionString = PiecePrinter.GenerateString(size, placements: firstSolution, store: store)
    print(solutionString)
} else {
    print("No solution")
}

func readDimensions() -> Size? {
    print("Dimensions: ", terminator: "")
    guard let dimensionString = readLine() else {
        exit(0)
    }
    
    let substrings = dimensionString.split(separator: "x")
    guard substrings.count == 2 else {
        return nil
    }
    
    guard let width = Int(substrings[0]) else {
        return nil
    }
    guard let height = Int(substrings[1]) else {
        return nil
    }
    guard width > 0 && height > 0 else {
        return nil
    }
    
    return Size(width: width, height: height)
}

func getDimensions() -> Size {
    while true {
        if let dimensions = readDimensions() {
            return dimensions
        } else {
            print("Dimensions should be a string in the form \"WxH\" with positive width/height")
        }
    }
}

enum ParsingStage {
    case Start
    case Count
    case Name
}

func readPieces() -> [(String,Int)]? {
    print("Pieces: ", terminator: "")
    guard let pieceString = readLine() else {
        exit(0)
    }
    
    var pieces = [(String, Int)]()
    var currentCount = 0
    var currentName = ""
    var stage = ParsingStage.Start
    func addPiece() -> Bool {
        if stage == .Start {
            // restarted when we have nothing. Fine
            return true
        } else if stage == .Count {
            // restarted while parsing. Bad
            return false
        } else if currentCount == 0 {
            // finished with empty count. Bad
            return false
        }
        pieces.append((currentName, currentCount))
        currentCount = 0
        currentName = ""
        stage = .Start
        return true
    }
    
    for c in pieceString {
        if c.isWhitespace {
            if !addPiece() {
                return nil
            }
            continue
        }
        if !c.isASCII {
            return nil
        }
        if stage == .Start {
            stage = .Count
        }
        
        if let numberVal = c.wholeNumberValue {
            if stage == .Name {
                if !addPiece() {
                    return nil
                }
            }
            stage = .Count
            currentCount = (currentCount * 10) + numberVal
        } else {
            stage = .Name
            currentName.append(c)
        }
    }
    
    if !addPiece() {
        return nil
    }
    
    return pieces
}

func addPieces(_ store: PieceStore) {
    while true {
        if let pieces = readPieces() {
            var allValid = true
            for (name, count) in pieces {
                if let id = store.getID(for: name) {
                    if !store.registerInitialCount(id, count: count) {
                        allValid = false
                        break
                    }
                } else {
                    allValid = false
                    break
                }
            }
            if allValid {
                break
            } else {
                store.clearRegistrations()
            }
        } else {
            print("Pieces should be a string of counts and names, e.g. \"3t1o2i...\"")
        }
    }
}
