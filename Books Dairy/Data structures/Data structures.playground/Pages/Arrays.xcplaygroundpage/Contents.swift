
//Given an array A[] and a number x, check for pair in A[] with sum as x

func hasTwoPairs(array: [Float], sum: Float) -> Bool {
    let sortedArray = array.sort()

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

hasTwoPairs([1,3,5], sum: 8)

//Majority Element

func findMajorityElement(array: [Float]) -> Float {
    var count = 1
    var majIndex = 0
    for arrayElement in array.enumerate() {
        if array[majIndex] == arrayElement.element {
            count += 1
        } else {
            count -= 1
        }
        if count == 0{
            majIndex = arrayElement.index
            count = 1
        }
    }

    return array[majIndex]
}

findMajorityElement([1,1,2,1,1,23,1])

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

    for element in array.enumerate() {
        total = total - element.element
    }
    return total
}

func findMissingNumberXOR(array: [Int]) -> Int {
    var xor1 = array[0]
    var xor2 = 1

    for element in array.enumerate() {
        xor1 = xor1 ^ element.element
    }

    for i in 1...array.count + 1 {
        xor2 = xor2 ^ i
    }

    return xor1 ^ xor2
}

findMissingNumberXOR([1,2,3,4,6,7,8])

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
    return findPivot(array, high: high, low: mid + 1)
}

func binarySearch(array: [Int], low: Int, high: Int, element: Int) -> Int {
    if high < low {
        return -1
    }

    let mid = (low + high) / 2
    if element == array[mid] {
        return mid
    } else if element > array[mid] {
        return binarySearch(array, low: mid + 1, high: high, element: element)
    } else {
        return binarySearch(array, low: low, high: mid - 1, element: element)
    }
}

func pivotedBinarySearch(array: [Int], element: Int) -> Int {
    let pivot = findPivot(array, high: array.count - 1, low: 0)

    if pivot == -1 {
        return binarySearch(array, low: 0, high: array.count, element: element)
    }

    if array[pivot] == element {
        return pivot
    } else if array[0] <= element {
        return binarySearch(array, low: 0, high: pivot - 1, element: element)
    } else {
        return binarySearch(array, low: pivot + 1, high: array.count, element: element)
    }
}


print(pivotedBinarySearch([5,6,7,8,9,10,11,13,1,2,3,4], element: 4))

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
            return findArrayRotatedBetter(array, low: low, high: mid - 1, key: key)
        } else {
            return findArrayRotatedBetter(array, low: mid + 1, high: high, key: key)
        }
    } else if key >= array[mid] && key <= array[high] {
        return findArrayRotatedBetter(array, low: mid + 1, high: high, key: key)
    } else {
        return findArrayRotatedBetter(array, low: low, high: mid - 1, key: key)
    }
}

print(findArrayRotatedBetter([5,6,7,8,9,10,11,12,13,1,2,3,4], low: 0, high: 12, key: 12))

//Merge an array of size n into another array of size m+n


func mergeTwoArray(primaryArray: [Int?], secondaryArray: [Int]) -> [Int?]{
    var returnArray = primaryArray

    var secondaryArrayCount = 0
    var totalCount = 0

    var bufferSecondaryArrayCount = secondaryArray.count

    while totalCount < primaryArray.count {
        if bufferSecondaryArrayCount < primaryArray.count {
            if let primaryObject = primaryArray[bufferSecondaryArrayCount] where primaryObject < secondaryArray[secondaryArrayCount] {
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

func moveTheArrayToEnd(array: [Int?], nilValueCount: Int) -> [Int?] {
    var size = array.count - 1
    var returnArray: [Int?] = array

    for i in (0...size).reverse() {
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

print(mergeTwoArray(returnedArray, secondaryArray: [2,54]))

//Median of two arrays

func getMedianOfArrays(array1:[Int], array2:[Int]) -> Int {
    var i = 0;  /* Current index of i/p array ar1[] */
    var j = 0; /* Current index of i/p array ar2[] */
    var m1 = -1, m2 = -1;
    var ar1 = array1
    var ar2 = array2

    /* Since there are 2n elements, median will be average
    of elements at index n-1 and n in the array obtained after
    merging ar1 and ar2 */
    for _ in 0...array1.count
    {
        /*Below is to handle case where all elements of ar1[] are
        smaller than smallest(or first) element of ar2[]*/
        if (i == array1.count)
        {
            m1 = m2;
            m2 = ar2[0];
            break;
        }

            /*Below is to handle case where all elements of ar2[] are
            smaller than smallest(or first) element of ar1[]*/
        else if (j == array1.count)
        {
            m1 = m2;
            m2 = ar1[0];
            break;
        }

        if (ar1[i] < ar2[j])
        {
            m1 = m2;  /* Store the prev median */
            m2 = ar1[i];
            i++;
        }
        else
        {
            m1 = m2;  /* Store the prev median */
            m2 = ar2[j];
            j++;
        }
    }

    return (m1 + m2)/2;
}

print(getMedianOfArrays([1,2,3,4,6], array2: [10,11,12,13,14]))

func getMedian(array1: [Int], array2: [Int]) -> Int {

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

func getMedian(array: [Int]) -> Int{
    if array.count%2 == 0 {
        return (array[array.count / 2] + array[(array.count / 2) - 1]) / 2
    } else {
        return array[array.count / 2]
    }
}

print(getMedian([1,2,5,7,10], array2: [6,7,8,9,25,26]))

