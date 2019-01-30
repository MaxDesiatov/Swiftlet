//
//  LineReader.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 17/09/2018.
//

import Foundation

/// This is implemented as a class as we don't want to create
/// readers using the same file handle by accident when assigning a reader
/// instance.
public final class LineReader: Producer {
  public typealias Output = Substring

  private let path: String
  private let handle: FileHandle
  private var leftoverChunk: Substring?
  private let chunkLength: Int

  public init?(path: String, chunkLength: Int = 120) {
    guard
      let handle = FileHandle(forReadingAtPath: path), chunkLength > 0 else {
      return nil
    }

    self.path = path
    self.handle = handle
    self.chunkLength = chunkLength
  }

  public func next() -> [Result<Substring>] {
    var result = [Substring]()
    var chunk: String
    repeat {
      guard let c = String(
        data: handle.readData(ofLength: chunkLength),
        encoding: .utf8
      )
      else {
        return [.failure(
          SError.lineReaderError("Can't read file \(path) in UTF-8")
        )]
      }
      chunk = c

      // there are no results, end of file, populating last item with leftover
      guard !chunk.isEmpty else {
        if let lc = leftoverChunk {
          result = [lc]
          leftoverChunk = nil
        }
        break
      }

      guard chunk != "\n" else {
        result = [Substring("")]
        break
      }

      result = chunk.split(separator: "\n", omittingEmptySubsequences: false)

      // no new leftover chunks, append existing one and return all
      if !result.isEmpty {
        if chunk.first == "\n", let lc = leftoverChunk {
          result[0] = lc
          leftoverChunk = nil
        }
        if chunk.last == "\n" {
          result.removeLast()
          break
        }
      }
      // setting leftoverChunk from last result item
      if result.count > 1 {
        if let lc = leftoverChunk {
          result[0] = lc + result[0]
        }
        leftoverChunk = result.removeLast()
      } else if result.count == 1 {
        if let lc = leftoverChunk {
          leftoverChunk = lc + result[0]
        } else {
          leftoverChunk = result[0]
        }
        result = []
      }
    } while result.isEmpty

    return result.map(Result.success)
  }
}
