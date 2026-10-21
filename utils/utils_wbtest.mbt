// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
test "parse case" {
  assert_eq(parse_case_from(["day02", "case01"]), "case01")
  assert_eq(parse_case_from(["day02", "case02"]), "case02")
}

///|
test "parse case errors" {
  try {
    let _ = parse_case_from(["day02"])
    fail("expected MissingCase")
  } catch {
    MissingCase => ()
    _ => fail("unexpected error")
  }
  try {
    let _ = parse_case_from(["day02", "case03"])
    fail("expected InvalidCase")
  } catch {
    InvalidCase("case03") => ()
    _ => fail("unexpected error")
  }
}
