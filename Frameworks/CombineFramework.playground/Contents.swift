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
print("the last value of property \(assignObject.property)")


/// PassthroughtSubject is also a publisher that relays values it receives from other publishers.
let relay = PassthroughSubject<String, Never>()
/// it publishes the datas to its subscribers

let relaySubscription = relay
    .sink { relayVaule in
        print("Relay value PassthroughSubject -> \(relayVaule)")
    }

/// .send method used to publish datas.
relay.send("Hello")
relay.send("World!")

/// more than one subscribers can receive the data which published.
let relaySubscription2 = relay
    .sink { relayValue in
        print("Relay value 2 PassthroughSubject -> \(relayValue)")
    }

relay.send("Hello 2")

let relayPublisher = ["1", "2", "3"].publisher
/// by using subscribe method, we can publish the datas through PassthroughSubject.
relayPublisher.subscribe(relay)



/// CurrentValueSubject is similar with PassthroughSubject, but there is a difference,
/// CurrentValueSubject holds the last value
///
/// For Example; we may want to know if the user is sign in or not on a couple page,
/// here we use it to know if the user authenticate or not.
///

enum AuthenticationState {
    case authenticated(token: String)
    case unauthenticated
}

class AuthenticationManager {
    private let subject = CurrentValueSubject<AuthenticationState, Never>(.unauthenticated)
    
    var authenticationStatePublisher: AnyPublisher<AuthenticationState, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func authenticate(username: String, password: String) {
        // authenticate user and get the token
        let token = "sample_token"
        subject.send(.authenticated(token: token))
    }
    func signOut() {
        subject.send(.unauthenticated)
    }
}

let authenticationManager = AuthenticationManager()

let cancellable = authenticationManager.authenticationStatePublisher.sink { state in
    print("authentication state changed \(state)")
}

/// default state before you sign in
authenticationManager.authenticationStatePublisher.sink { state in
    print(state)
}

/// authenticate the user
authenticationManager.authenticate(username: "yusuf", password: "yusuf")

/// after you sign in
authenticationManager.authenticationStatePublisher.sink { state in
    print(state)
}

authenticationManager.signOut()

cancellable.cancel()

/// handleEvents operator lets you to handle all the stages of the subscription lifecycle.
///

enum ExampleError: Swift.Error {
    case somethingWentWrong
}

let relay1 = PassthroughSubject<String, ExampleError>()
relay1
    .handleEvents(receiveSubscription: { subscription in
        print("new subscription \(subscription)")
    }, receiveOutput: { value in
        print("received new value \(value)")
    }, receiveCompletion: { completion in
        print("a subscription completion  \(completion)")
    }, receiveCancel: {
        print("a subscription cancelled")
    })
    .replaceError(with: "Failure")
    .sink { value in
        print("handleevent received value \(value)")
    }

relay1.send("GoodNews")
relay1.send("newS")
relay1.send(completion: .failure(.somethingWentWrong))


/// Subscriptions returns Cancellable objects, it makes sure you are not retaining any referances.
///

class MyClass {
    var cancellable: Cancellable? = nil
    var variable: Int = 0 {
        didSet {
            print("MyClass object.variable = \(variable)")
        }
    }

    init(subject: PassthroughSubject<Int,Never>) {
        cancellable = subject.sink { value in
            // the self is retaining cycle.
            self.variable += value
        }
    }

    deinit {
        print("MyClass object deallocated")
    }
}

func emitNextValue(from values: [Int], after delay: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        var array = values
        subject.send(array.removeFirst())
        if !array.isEmpty {
            emitNextValue(from: array, after: delay)
        }
    }
}

let subject = PassthroughSubject<Int,Never>()
var object: MyClass? = MyClass(subject: subject)

emitNextValue(from: [1,2,3,4,5,6,7,8], after: 0.5)

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("Nullify object")
    object?.cancellable = nil
    object = nil
}


/// combine operators like .map, works like swift basic operators.
///

let operatorPublisher = PassthroughSubject<Int, Never>()

let operatorPublisher1 = operatorPublisher.map { value in
    value + 100
}

let operatorSubscription = operatorPublisher.sink { value in
    print("Operator subscription value \(value)")
}

let operatorSubscription1 = operatorPublisher1.sink { value in
    print("Operator subscription1 value \(value)")
}

operatorPublisher.send(15)
operatorPublisher.send(10)

operatorSubscription.cancel()
operatorSubscription1.cancel()


/// filter operation
let operatorPublisher2 = operatorPublisher.filter {
    ($0 % 2) == 0
}

let operatorSubscription2 = operatorPublisher2.sink { value in
    print("Operator subscription2 value \(value)")
}

operatorPublisher.send(12)
operatorPublisher.send(17)
operatorPublisher.send(24)


/// a URLSessionTaskPublisher
///

struct DecodableExample: Decodable { }

URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.avanderlee.com/feed/")!)
    .map { $0.data }
    .decode(type: DecodableExample.self, decoder: JSONDecoder())

/// a Notification Publisher
///

NotificationCenter.default.publisher(for: .NSCalendarDayChanged)

/// KeyPath Binding to NSObject instance
///

let nameLabel = UILabel()
Just("Yusuf")
    .map{ "Name is \($0)" }
    .assign(to: \.text, on: nameLabel)








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

