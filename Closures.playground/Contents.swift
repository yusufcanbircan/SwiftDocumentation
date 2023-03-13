import UIKit

// Closures
// Group code that executes together, without creating a named function.

// The Sorted Method
// We have a method to sort something such as arrays.

// Here is an arrays that contains names.
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// We can sort the array with Sorted Method
// But we need to provide the way that will be sorted -> backward, forward etc.

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

// after declare the way, we can sort by that way.
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]

// We can sort with that way but we can prefer a shortest way like Closure Expression Syntax
// Closure Expression Syntax

{ (<#parameters#>) -> <#return type#> in
   <#statements#>
}
// This is a closure expression syntax
// The parameters in it can be in-out parameters, but they cant have a default value.

// Here is a example with closure expression syntax

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
// it is same as backward function.

// Because the sorting closure is passed as an argument to a method,
// Swift can infer the types of its parameters and the type of the value it returns.
// Inferring Type From Context

reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 })
// Note that this is same as previous two.

// Implicit Returns from Single-Expression Closures
// Because the closure’s body contains a single expression (s1 > s2) that returns a Bool value,
// there’s no ambiguity, and the return keyword can be omitted.
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

// Shorthand Argument Names
// Swift automatically provides shorthand argument names to inline closures,
// which can be used to refer to the values of the closure’s arguments by the names $0, $1, $2, and so on.
reversedNames = names.sorted(by: { $0 > $1 })
// Here, $0 and $1 refer to the closure’s first and second String arguments.

// Operator Methods
// There’s actually an even shorter way to write the closure expression above.
reversedNames = names.sorted(by: >)


// Trailing Closures
// If you need to pass a closure expression to a function as the function’s final argument and
// the closure expression is long, it can be useful to write it as a trailing closure instead.

func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// Here's how you call this function without using a trailing closure:

someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// Here's how you call this function with a trailing closure instead:

someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}

// The string-sorting closure from the Closure Expression Syntax section above can be
// written outside of the sorted(by:) method’s parentheses as a trailing closure:
reversedNames = names.sorted() { $0 > $1 }

// If a closure expression is provided as the function’s or method’s only argument and
// you provide that expression as a trailing closure, you don’t need to write a pair of
// parentheses () after the function or method’s name when you call the function:
reversedNames = names.sorted { $0 > $1 }


// Trailing closures are most useful when the closure is sufficiently long that
// it isn’t possible to write it inline on a single line.

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

// You can now use the numbers array to create an array of String values,
// by passing a closure expression to the array’s map(_:) method as a trailing closure:

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
// strings is inferred to be of type [String]
// its value is ["OneSix", "FiveEight", "FiveOneZero"]


// If a function takes multiple closures, you omit the argument label for
// the first trailing closure and you label the remaining trailing closures.

func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}

// When you call this function to load a picture, you provide two closures.

loadPicture(from: someServer) { picture in
    someView.currentPicture = picture
} onFailure: {
    print("Couldn't download the next picture.")
}


// Capturing Values
// A closure can capture constants and variables from the surrounding context in which it’s defined.

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
// The return type of makeIncrementer is () -> Int.
// This means that it returns a function, rather than a simple value.

let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen() // returns 10
incrementByTen() // returns 20
incrementByTen() // returns 30


let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven() // returns 7

incrementByTen() // returns 40
