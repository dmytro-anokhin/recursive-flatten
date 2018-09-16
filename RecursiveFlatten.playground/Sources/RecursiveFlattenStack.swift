//
//  RecursiveFlattenStack.swift
//  RecursiveFlatten
//
//  Created by Dmytro Anokhin on 15/09/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//


/// A collection that presents recursively concatenated elements of its base collection and sub-collections
public struct RecursiveFlattenSequence_Stack<Base: Collection> {

    @usableFromInline
    internal let _base: Base

    /// Creates an instance that presents recursively concatenated elements of `base`
    ///
    /// - Complexity: O(1)
    @inlinable
    internal init(_base: Base) {
        self._base = _base
    }
}


extension RecursiveFlattenSequence_Stack : Sequence {

    public typealias Element = Base.Element

    public struct Iterator {
        /// `Node` stores the traversal state for a collection
        @usableFromInline
        internal struct Node {
            /// Traversed collection
            @usableFromInline
            internal let _base: Base

            /// The current index in `_base`
            @usableFromInline
            internal var _position: Base.Index

            /// Initialize `Node` with a collection at its start index
            @usableFromInline
            internal init(_base: Base) {
                self._base = _base
                self._position = _base.startIndex
            }
        }

        @usableFromInline
        internal var stack: [Node]

        /// Creates an instance with a base. The position is set to the start index
        public init(_base: Base) {
            stack = [Node(_base: _base)]
        }
    }

    /// Returns an iterator over the elements of this sequence.
    ///
    /// - Complexity: O(1).
    @inlinable
    @inline(__always)
    public func makeIterator() -> Iterator {
        return Iterator(_base: _base)
    }
}


extension RecursiveFlattenSequence_Stack.Iterator : IteratorProtocol {

    public typealias Element = Base.Element

    /// Advances to the next element and returns it, or `nil` if no next element
    /// exists.
    ///
    /// Once `nil` has been returned, all subsequent calls return `nil`.
    @inlinable
    @inline(__always)
    public mutating func next() -> Element? {

        // Traverse array and nested arrays to find a first non-array element
        repeat {
            // Pop a node from the stack till we find the one that is not fully traversed
            while var tail = stack.popLast(), tail._position < tail._base.endIndex {
                // Take element, increment the position
                let element = tail._base[tail._position]
                tail._base.formIndex(after: &tail._position)
                stack.append(tail)

                // If element is the base type, push it on the stack and continue traversal
                if let base = element as? Base {
                    stack.append(Node(_base: base))
                    continue
                }

                return element
            }
        } while !stack.isEmpty

        return nil
    }
}


extension Array {

    @inlinable
    public func recursiveFlatten_Stack() -> RecursiveFlattenSequence_Stack<Array<Any>> {
        return RecursiveFlattenSequence_Stack(_base: self)
    }
}
