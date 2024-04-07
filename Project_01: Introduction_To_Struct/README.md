# Introduction To Flow Blockchain

Flow blockchain is a decentralized platform designed to support the next generation of digital assets, applications, and games with high throughput and low latency. Unlike traditional blockchains, Flow employs a novel architecture that separates consensus and computation, enabling it to achieve scalability without sacrificing security. This architecture, combined with its unique consensus mechanism, allows Flow to process thousands of transactions per second while maintaining decentralization and censorship resistance. Flow's developer-friendly environment and robust tooling make it a compelling choice for building decentralized applications and digital assets, catering to a wide range of industries including gaming, collectibles, and decentralized finance.

# Introduction To Cadence

Cadence is a resource-oriented smart contract programming language designed specifically for the Flow blockchain. It prioritizes security, predictability, and developer experience, offering a high level of expressiveness while mitigating common pitfalls found in other languages. Cadence ensures that smart contracts are easy to reason about, enabling developers to write secure and reliable code for decentralized applications (dApps) and digital assets. Its type system facilitates strong guarantees at compile time, reducing the likelihood of runtime errors and vulnerabilities. Moreover, Cadence's design encourages best practices in smart contract development, fostering a robust ecosystem of applications and assets on the Flow blockchain.

# Project Objective 

For this task, you'll utilize structs, a concept covered in the previous module. Start by deploying a new contract that incorporates a struct of your choice, ensuring it differs from the predefined "Profile" struct. Next, establish a dictionary or array to hold instances of the struct you've defined. Develop a function to append new entries to this array/dictionary. Subsequently, create a transaction to invoke the aforementioned function. Lastly, craft a script to retrieve and display the contents of the struct you've defined. Once completed, share your code on GitHub for review. This exercise will reinforce your understanding of structs and their implementation within smart contracts, enhancing your proficiency in blockchain development.

# Contract Code Explanation 

```cadence
pub contract studentStruct {

    pub struct Scholar {
        pub let id: UInt64
        pub let name: String

        pub init(id: UInt64, name: String) {
            log("Student Information Updated")
            self.id = id
            self.name = name
        }
    }

    pub var scholars: {UInt64: Scholar}

    pub init() {
        self.scholars = {}
    }

    pub fun enrollScholar(id: UInt64, name: String) {
        let scholar = Scholar(id: id, name: name)
        self.scholars[id] = scholar
    }

    pub fun retrieveScholar(id: UInt64): Scholar? {
        return self.scholars[id]
    }
}
```

It defines a contract called "studentStruct" that includes a struct named "Scholar." Each Scholar has two properties: an ID (a number) and a name (a string). When a new Scholar is created, the contract logs a message saying "Student Information Updated." The contract also has a dictionary called "scholars" to store instances of Scholar structs, where each Scholar is associated with a unique ID. The contract includes functions to enroll a new Scholar and retrieve information about a Scholar by their ID. The "enrollScholar" function creates a new Scholar with the provided ID and name, then adds it to the scholars dictionary. The "retrieveScholar" function looks up a Scholar by their ID and returns it. This code essentially creates a simple system for managing student information on the blockchain.

# Scripts Code Explanation 

```cadence
import studentStruct from 0x05

pub fun main(id: UInt64): studentStruct.Scholar? {
  return studentStruct.retrieveScholar(id: id)!
}
```

This piece of code imports a smart contract named "studentStruct" from a specific address (0x05) on the Flow blockchain. The contract "studentStruct" likely contains definitions for a struct called "Scholar" and functions to manage student information. The main function in this code is designed to retrieve information about a student by their ID. It takes an ID (a number) as input and calls the "retrieveScholar" function from the imported contract "studentStruct" to fetch the corresponding Scholar object. The exclamation mark (!) indicates that the return value is forced to be non-nil, meaning it must return a valid Scholar object or else it will throw an error. Overall, this code snippet serves as a simple way to access student information stored on the blockchain by utilizing the functions provided in the "studentStruct" contract.

# Transaction Code Explanation 

```cadence
import studentStruct from 0x05

transaction(id: UInt64, name: String) {
    
    prepare(acct: AuthAccount) {}

    execute {
        studentStruct.enrollScholar(id: id, name: name)
        log("Student Added")
    }
}
```
Imports a smart contract called "studentStruct" from the blockchain address 0x05. The transaction defined here is a blockchain transaction that adds a new student to the system. It takes two parameters: an ID (a number) and a name (a string) for the student being added. In the execute block of the transaction, it calls the "enrollScholar" function from the imported "studentStruct" contract, passing the provided ID and name as arguments. This function adds a new student with the given ID and name to the system. Additionally, it logs a message saying "Student Added" to provide feedback about the successful addition of the student. Overall, this transaction serves as a way to add students to the system by utilizing the functionality provided by the "studentStruct" contract.

# Conclusion

In conclusion, these functionality and interaction with a smart contract named "studentStruct" deployed on the Flow blockchain. Through the use of Cadence, a blockchain-specific programming language, these snippets illustrate how to import the "studentStruct" contract, define transactions for enrolling new scholars, and retrieve scholar information. The smart contract facilitates the management of student data on the blockchain, allowing for the addition of new scholars and retrieval of existing scholar information. By leveraging Cadence's simplicity and the capabilities of the Flow blockchain, developers can build robust decentralized applications for managing various types of data and transactions efficiently.
