//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

class YML {
    var name: String
    required init(name: String) {
        self.name = name
    }
}

class YMLClient: YML{
    var clientName: String
    required init(name: String){
        clientName = name

        super.init(name: "Client" + name)
    }
}