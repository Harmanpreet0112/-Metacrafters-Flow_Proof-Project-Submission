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
