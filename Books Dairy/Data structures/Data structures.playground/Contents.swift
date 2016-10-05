//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
func aFunction(numbers: Array<Int>, position: Int) -> Array<Int> {
    let newNumbers = numbers[0..<position]
    return Array(newNumbers)
}

let absences = [0, 2, 0, 4, 0, 3, 1, 0]
let midpoint = absences.count / 2

let firstHalf = absences.prefix(midpoint)
let secondHalf = absences.suffix(midpoint)

print(firstHalf)
print(secondHalf)

print(aFunction([1,2,4,3,5], position: 2))

let limit = 8

let count = absences.count
let reverse = absences.reverse()
let newArraySlice = reverse[count - limit...0+count-1]
let newArray = Array(newArraySlice)
print(newArray)
