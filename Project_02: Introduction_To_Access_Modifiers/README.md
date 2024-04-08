# Introduction To Access Modifiers in flow 

Access modifiers in the Cadence programming language enable developers to control the visibility and accessibility of declarations within smart contracts. The public modifier allows declarations to be accessed externally by any account or contract importing the defining contract, serving as part of the contract's interface. On the other hand, the private modifier restricts access to declarations solely within the same contract, preventing external access from other contracts or accounts. These modifiers ensure proper encapsulation and access control, crucial for maintaining the integrity and security of smart contract code on the Flow blockchain.

There are several access modifiers in Cadence - 

**Public:** The public access modifier allows declarations to be accessed from any account or contract that imports the contract where the declaration is defined. Public declarations are part of the contract's interface and are accessible externally.

**Private:** The private access modifier restricts access to declarations only within the same contract. Private declarations cannot be accessed from external contracts or accounts.

**access(Self):** This keyword is used to specify that a function can only be called by other functions within the same contract. It restricts access to the function to only internal calls within the contract itself.

**access(contract):** This keyword is used to specify that a function can be called by other contracts that import the current contract. It allows the function to be accessed externally by other contracts.

# Project Objective 

For today's challenge, participants will add code to their GitHub repositories and provide a comprehensive code walk-through analyzing a contract and a script. The code walk-through will specifically examine a contract named SomeContract, which includes four variables (a, b, c, d) and three functions (publicFunc, contractFunc, privateFunc).

```cadence
access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {

        //
        // 4 Variables
        //

        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        //
        // 3 Functions
        //

        pub fun publicFunc() {}

        access(contract) fun contractFunc() {}

        access(self) fun privateFunc() {}


        pub fun structFunc() {
            /**************/
            /*** AREA 1 ***/
            /**************/
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            /**************/
            /*** AREA 2 ***/
            /**************/
        }

        init() {
            self.e = 17
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        /**************/
        /*** AREA 3 ****/
        /**************/
    }

    init() {
        self.testStruct = SomeStruct()
    }
}
```

# Explanation of Contract

This contract, named SomeContract, consists of a structure named SomeStruct, which contains four variables (a, b, c, and d) and three functions (publicFunc, contractFunc, and privateFunc). Let's break it down into simpler terms:

**Variables:**

a: This variable can be read and modified by any part of the contract.
b: Similarly, this variable can be read and modified by any part of the contract.
c: This variable can only be read by the contract itself, but it can be modified by any other contract.
d: This variable can only be read and modified within the SomeStruct structure itself.

**Functions:**

publicFunc: This function can be called from anywhere within the contract.
contractFunc: This function can only be called by other contracts.
privateFunc: This function can only be called within the SomeStruct structure itself.

**Areas:**

Area 1: This is a function within the SomeStruct structure. Any code within this area has access to the variables and functions within SomeStruct.
Area 2: This is a function within the SomeResource resource. Any code within this area has access to the variables and functions within SomeResource.
Area 3: This is a function within the SomeContract contract itself. Any code within this area has access to all variables and functions within SomeContract.
In easy words, this contract defines some variables and functions with different levels of accessibility. It also contains areas where you can write code to interact with the variables and functions defined within the contract and its structures and resources.
