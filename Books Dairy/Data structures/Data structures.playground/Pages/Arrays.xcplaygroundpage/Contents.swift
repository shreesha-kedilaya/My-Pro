
//Given an array A[] and a number x, check for pair in A[] with sum as x

func hasTwoPairs(array: [Float], sum: Float) -> Bool {
    let sortedArray = array.sorted()

    var startIndex = 0
    var endIndex = sortedArray.count - 1

    while startIndex < endIndex {
        if (sortedArray[startIndex] + sortedArray[endIndex]) == sum {
            return true

        } else if (sortedArray[startIndex] + sortedArray[endIndex]) < sum {
            startIndex += 1
        } else {
            endIndex -= 1
        }
    }
    return false
}

hasTwoPairs(array: [1,3,5], sum: 8)

//Majority Element

func findMajorityElement(array: [Float]) -> Float {
    var count = 1
    var majIndex = 0
    for arrayElement in array.enumerated() {
        if array[majIndex] == arrayElement.element {
            count += 1
        } else {
            count -= 1
        }
        if count == 0{
            majIndex = arrayElement.offset
            count = 1
        }
    }

    return array[majIndex]
}

findMajorityElement(array: [1,1,2,1,1,23,1])

//Find the Number Occurring Odd Number of Times.

//func findNumberOddNumberOfTimes(array: [Int]) -> Int {
//    var doctionary = [Int: Int]()
//
//    for arrayElement in array.enumerated() {
//        doctionary[arrayElement.element] =
//    }
//}

//Find the Missing Number

func findMissingNumber(array: [Int]) -> Int{
    var total = (array.count + 1) * (array.count + 2) / 2

    for element in array.enumerated() {
        total = total - element.element
    }
    return total
}

func findMissingNumberXOR(array: [Int]) -> Int {
    var xor1 = array[0]
    var xor2 = 1

    for element in array.enumerated() {
        xor1 = xor1 ^ element.element
    }

    for i in 1...array.count + 1 {
        xor2 = xor2 ^ i
    }

    return xor1 ^ xor2
}

findMissingNumberXOR(array: [1,2,3,4,6,7,8])

//Search an element in a sorted and rotated array.

func findPivot(array: [Int], high: Int, low: Int) -> Int{

    if high < low {
        return -1
    } else if low == high {
        return high
    }
    let mid = (low + high) / 2
    if mid < high && array[mid] > array[mid + 1] {
        return mid
    } else if mid > low && array[mid] < array[mid - 1] {
        return mid - 1
    }
    return findPivot(array: array, high: high, low: mid + 1)
}

func binarySearch(array: [Int], low: Int, high: Int, element: Int) -> Int {
    if high < low {
        return -1
    }

    let mid = (low + high) / 2
    if element == array[mid] {
        return mid
    } else if element > array[mid] {
        return binarySearch(array: array, low: mid + 1, high: high, element: element)
    } else {
        return binarySearch(array: array, low: low, high: mid - 1, element: element)
    }
}

func pivotedBinarySearch(array: [Int], element: Int) -> Int {
    let pivot = findPivot(array: array, high: array.count - 1, low: 0)

    if pivot == -1 {
        return binarySearch(array: array, low: 0, high: array.count, element: element)
    }

    if array[pivot] == element {
        return pivot
    } else if array[0] <= element {
        return binarySearch(array: array, low: 0, high: pivot - 1, element: element)
    } else {
        return binarySearch(array: array, low: pivot + 1, high: array.count, element: element)
    }
}


print(pivotedBinarySearch(array: [5,6,7,8,9,10,11,12,13,1,2,3,4], element: 4))

//Search an element in a sorted and rotated array: Better approach

func findArrayRotatedBetter(array: [Int],low: Int, high: Int, key: Int) -> Int {
    if high < low {
        return -1
    }

    let mid = (low + high) / 2

    if array[mid] == key {
        return mid
    }

    if array[low] < array[mid] {
        if key <= array[mid] && key >= array[low] {
            return findArrayRotatedBetter(array: array, low: low, high: mid - 1, key: key)
        } else {
            return findArrayRotatedBetter(array: array, low: mid + 1, high: high, key: key)
        }
    } else if key >= array[mid] && key <= array[high] {
        return findArrayRotatedBetter(array: array, low: mid + 1, high: high, key: key)
    } else {
        return findArrayRotatedBetter(array: array, low: low, high: mid - 1, key: key)
    }
}

print(findArrayRotatedBetter(array: [5,6,7,8,9,10,11,12,13,1,2,3,4], low: 0, high: 12, key: 12))

