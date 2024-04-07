import studentStruct from 0x05

transaction(id: UInt64, name: String) {
    
    prepare(acct: AuthAccount) {}

    execute {
        studentStruct.enrollScholar(id: id, name: name)
        log("Student Added")
    }
}
