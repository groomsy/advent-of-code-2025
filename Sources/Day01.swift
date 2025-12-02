import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Rotation] {
    data.split(separator: "\n").map {
      let direction = Direction(rawValue: String($0.first!))!
      let value = Int($0.dropFirst())!
      return Rotation(direction: direction, value: value)
    }
  }

  func part1() -> Any {
    var zeroCount = 0
    var value = 50
    for entity in entities {
      switch entity.direction {
      case .left:
        value = (value - entity.value) % 100
      case .right:
        value = (value + entity.value) % 100
      }
      
      if value == 0 {
        zeroCount += 1
      }
    }
    
    return zeroCount
  }

  func part2() -> Any {
    var zeroCount = 0
    var value = 50
    for entity in entities {
      // Bump the zeroCount by the number of full rotations
      let rotations = entity.value / 100
      zeroCount += rotations
      
      switch entity.direction {
      case .left:
        var newValue = value - entity.value % 100
        if newValue <= 0 {
          newValue = (100 - abs(newValue)) % 100
          
          if value > 0 {
            zeroCount += 1
          }
        }
        value = newValue
      case .right:
        let newValue = value + entity.value % 100
        if value < 100, newValue > 99 {
          value = newValue % 100
          zeroCount += 1
        } else {
          value = newValue
        }
      }
    }
    
    return zeroCount
  }
}

enum Direction: String {
  case left = "L", right = "R"
}

struct Rotation: CustomStringConvertible {
  let direction: Direction
  let value: Int
  
  var description: String {
    "\(direction.rawValue)\(value)"
  }
}
