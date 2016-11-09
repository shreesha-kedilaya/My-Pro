//: [Previous](@previous)

import Foundation

/*:
 ### Merge an array of size n into another array of size m+n
 */

func mergeTwoArray(_ primaryArray: [Int?], secondaryArray: [Int]) -> [Int?]{
    var returnArray = primaryArray

    var secondaryArrayCount = 0
    var totalCount = 0

    var bufferSecondaryArrayCount = secondaryArray.count

    while totalCount < primaryArray.count {
        if bufferSecondaryArrayCount < primaryArray.count {
            if let primaryObject = primaryArray[bufferSecondaryArrayCount] , primaryObject < secondaryArray[secondaryArrayCount] {
                returnArray[totalCount] = returnArray[bufferSecondaryArrayCount]
                totalCount += 1
                bufferSecondaryArrayCount += 1
            } else {
                returnArray[totalCount] = secondaryArray[secondaryArrayCount]
                totalCount += 1
                secondaryArrayCount += 1
            }
        }
    }

    print(returnArray)
    return returnArray
}

func moveTheArrayToEnd(_ array: [Int?], nilValueCount: Int) -> [Int?] {
    var size = array.count - 1
    var returnArray: [Int?] = array

    for i in (0...size).reversed() {
        if let object = array[i] {
            returnArray[size] = object
            size -= 1
        }

        if i < nilValueCount {
            returnArray[i] = nil
        }
    }

    return returnArray
}


let returnedArray = moveTheArrayToEnd([1,nil,3,4,5,nil], nilValueCount:2)

//print(mergeTwoArray(returnedArray, secondaryArray: [2,54]))


/*:
 ### Median of two arrays
 */
func getMedianOfArrays(_ array1:[Int], array2:[Int]) -> Int {
    var i = 0
    var j = 0
    var m1 = -1, m2 = -1
    var ar1 = array1
    var ar2 = array2

    for _ in 0...array1.count
    {
        if (i == array1.count)
        {
            m1 = m2
            m2 = ar2[0]
            break;
        }else if (j == array1.count){
            m1 = m2
            m2 = ar1[0]
            break
        }

        if (ar1[i] < ar2[j])
        {
            m1 = m2
            m2 = ar1[i]
            i += 1
        }
        else
        {
            m1 = m2
            m2 = ar2[j]
            j += 1
        }
    }

    return (m1 + m2)/2
}

print(getMedianOfArrays([1,2,3,4,6], array2: [10,11,12,13,14]))

func getMedian(_ array1: [Int], array2: [Int]) -> Int {

    if array1.count == 1{
        return (array1[0] + array2[0]) / 2
    } else if array1.count == 2 {
        return (max(array1[0], array2[0]) + min(array1[1], array2[1])) / 2
    } else {
        let m1 = getMedian(array1)
        let m2 = getMedian(array2)

        if m1 == m2 {
            return m1
        } else if m1 > m2{
            let slicedArray1 = array1[(array1.count / 2)...array1.count - 1]
            let slicedArray2 = array1[0...(array1.count / 2)]
            return getMedian(Array(slicedArray1), array2: Array(slicedArray2))
        } else {
            if array1.count%2 == 0 {
                let slicedArray1 = array1[0...(array1.count / 2)]
                let slicedArray2 = array1[(array1.count / 2)...array1.count - 1]
                return getMedian(Array(slicedArray1), array2: Array(slicedArray2))
            } else {
                let slicedArray1 = array1[0...(array1.count / 2)]
                let slicedArray2 = array1[(array1.count / 2)...array1.count - 1]
                return getMedian(Array(slicedArray1), array2: Array(slicedArray2))
            }
        }
    }
}

func getMedian(_ array: [Int]) -> Int{
    if array.count%2 == 0 {
        return (array[array.count / 2] + array[(array.count / 2) - 1]) / 2
    } else {
        return array[array.count / 2]
    }
}

print(getMedian([1,2,5,7,10], array2: [6,7,8,9,25,26]))

/*:
 ### Getting the median of an array in juggling algorithm.
 */
func rotateToLeft(array: [Int], rotatePoint: Int) -> [Int] {
    var j = 0
    var tempObject = 0
    var k = 0
    let n = array.count - 1

    var returnArray = array

    for i in 0..<rotatePoint {
        tempObject = array[i]
        j = i

        while true {
            k = j + rotatePoint

            if k >= n {
                k = k - n
            }

            if k == i{
                break
            }

            returnArray[j] = returnArray[k]

            j = k
        }

        returnArray[j] = tempObject
    }

    return returnArray
}

print(rotateToLeft(array: [1,2,3,4,5,6], rotatePoint: 2))


var count = 0

func reverseAlgoForArrayRotation(array: [Int], pivot: Int) -> [Int]{
    return reverse(array:
        reverse(array:
            reverse(array: array, from: 0, to: pivot),
            from: pivot + 1, to: array.count - 1),
                   from: 0 , to: array.count - 1)
}
func reverse(array: [Int], from: Int, to: Int) -> [Int] {
    count += 1
    print(count)
    var start = from
    var end = to
    var returnArray = array
    while start < end {
        let temp = returnArray[start]
        returnArray[start] = returnArray[end]
        returnArray[end] = temp

        start += 1
        end -= 1
    }

    return returnArray
}
print(reverseAlgoForArrayRotation(array: [1,2,3,4,5,6,7], pivot: 2))
