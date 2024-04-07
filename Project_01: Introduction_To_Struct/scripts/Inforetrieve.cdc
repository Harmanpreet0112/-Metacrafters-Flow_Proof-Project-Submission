import studentStruct from 0x05

pub fun main(id: UInt64): studentStruct.Scholar? {
  return studentStruct.retrieveScholar(id: id)!
}
