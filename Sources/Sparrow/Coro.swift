
func coro(ch: Channel<Int, String>) {
  while true {
    ch.send(ch.receive() % 2 == 0 ? "even" ? "odd")
  }
}

let inCh = Channel<Int>()
let outCh = Channel<Str>()

let coro = go {
  while true {
    outCh.send(inCh.receive() % 2 == 0 ? "even" : "odd")
  }
}

for x in 0..<5 {
  inCh.send(x)
}

coro.cancel()


func* gen() -> Generator<Int> {
  for i in 0..<5 {
    yield i
  }
}

func* gen2(g1: Generator<Int>) -> Generator<Int> {
  for i in g1 {
    yield i + 1
  }
}

func* sockerReader() -> Coroutine<Data, Data> {

}

func* downloader(url: String) -> Generator<Data> {
  let loop = RunLoop.current


}

func* download(url: String) -> Generator<JSON> {
  let data = yield from downloader(url)
  return parse(data)
}

for i in gen() {
  print(i)
}