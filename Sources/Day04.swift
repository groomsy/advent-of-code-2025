import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      var rollIndices: [Int] = []
      for (index, character) in $0.enumerated() where character == "@" {
        rollIndices.append(index)
      }
      return rollIndices
    }
  }

  /// Make use of the constant lookup time of a Set.
  /// Since the entities are split up into an array of arrays, where each member of the inner array is the index of a found roll,
  /// we can quickly look above and below, flipping between indices to find the eight adjacent spots.
  func findRowsThatCanBeRemoved(_ entities: [[Int]]) -> [Int:Set<Int>] {
    var canBeRemoved: [Int:Set<Int>] = [:]
    
    let entities = entities
    for (rowIndex, row) in entities.enumerated() {
      let rowSet = Set(row)
      for rollIndex in row {
        // rollIndex is where a roll was found (where an '@' was seen)
        var adjacentRollCount = 0
        
        // Look to the left and right
        adjacentRollCount += rowSet.contains(rollIndex - 1) ? 1 : 0
        adjacentRollCount += rowSet.contains(rollIndex + 1) ? 1 : 0
        
        // Look above, above diagonal left, above diagonal right
        let previousRowSet = rowIndex > 0 ? Set(entities[rowIndex - 1]) : []
        adjacentRollCount += previousRowSet.contains(rollIndex - 1) ? 1 : 0
        adjacentRollCount += previousRowSet.contains(rollIndex) ? 1 : 0
        adjacentRollCount += previousRowSet.contains(rollIndex + 1) ? 1 : 0
        
        // If we haven't exceeded our threshold, check below, below diagonal left, below diagonal right
        if adjacentRollCount < 4 {
          let nextRowSet = rowIndex < (entities.count - 1) ? Set(entities[rowIndex + 1]) : []
          adjacentRollCount += nextRowSet.contains(rollIndex - 1) ? 1 : 0
          adjacentRollCount += nextRowSet.contains(rollIndex) ? 1 : 0
          adjacentRollCount += nextRowSet.contains(rollIndex + 1) ? 1 : 0
        }
        
        // Only track this for removal if we're below our threshold
        if adjacentRollCount < 4 {
          var canBeRemovedInRow = canBeRemoved[rowIndex, default: []]
          canBeRemovedInRow.insert(rollIndex)
          canBeRemoved[rowIndex] = canBeRemovedInRow
        }
      }
    }
    return canBeRemoved
  }
  
  func part1() -> Any {
    let canBeRemoved: [Int:Set<Int>] = findRowsThatCanBeRemoved(entities)
    return canBeRemoved.map({$0.value.count}).reduce(0, +)
  }

  /// Multiple passes. We will check what can be removed, remove, then repeat.
  func part2() -> Any {
    var entities = entities
    
    var count = 0
    var canBeRemoved: [Int:Set<Int>] = [:]
    repeat {
      canBeRemoved = findRowsThatCanBeRemoved(entities)
      count += canBeRemoved.map({$0.value.count}).reduce(0, +)
      
      var entitiesPostRemoval: [[Int]] = []
      for (rowIndex, row) in entities.enumerated() {
        guard let removals = canBeRemoved[rowIndex] else {
          entitiesPostRemoval.append(row)
          continue
        }
        
        var mutableRow = Set(row)
        for removal in removals {
          mutableRow.remove(removal)
        }
        entitiesPostRemoval.append(Array(mutableRow))
      }
      
      entities = entitiesPostRemoval
    } while !canBeRemoved.isEmpty
    return count
  }
}
