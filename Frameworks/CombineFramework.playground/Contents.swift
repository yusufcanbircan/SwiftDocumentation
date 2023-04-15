import UIKit
import Combine
import PlaygroundSupport

/// Publisher and Subscriber
/// A publisher publishes values which you can receive from a subscriber.
/// Publishers publish the objects one by one, and subscribers receive them one by one and perform its operators.
///
/// 'Just' keyword publishes just one object.
let justPublisher = Just(25)

///You need to subscribe to specific publisher to receive objects
let justSubscription = justPublisher
    .sink { receivedValue in
        print(receivedValue)
    }

/// You can publish a sequence's values
let sequencePublisher = ["Apple", "Google", "Microsoft", "Arabam.com"].publisher
/// It publishes the values of the sequence one by one

let sequenceSubscription = sequencePublisher /// receives each published value and performs the operations
    .sink { sequenceValues in
        print("The brand \(sequenceValues)")
    }

/// You can assign the published value to a property with assign operator.
class AssignClass {
    var property: String = "" {
        didSet {
            print("the new value of property \(property)")
        }
    }
}

var assignObject = AssignClass()
var assignPublisher = ["Ali", "Cansu", "Yusuf", "Veli"].publisher
var assignSubscription = assignPublisher.assign(to: \.property, on: assignObject)
// to wants the property which you want to assign the values, on means the scope of property.


/*PlaygroundPage.current.needsIndefiniteExecution = true

var subscription: Cancellable? = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .print("stream")
    .scan(0, { count, _ in
        return count + 1
    })
    .filter({ $0>5 && $0 < 16})
    .sink { output in
        print("finished stream with \(output)")
    } receiveValue: { value in
        print("receive value \(value)")
    }

RunLoop.main.schedule(after: .init(Date(timeIntervalSinceNow: 20))) {
    //subscription.cancel()
    subscription = nil // -> if you use Cancellable type, then you can set it nil
}
 */

/*struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

var cancellables: [AnyCancellable] = []

URLSession.shared.dataTaskPublisher(for: url)
    .tryMap({ element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return element.data
    })
    .decode(type: Post.self, decoder: JSONDecoder())
    .sink { response in
        print(response)
    } receiveValue: { data in
        print(data)
    }
    .store(in: &cancellables)
*/
//
//let foodBank = ["Apple", "Orange", "Banana", "Lemon"].publisher
//
//var timer = Timer.publish(every: 1, on: .main, in: .common)
//    .autoconnect()
//
//let subscription = foodBank.zip(timer)
//    .sink { completion in
//        print("Completion \(completion)")
//    } receiveValue: { value in
//        print(value)
//    }

