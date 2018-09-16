// The playground to demonstrate recursiveFlatten using reference and stack.

typealias TestCase = (input: [Any], expected: [Int])

let cases: [TestCase] = [
    // One dimension array
    (input: [1], expected: [1]),
    (input: [1, 2, 3], expected: [1, 2, 3]),

    // Empty array
    (input: [], expected: []),
    (input: [[]], expected: []),
    (input: [[[]]], expected: []),
    (input: [[], []], expected: []),
    (input: [[], [[]]], expected: []),
    (input: [[[[]], []], [], [[]]], expected: []),

    // Mix
    (input: [[1], 2, 3], expected: [1, 2, 3]),
    (input: [1, [2], 3], expected: [1, 2, 3]),
    (input: [1, 2, [3]], expected: [1, 2, 3]),
    (input: [[[1, 2]], [], [[3], 4], 5], expected: [1, 2, 3, 4, 5])
]

for `case` in cases {
    let resultReference = `case`.input.recursiveFlatten_Reference()

    if let array = Array(resultReference) as? [Int] {
        if array != `case`.expected {
            fatalError("Incorrect result: \(array), expected: \(`case`.expected)")
        }
    }
    else {
        fatalError("Unexpected type: \(resultReference)")
    }

    let resultStack = `case`.input.recursiveFlatten_Stack()

    if let array = Array(resultStack) as? [Int] {
        if array != `case`.expected {
            fatalError("Incorrect result: \(array), expected: \(`case`.expected)")
        }
    }
    else {
        fatalError("Unexpected type: \(resultStack)")
    }
}
