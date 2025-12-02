import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [ClosedRange<Int>] {
    data.split(separator: ",").map {
      let components = $0.split(separator: "-").compactMap {
        Int(String($0.trimmingCharacters(in: .whitespacesAndNewlines)))
      }
      return components.first!...components.last!
    }
  }

  /// For each ID in the range, first ensure the length is divisible by two.
  /// Find the midpoint. Create two halves. If the first and second half are equal, it's bad.
  func part1() -> Any {
    var badIDs: [Int] = []
    
    for entity in entities {
      for id in entity {
        let stringRepresentation = String(id)
        let digitCount = stringRepresentation.count
        guard digitCount % 2 == 0 else { continue }
        
        let start = stringRepresentation.startIndex
        let mid = digitCount / 2
        let midpoint = stringRepresentation.index(start, offsetBy: mid)
        let firstHalf = stringRepresentation[start..<midpoint]
        let secondHalf = stringRepresentation[midpoint...]
        if firstHalf == secondHalf {
          badIDs.append(id)
        }
      }
    }
    
    return badIDs.reduce(0, +)
  }

  /// For each ID in the range, build a substring for each range from 0...0 to 0...MidPoint.
  /// Replace all occurrences of the substring with an empty string.
  /// If the result is an empty string, then we know it's bad.
  /// Ensure we throw out any single digit IDs.
  func part2() -> Any {
    var badIDs: [Int] = []
    
    for entity in entities {
      for id in entity {
        let stringRepresentation = String(id)
        let start = stringRepresentation.startIndex
        
        let digitCount = stringRepresentation.count
        guard digitCount > 1 else { continue }
        
        let mid = digitCount / 2
        
        for offset in 1...mid {
          let index = stringRepresentation.index(start, offsetBy: offset)
          let substring = stringRepresentation[start..<index]
          let stripped = stringRepresentation.replacingOccurrences(of: substring, with: "")
          if stripped.isEmpty {
            badIDs.append(id)
            break
          }
        }
      }
    }
    
    return badIDs.reduce(0, +)
  }
}
