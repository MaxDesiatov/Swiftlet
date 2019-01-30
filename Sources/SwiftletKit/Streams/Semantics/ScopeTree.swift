//
//  ScopeTree.swift
//  SwiftletKit
//
//  Created by Max Desiatov on 19/09/2018.
//

import Foundation

protocol Type {
}

indirect enum ConcreteType: Type {
  case closure(argument: ConcreteType, returns: ConcreteType, throws: Bool)
  case tuple([ConcreteType])
  case instanceType(name: String, generics: [String])
}

enum PlaceholderType: Type {
  case explicit(ConcreteType)
  case notInferred
}

struct ProtocolFunction {
  let genericParameters: [String]
  let parameters: [String: ConcreteType]
  let returnType: ConcreteType
}

enum FunctionScopeParent<T: Type> {
  case function(FunctionScope<T>)
  case `class`(ClassScope<T>)
  case `struct`(StructScope<T>)
}

final class FunctionScope<T: Type> {
  let parent: FunctionScopeParent<T>

  var functions = [String: FunctionScope<T>]()

  init(parent: FunctionScopeParent<T>) {
    self.parent = parent
  }
}

enum ObjectScopeParent<T: Type> {
  case file(FileScope<T>)
  case `class`(ClassScope<T>)
  case `struct`(StructScope<T>)
}

final class StructScope<T: Type> {
  let parent: ObjectScopeParent<T>

  var conformanceTypes = [String]()

  init(parent: ObjectScopeParent<T>) {
    self.parent = parent
  }
}

final class ProtocolScope<T: Type> {
  weak var parent: FileScope<T>!

  var associatedTypes = [String]()
  var functions = [String: ProtocolFunction]()

  init(parent: FileScope<T>) {
    self.parent = parent
  }
}

enum InheritableType {
  case `protocol`(name: String)
  case `class`(name: String, generics: [String])
}

final class ClassScope<T: Type> {
  let parent: ObjectScopeParent<T>

  var genericParameters = [String]()
  var inheritedTypes = [InheritableType]()
  var constants = [String: T]()
  var variables = [String: T]()

  init(parent: ObjectScopeParent<T>) {
    self.parent = parent
  }
}

final class FileScope<T: Type> {
  weak var parent: ModuleScope<T>!

  var imports = [String]()
  var protocols = [String: ProtocolScope<T>]()
  var classes = [String: ClassScope<T>]()
  var constants = [String: T]()
  var variables = [String: T]()

  init(parent: ModuleScope<T>) {
    self.parent = parent
  }
}

final class ModuleScope<T: Type> {
  let files = [String: FileScope<T>]()
}

enum DeclarationType {
  case `class`
  case `struct`
  case `protocol`
  case `extension`
  case `enum`
  case constant
  case variable
  case `import`
  case `typealias`
  case `associatedtype`
  case function
}
