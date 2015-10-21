//
//  main.swift
//  DomainModeling
//
//  Created by Vikram Thirumalai on 10/15/15.
//  Copyright (c) 2015 Vikram Thirumalai. All rights reserved.
//

import Foundation

protocol CustomStringConvertible {
    var description : String {get}
}

protocol Mathematics {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
}

extension Double {
    func USD() -> Money {
        return Money(amount: self, currency: "USD")
    }
    func EUR() -> Money {
        return Money(amount: self, currency: "EUR")
    }
    func CAN() -> Money {
        return Money(amount: self, currency: "CAN")
    }
    func GBP() -> Money {
        return Money(amount: self, currency: "GBP")
    }
}

struct Money : CustomStringConvertible, Mathematics {
    var amount: Double
    var currency: String
    var description : String {
        return "(\(amount), \(currency))"
    }
    
    init(amount:Double, currency:String) {
        self.amount = amount
        switch currency {
        case "GBP", "USD", "CAN" :
            self.currency = currency
        default:
            self.currency = "USD"
        }
        self.currency = currency
    }
    
    mutating func add(x: Double, y:String) -> Void {
        if(!y.isEqual(self.currency)) {
            convert(y)
        }
        self = Money(amount: self.amount + x, currency: self.currency)
    }
    
    mutating func subtract(x: Double, y:String) -> Void {
        if(!y.isEqual(self.currency)) {
            convert(y)
        }
        self = Money(amount: self.amount - x, currency: self.currency)
    }
    
    mutating func convert(converted: String) -> Void {
        if(!converted.isEqual(self.currency)) {
            switch converted {
                case "GBP":
                    switch self.currency {
                        case "USD":
                            self = Money(amount: (self.amount * 2), currency: converted)
                        case "CAN":
                                self = Money(amount: (self.amount * 5 / 2), currency: converted)
                        case "EUR":
                            self = Money(amount: (self.amount * 3), currency: converted)
                        default:
                            self = Money(amount: self.amount, currency: self.currency)
                    }
                case "USD":
                    switch self.currency {
                        case "GPB":
                            self = Money(amount: (self.amount / 2), currency: converted)
                        case "CAN":
                            self = Money(amount: (self.amount * 5 / 4), currency: converted)
                        case "EUR":
                            self = Money(amount: (self.amount * 3 / 2), currency: converted)
                        default:
                            self = Money(amount: self.amount, currency: self.currency)
                    }
                case "CAN":
                    switch self.currency {
                        case "GPB":
                            self = Money(amount: (self.amount * 4 / 10), currency: converted)
                        case "USD":
                            self = Money(amount: (self.amount * 4 / 5), currency: converted)
                        case "EUR":
                            self = Money(amount: (self.amount * 6 / 5), currency: converted)
                        default:
                            self = Money(amount: self.amount, currency: self.currency)
                    }
                case "EUR":
                    switch self.currency {
                        case "GPB":
                            self = Money(amount: (self.amount / 3), currency: converted)
                        case "USD":
                            self = Money(amount: (self.amount * 2 / 3), currency: converted)
                        case "CAN":
                            self = Money(amount: (self.amount * 5 / 6), currency: converted)
                        default:
                            self = Money(amount: self.amount, currency: self.currency)
                    }
                default:
                    self = Money(amount: self.amount, currency: self.currency)
            }
        }
    }
    static let DEFAULT = Money(amount: 0, currency: "USD")
}

func +(lhs: Money, var rhs: Money) -> Money {
    if(lhs.currency != rhs.currency) {
        rhs.convert(lhs.currency)
    }
    return Money(amount: (lhs.amount + rhs.amount), currency: lhs.currency)
}

func -(lhs: Money, var rhs: Money) -> Money {
    if(lhs.currency != rhs.currency) {
        rhs.convert(lhs.currency)
    }
    return Money(amount: (lhs.amount - rhs.amount), currency: lhs.currency)
}

class Job : CustomStringConvertible {
    var title: String
    var salary: Int32
    
    var description : String {
        return "(\(title), \(salary))"
    }
    
    init(salary:Int32, title:String) {
        self.salary = salary
        self.title = title
    }
    
    func calculateIncome(incoming: Int32) -> Int32 {
        if(salary < 10000) {
            return salary * incoming
        }
        else {
            return salary
        }
    }
    
     func bump(percentage: Double) -> Void {
        self.salary = Int32(Double(self.salary) * (1.0 + percentage));
    }
}

class Person : CustomStringConvertible {
    var firstName: String
    var lastName: String
    var age: Int32
    var job: Job?
    var spouse: Person?
    var description : String {
        return self.toString()
    }
    init(firstName:String, lastName:String, age: Int32, job:Job?, spouse: Person?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age;
        if(age > 16) {
            self.job = job
            if(age > 18) {
               self.spouse = spouse
            }
        }
    }
    
    func toString() -> String {
        var representation = ("\nfirst name: \(self.firstName) \n last name: \(self.lastName) \n age: \(self.age)")
        if(self.job != nil) {
            representation = representation + "\n job: \(self.job?.title)"
        }
        if(self.spouse != nil) {
            representation = representation + "\n SpouseName: \(self.spouse?.firstName) \(self.spouse?.lastName)"
        }
        return representation
    }
}

class Family : CustomStringConvertible {
    var people: [Person]
    var description : String {
        var everyone : String = ""
        for person1 in people {
            everyone += person1.toString()
        }
        return everyone
    }
    init(people:[Person]) {
        var is21 = false
        for person1 in people {
            if(person1.age >= 21) {
                is21 = true;
            }
        }
        if(!is21) {
            print("invalid family")
        }
        self.people = people
    }
    
    func haveChild(firstName:String, lastName:String) -> Void {
        var baby = Person(firstName: firstName, lastName: lastName, age: 0, job: nil, spouse: nil)
        people.append(baby)
        
    }
    
    func householdIncome()-> Int32 {
        var total:Int32 = 0
        for person1 in people {
            if((person1.job) != nil) {
                total = total + person1.job!.salary
            }
        }
        return total;
    }
}

var money = Money(amount: 200, currency: "USD")
var money2 = Money(amount: 250, currency: "EUR")
//checks the add and subtraction cases
println((money+money2).amount)
println((money-money2).currency)
println((money+money2).currency)
println((money-money2).amount)
println("currency is \(money.amount) \(money.currency)")
money.add(50, y: "CAN")
println("currency is \(money.amount) \(money.currency)")
money.subtract(20, y: "EUR")
println("currency is \(money.amount) \(money.currency)")
var job = Job(salary: 50000, title: "advisor");
//tests job
println(job.description)
println("salary is \(job.salary) title: \(job.title)")
println("\(job.calculateIncome(254))");
println("salary is \(job.salary) title: \(job.title)")
var person1 = Person(firstName: "John", lastName: "Smith", age: 80, job: job, spouse: nil)
//tests description for person)
println(person1.description)
var person2 = Person(firstName: "Mr", lastName: "Miyagi", age: 72, job: job, spouse: person1)
var person3 = Person(firstName: "Child", lastName: "Peterson", age: 30, job: nil, spouse: nil)
println(person1.toString())
println(person3.toString())
var stuff = [Person]()
stuff.append(person1)
stuff.append(person2)
stuff.append(person3)
//tests family
println(stuff.description)
//Tests Double
var x = 1.0.USD()
var y = 3.0.EUR()
var z = 6.0.CAN()
println((x-y).amount)
println((z+y).currency)
println((z+x).amount)
var family = Family(people: stuff)
family.haveChild("Dangerous", lastName: "Jones")
print("\(family.householdIncome())")
