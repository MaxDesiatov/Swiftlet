@testable import SwiftletKit
import XCTest

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
    let url = FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )[0]
    let fileURL = url.appendingPathComponent("test.swiftlet")
    try? data.write(to: fileURL)
    print(fileURL)

    let reader = LineReader(path: fileURL.path, chunkLength: 2)

    var lines = [Substring]()
    while let results = reader?.next(), !results.isEmpty {
      lines += results.compactMap { $0.success }
    }

    let testLines = testFile.split(
      separator: "\n",
      omittingEmptySubsequences: false
    )

    XCTAssertEqual(testLines.count, lines.count)
    for i in 0..<testLines.count {
      XCTAssertEqual(testLines[i], lines[i])
    }

    try? lines.joined(separator: "\n").write(
      to: fileURL.appendingPathExtension("blah"),
      atomically: true,
      encoding: .utf8
    )
    XCTAssertEqual(lines.joined(separator: "\n"), testFile)
  }

  func testTypeConstructor() throws {
    let input = "Dictionary  String   Int"
    let result = try typeConstructor.run(sourceName: "", input: input)

    XCTAssertEqual(result, TypeExpression
      .constructor("Dictionary", ["String", "Int"]))

    measure {
      _ = try? typeConstructor.run(sourceName: "", input: input)
    }
  }

  func testVoid() throws {
    let input = "()"
    let result = try tupleType.run(sourceName: "", input: input)

    XCTAssertEqual(result, TypeExpression
      .tuple([]))

    measure {
      _ = try? tupleType.run(sourceName: "", input: input)
    }
  }

  func testTriple() throws {
    let input = "( Array Int , Dictionary  Int   Bool  )"
    let result = try tupleType.run(sourceName: "", input: input)

    XCTAssertEqual(result, TypeExpression
      .tuple([.constructor("Array", ["Int"]),
              .constructor("Dictionary", ["Int", "Bool"])]))

    measure {
      _ = try? tupleType.run(sourceName: "", input: input)
    }
  }

//  func testSignature() throws {
//    let input = " f :"
//    let result = try parser.run(sourceName: "", input: input)
//    XCTAssertEqual(
//      result, Declaration.signature(Signature(name: "f", type: .tuple([])))
//    )
//
//    measure {
//      _ = try? parser.run(sourceName: "", input: input)
//    }
//  }

  func testIntExpression() throws {
    let input = "1+2*4-8+((3-12)/8)+(-71)+2^2^3"
    let result = try parsec(input: input)
    XCTAssertEqual(result, 185)

    measure {
      _ = try? parsec(input: input)
    }
  }

  static var allTests = [
    ("testIntExpression", testIntExpression),
    ("testLineReader", testLineReader),
  ]
}
