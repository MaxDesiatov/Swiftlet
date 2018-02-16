import Venice

class Future<T> {
  private var coroutine: Coroutine! = nil
  private let channel: Channel<T>
  private let deadline: Deadline
  private var result: T?
  private var error: Error?
  private var success: ((T) -> ())?
  private var failure: ((Error) -> ())?

  init(_ deadline: Deadline = .never, _ closure: @escaping () throws -> T) throws {
    channel = try Channel<T>()
    self.deadline = deadline

    coroutine = try Coroutine { [weak self] in
      do {
        let res = try closure()
        self?.result = res
        self?.success?(res)
        try self?.channel.send(res, deadline: deadline)
      } catch {
        self?.error = error
        self?.failure?(error)
      }
    }
  }

  func wait() throws -> T {
    return try channel.receive(deadline: deadline)
  }

  func then(_ success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
    if let error = error {
      failure?(error)
    } else if let result = result {
      success(result)
    } else {
      self.success = success
      self.failure = failure
    }
  }
}
class Generator<T>: Sequence, IteratorProtocol {
  private let channel: Channel<T>
  private var coroutine: Coroutine! = nil
  private var isFinished = false

  init(_ closure: @escaping ((T) -> ()) -> ()) {
    channel = try! Channel<T>()

    coroutine = try! Coroutine { [weak self] in
      closure { try! self?.channel.send($0, deadline: .never) }
      self?.isFinished = true
    }
  }

  func next() -> T? {
    return isFinished ? nil : try? channel.receive(deadline: .never)
  }
}


let future = try Future<Int> {
  try Coroutine.wakeUp(5.second.fromNow())
  return 42
}

let gen = Generator<Int> { yield in
  var i = 0
  var flag = true

  future.then({
    print("result is \($0)")
    flag = false
  }, failure: {
    print($0)
  })

  while flag {
    yield(i)
    i += 1
  }
}

for i in gen {
  print(i)

  try Coroutine.wakeUp(1.second.fromNow())
}

print("generator finished")
