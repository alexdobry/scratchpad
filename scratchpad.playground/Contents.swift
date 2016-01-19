//: Playground - noun: a place where people can play

import UIKit

// TRIMMING
func removeWhitespace(a: String) -> String {
    return a.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch)
}

let type: String? = nil
let size: String? = nil
let date: String? = nil

let testString = "\(type ?? "") \(size ?? "") \(date ?? "")"

removeWhitespace(testString).isEmpty

let ddd = (1...5).map{ $0 }
ddd

// CURRYING

func add(a: Int)(b: Int) -> Int {
    return a + b
}

let a = add(2)
let b = add(2)(b: 2)

(1...10).map(a)

// FLATMAP

let array = ["A", "B", "Ä", "C", "Ö", "D"]
let new = array.map{ $0.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) }
let new2 = array.flatMap{ $0.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) }

let x = ["A", "B", nil, "C"].flatMap{$0}
x

new
new2

struct User {
    let id: Int
    let name: String
    let email: String?
    
    static func create(id: Int)(name: String)(email: String?) -> User {
        let s = User(id: id, name: name, email: email)
        print(s.id)
        print(s.name)
        print(s.email)
        return s
    }
    
    var description: String { return "\(id), \(name), \(email)" }
}

let aa = User.create(1)

// MONAD STUFF

/*final public class Box<V> {
    public let value: V
    public init(_ value: V) { self.value = value }
    
    /*func pure<B>(b: B) -> Box<B> {
        return Box(b)
    }*/
    
    func map<B>(f: V -> B) -> Box<B> {
        return flatMap({ v -> Box<B> in
            return Box<B>(f(v))
        })
    }
    
    func flatMap<B>(f: V -> Box<B>) -> Box<B> {
        return f(value)
    }
    
    func zip<B>(that: Box<B>) -> Box<(V, B)> {
        return flatMap({ v -> Box<(V, B)> in
            that.map({ b -> (V, B) in
                return (v, b)
            })
        })
    }
    
    func zip2<B>(that: Box<B>) -> Box<(V, B)> {
        return map2(that) { v, b -> (V, B) in
            return (v, b)
        }
    }
    
    func foldLeft<B>(z: B, f: (B, V) -> B) -> B {
        return f(z, value)
    }
    
    func apply<B>(b: Box<(V -> B)>) -> Box<B> {
        return b.map { $0(self.value) }
    }
    
    func map2<B, C>(b: Box<B>, f: (V, B) -> C) -> Box<C> {
        return flatMap({ v -> Box<C> in
            return b.map { f(v, $0) }
        })
    }
}

/*class Functor<F> {
    func map<A,B>(F: F<A>, f: A -> B) -> F<B>
}

class Applicative extends Functor {
    func apply
    func map2
    func map
}

class Monad extends Functor {
    func pure
    func map
    func flatMap
}*/

let b1 = Box(1)
let b2 = Box("Hallo")

let shit = b1.zip(b2).map{ (String($0.0), $0.1) }
let moreshit = shit.foldLeft("") { (a, b) -> String in
    return a + b.0 + b.1
}

let f: Box<Int -> String> = Box({ String($0) })

let applied = b1.apply(f)
applied.value

let map2 = b1.map2(b2) { String($0.0).stringByAppendingString($0.1) }*/

// PIPELINING AND COMPOSITION

func save() -> Bool? { return true }
func doShit(a: Bool) -> Int { return a == true ? 1 : 0 }

infix operator &&& { associativity left }

func &&&<A, B>(left: A?, right: A -> B) -> B? {
    if let l = left {
        return right(l)
    } else {
        return nil
    }
}

let xydasd = save() &&& doShit
