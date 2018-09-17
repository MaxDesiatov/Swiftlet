import XCTest
@testable import SwiftletKit

let testFile =
"""
protocol P {
  var test: Int64 { get set }
  func f() -> Int64
}

class C: P {
  var test: Int64
  func f() -> Int64 {
    return test
  }
}
"""

class SwiftletTests: XCTestCase {
  func testLineReader() {
    let data = testFile.data(using: .utf8)!
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let fileURL = url.appendingPathComponent("test.swiftlet")
    try! data.write(to: fileURL)
    print(fileURL)

    let reader = LineReader(path: fileURL.path, chunkLength: 2)

    var lines = [Substring]()
    while let results = reader?.next(), !results.isEmpty {
      lines += results.compactMap { $0.success }
    }

    let testLines = testFile.split(separator: "\n", omittingEmptySubsequences: false)

    XCTAssertEqual(testLines.count, lines.count)
    for i in 0..<testLines.count {
      XCTAssertEqual(testLines[i], lines[i])
    }

    try! lines.joined(separator: "\n").write(to: fileURL.appendingPathExtension("blah"), atomically: true, encoding: .utf8)
    XCTAssertEqual(lines.joined(separator: "\n"), testFile)
  }


  static var allTests = [
    ("testLineReader", testLineReader),
  ]
}
