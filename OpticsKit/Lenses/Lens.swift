//
//  Lens.swift
//  OpticsKit
//
//  Created by Szymon Mrozek on 07.03.2018.
//  Copyright © 2018 SzymonMrozek. All rights reserved.
//

import Foundation

precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

precedencegroup FunctionCompositionPrecedence {
    associativity: right
    higherThan: LeftApplyPrecedence
}

infix operator *~: MultiplicationPrecedence

/// Compose forward operator
infix operator >>> : FunctionCompositionPrecedence

/// Compose backward operator
infix operator <<< : FunctionCompositionPrecedence

/// Pipe forward function application.
infix operator |> : LeftApplyPrecedence

public struct Lens<Whole, Part> {
    public let view: (Whole) -> Part
    public let set: (Part, Whole) -> Whole
    
    public init (view: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole) {
        self.view = view
        self.set = set
    }
}

public func * <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return Lens<A, C>(
        view: { a in rhs.view(lhs.view(a)) },
        set: { (c, a) in lhs.set(rhs.set(c, lhs.view(a)), a) }
    )
}

public func *~ <A, B> (lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    return { a in lhs.set(rhs, a) }
}

/**
 Pipe a value into a function.
 - parameter x: A value.
 - parameter f: A function
 - returns: The value from apply `f` to `x`.
 */
public func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

/**
 Composes two functions in left-to-right order, i.e. (f >>> g)(x) = g(f(x)
 - parameter g: A function.
 - parameter f: A function.
 - returns: A function that is the composition of `f` and `g`.
 */
public func >>> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

/**
 Composes two functions in right-to-left order, i.e. (f <<< g)(x) = f(g(x)
 - parameter g: A function.
 - parameter f: A function.
 - returns: A function that is the composition of `f` and `g`.
 */
public func <<< <A, B, C> (g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
    return { g(f($0)) }
}

