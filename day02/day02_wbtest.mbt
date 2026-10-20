// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
test "case01" {
  assert_eq(get_invalid_case01("11-22"), [11, 22])
  assert_eq(get_invalid_case01("95-115"), [99])
  assert_eq(get_invalid_case01("998-1012"), [1010])
  assert_eq(get_invalid_case01("1188511880-1188511890"), [1188511885])
  assert_eq(get_invalid_case01("222220-222224"), [222222])
  assert_eq(get_invalid_case01("1698522-1698528"), [])
}

///|
test "11" {
  assert_eq(process_case02("11"), Some("11"))
}

///|
test "12" {
  assert_eq(process_case02("12"), None)
}

///|
test "111" {
  assert_eq(process_case02("111"), Some("111"))
}

///|
test "1010" {
  assert_eq(process_case02("1010"), Some("1010"))
}

///|
test "2121212121" {
  assert_eq(process_case02("2121212121"), Some("2121212121"))
}

///|
test "1188511885" {
  assert_eq(process_case02("1188511885"), Some("1188511885"))
}

///|
test "824824824" {
  assert_eq(process_case02("824824824"), Some("824824824"))
}

///|
test "11-22 case02" {
  assert_eq(get_invalid_case02("11-22"), [11, 22])
}

///|
test "95-115 cae02" {
  assert_eq(get_invalid_case02("95-115"), [99, 111])
}

///|
test "998-1012 case02" {
  assert_eq(get_invalid_case02("998-1012"), [999, 1010])
}

///|
test "1188511880-1188511890 case02" {
  assert_eq(get_invalid_case02("1188511880-1188511890"), [1188511885])
}

///|
test "222220-222224 case02" {
  assert_eq(get_invalid_case02("222220-222224"), [222222])
}

///|
test "1698522-1698528 case02" {
  assert_eq(get_invalid_case02("1698522-1698528"), [])
}

///|
test "565653-565659" {
  assert_eq(get_invalid_case02("565653-565659"), [565656])
}

///|
test "824824821-824824827" {
  assert_eq(get_invalid_case02("824824821-824824827"), [824824824])
}

///|
test "2121212118-2121212124" {
  assert_eq(get_invalid_case02("2121212118-2121212124"), [2121212121])
}

///|
test "advanaced" {
  let input =
    #| 11-22
    #| 95-115
    #| 998-1012
    #| 1188511880-1188511890
    #| 222220-222224
    #| 1698522-1698528
    #| 446443-446449
    #| 38593856-38593862
    #| 565653-565659
    #| 824824821-824824827
    #| 2121212118-2121212124
  let lines = input.split("\n")
  let mut total : Int64 = 0
  for each in lines {
    let invalids = get_invalid_case02(each.trim())
    total += invalids.fold(init=0, (sum, e) => e + sum)
  }

  assert_eq(total, 4174379265)
}
