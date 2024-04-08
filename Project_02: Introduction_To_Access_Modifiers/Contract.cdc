access(all) contract SomeContract {

    // The testStruct variable is of type SomeStruct.

    pub var testStruct: SomeStruct

    // SomeStruct struct definition

    pub struct SomeStruct {

        //
        // 4 Variables
        //

        // pub(set) - Read and write scope in Areas 1, 2, 3, and 4
        // pub - Read scope in Areas 1, 2, 3, and 4; Write scope in Area 1 only
        // access(contract) - Read scope in Areas 1, 2, and 3; Write scope in Area 1 only
        // access(Self) - Read and write scope in Area 1 only

        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        //
        // 3 Functions
        //

        // Can be called in Areas 1, 2, 3, and 4

        pub fun publicFunc() {}

        // Can be called in Areas 1, 2, and 3; Access is within the contract only

        access(contract) fun contractFunc() {}

        // Can be called in Area 1 only; Access is within the struct only

        access(self) fun privateFunc() {}

        // Example function within the struct

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

    // Resource definition

    pub resource SomeResource {
        pub var e: Int

        // Example function within the resource

        pub fun resourceFunc() {

            /**************/
            /*** AREA 2 ***/
            /**************/

        }

        init() {
            self.e = 17
        }
    }

    // Function to create an instance of SomeResource

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    // Example function within the contract

    pub fun questsAreFun() {

        /**************/
        /*** AREA 3 ****/
        /**************/

    }

    // Initialization of the contract, initializing testStruct

    init() {
        self.testStruct = SomeStruct()
    }
}
