import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  /// Naive implementation. Relies heavily on string manipulation.
  /// Iterate through "bank" which is the numbers in a string.
  /// Find the max joltage in the bank by concatenating the digits
  /// together and converting to an Int.
  func part1() -> Any {
    var batteryCombinations: [Int] = []
    
    for entity in entities {
      var maxJoltageInBank = 0
      
      for leadingIndex in 0..<entity.count {
        let firstDigitIndex = entity.index(entity.startIndex, offsetBy: leadingIndex)
        let firstDigit = entity[firstDigitIndex]
        
        for trailingIndex in (leadingIndex + 1)..<entity.count {
          let secondDigitIndex = entity.index(entity.startIndex, offsetBy: trailingIndex)
          let secondDigit = entity[secondDigitIndex]
          
          let joltage = Int("\(firstDigit)\(secondDigit)")!
          
          maxJoltageInBank = max(maxJoltageInBank, joltage)
        }
      }
      
      batteryCombinations.append(maxJoltageInBank)
    }
    
    return batteryCombinations.reduce(0, +)
  }

  /// A little smarter of an implementation. Make the bank an array of Int digits.
  /// The "searchable" area is the count (12 for part2) minus one. Find the max
  /// digit and store it. Then cut off the front of the bank and run again. Do this
  /// until current has decremented from count - 1 to zero.
  func part2() -> Any {
    let count = 12
    var joltsPerBank: [Int] = []
    
    let entities = entities.map { $0.map { Int(String($0))! } }
    
    for var entity in entities {
      var joltDigits: [Int] = []
      
      for current in stride(from: count - 1, through: 0, by: -1) {
        let searchable = entity.dropLast(current)
        let index = searchable.firstIndex(of: searchable.max()!)!
        joltDigits.append(searchable[index])
        let droppable = searchable.distance(from: searchable.startIndex, to: index) + 1
        entity = entity.dropFirst(droppable).map { Int($0) }
      }
      
      var jolt = joltDigits.removeFirst()
      for digit in joltDigits {
        jolt = jolt * 10 + digit
      }
      
      joltsPerBank.append(jolt)
    }
    
    return joltsPerBank.reduce(0, +)
  }
}
