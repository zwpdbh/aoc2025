///|
// A lexer that detects whether its input is a repeated pattern:
// some digit sequence repeated two or more times (e.g. "55", "6464",
// "123123123"). It consumes characters one at a time while maintaining
// the KMP prefix function, so detection is a single streaming pass.

///|
pub struct Lexer {
  input : String
  mut read_position : Int32
  // Length of the longest proper border of the prefix consumed so far.
  mut border : Int32
  // KMP prefix function: pi[i] = border length of input[:i+1].
  pi : Array[Int32]
}

///|
pub fn Lexer::new(input : String) -> Lexer {
  Lexer::{ input, read_position: 0, border: 0, pi: [], }
}

///|
fn Lexer::read_char(self : Self) -> Char? {
  if self.read_position >= self.input.length() {
    return None
  }
  let c = self.input.get_char(self.read_position).unwrap()
  self.read_position += 1
  // The first character always has an empty proper border.
  if self.pi.is_empty() {
    self.pi.push(0)
    return Some(c)
  }
  // KMP step: extend the border of the prefix with the new character.
  while self.border > 0 && self.input.get_char(self.border) != Some(c) {
    self.border = self.pi[self.border - 1]
  }
  if self.input.get_char(self.border) == Some(c) {
    self.border += 1
  }
  self.pi.push(self.border)
  Some(c)
}

///|
fn Lexer::find_invalid(self : Self) -> String? {
  while self.read_char() is Some(_) {

  }
  let n = self.input.length()
  // The shortest repeating unit has length n - border. The whole string
  // is a repetition iff that unit is strictly shorter and tiles n evenly.
  let period = n - self.border
  if period < n && n % period == 0 {
    Some(self.input)
  } else {
    None
  }
}
