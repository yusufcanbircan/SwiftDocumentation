import UIKit
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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




