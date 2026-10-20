///|
pub struct Lexer {
  input : String
  mut read_position : Int32
  mut position : Int32
  mut ch : Char?
  pattern : Pattern
  mut acc : String
}

///|
struct Pattern {
  mut value : String
  mut repeated : Int32
}

///|
fn Pattern::to_string(self : Self) -> String {
  let mut acc = ""
  for _ in 0..<self.repeated {
    acc += self.value
  }
  acc
}

///|
pub fn Lexer::new(input : String) -> Lexer {
  let l = Lexer::{
    input,
    read_position: 0,
    position: -1,
    ch: None,
    pattern: Pattern::{ value: "", repeated: 1, },
    acc: "",
  }
  let _ = l.read_char()
  l
}

///|
fn Lexer::find_invalid(self : Self) -> String? {
  while true {
    match self.ch {
      None => break
      Some(_) => self.next_char()
    }
  }

  if self.pattern.repeated > 1 {
    Some(self.pattern.to_string())
  } else {
    None
  }
}

///|
fn Lexer::read_char(self : Self) -> Char? {
  if self.read_position >= self.input.length() {
    self.ch = None
  } else {
    self.ch = self.input.get_char(self.read_position)
  }

  self.position = self.read_position
  self.read_position += 1
  self.input.get_char(self.position)
}

///|
fn Lexer::next_char(self : Self) -> Unit {
  let acc = match self.ch {
    Some(c) => self.acc + "\{c}"
    None => self.acc
  }

  if acc == self.pattern.value {
    self.pattern.repeated += 1
    self.acc = ""
  } else if !is_sub(self.pattern.value, self.acc) {
    self.pattern.value = self.pattern.to_string() + acc
    self.pattern.repeated = 1
    self.acc = ""
  }
  let _ = self.read_char()
}

///|
/// Compare if b is sub string of a from beginning of it
fn is_sub(a : String, b : String) -> Bool {
  if a.length() < b.length() {
    return false
  }
  compare(a.to_array(), b.to_array(), true)
}

///|
fn compare(a : Array[Char], b : Array[Char], acc : Bool) -> Bool {
  match (a, b) {
    ([x, .. resta], [y, .. restb]) =>
      if a == b {
        compare(resta.to_owned(), restb.to_owned(), true)
      } else {
        return false
      }
    (a, []) => return acc
    _other => false
  }
}

///|
test "test substring" {
  let a = "123"
  let b = "12"
  assert_true(is_sub(a, b))
}

///|
test "12121212" {
  let l = Lexer::new("121212")
  let p = l.find_invalid()
  guard p is Some(v) else { abort("Failed to find repeated pattern") }
  assert_eq(v, "121212")
}
