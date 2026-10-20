///|
// Deprecated helpers kept from the earlier greedy lexer implementation.

///|
/// Compare if b is sub string of a from beginning of it
fn is_sub(a : String, b : String) -> Bool {
  if a.is_empty() || b.is_empty() {
    return false
  }
  compare(a.to_array(), b.to_array(), true)
}

///|
fn compare(a : Array[Char], b : Array[Char], acc : Bool) -> Bool {
  match (a, b) {
    ([x, .. resta], [y, .. restb]) =>
      if x == y {
        compare(resta.to_owned(), restb.to_owned(), true)
      } else {
        return false
      }
    (a, []) => return acc
    _other => false
  }
}

///|
test "test substring 01 " {
  let a = "123"
  let b = "12"
  assert_true(is_sub(a, b))
}

///|
test "test substring 00" {
  assert_false(is_sub("", "b"))
}

///|
test "test substring 02 " {
  let a = "123"
  let b = "124"
  assert_false(is_sub(a, b))
}

///|
test "test substring 03 " {
  let a = "1"
  let b = ""
  assert_false(is_sub(a, b))
}
