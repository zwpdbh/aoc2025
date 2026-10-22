// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
test "case01" {
  let n = find_joltage("987654321111111")
  assert_eq(98, n)
}

///|
test "case02" {
  let n = find_joltage("811111111111119")
  assert_eq(89, n)
}

///|
test "case03" {
  let n = find_joltage("234234234234278")
  assert_eq(78, n)
}

///|
test "case04" {
  let n = find_joltage("818181911112111")
  assert_eq(92, n)
}
