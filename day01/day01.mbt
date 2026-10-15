// Main package file for your library code.
// Put public APIs and shared helpers here.
// Keep blocks small and focused for easy refactors.

///|
const DAY01INPUT = "https://adventofcode.com/2025/day/1/input"

///|
pub(all) suberror Day01Error {
  InvalidInput(String)
  InvalidFormat(String)
}

///|
async fn read_input() -> String {
  let download_dir = @utils.PROJECT_ROOT + "/day01" + "/tmp"
  let input_file = @utils.download_file(url=DAY01INPUT, dest_dir=download_dir)
  guard @fs.path_exists(input_file) else {
    raise InvalidInput("file now exist")
  }
  let conent = @fs.read_file_to_string(input_file)

  conent
}

///|
pub async fn run() -> Unit {
  let content = read_input()
  let lines = content.split("\n")
  for each_line in lines {
    abort("HOW to do binary patter matching")
  }
}

///|
priv enum Rotate {
  L(Int32)
  R(Int32)
} derive(Debug, Eq)

///|
impl Show for Rotate with fn output(self, logger) -> Unit {
  match self {
    L(n) => logger.write_string("L(\{n})")
    R(n) => logger.write_string("R(\{n})")
  }
}

///|
fn parse_chars(line : String) -> Rotate raise Day01Error {
  match line.to_array() {
    ['L', .. rest] => L(parse_num(rest))
    ['R', .. rest] => R(parse_num(rest))
    others => raise InvalidFormat(line)
  }
}

///|
fn parse_num(
  input : ArrayView[Char],
  acc~ : Int32 = 0,
) -> Int32 raise Day01Error {
  let mut acc = 0
  for each in input {
    acc *= 10
    let n = parse_to_n(each)
    acc += n
  }
  acc
}

///|
fn parse_to_n(c : Char) -> Int32 raise Day01Error {
  match c {
    '0' => 0
    '1' => 1
    '2' => 2
    '3' => 3
    '4' => 4
    '5' => 5
    '6' => 6
    '7' => 7
    '8' => 8
    '9' => 9
    x => raise InvalidFormat("\{x} is not digit during parse c to n")
  }
}

///|
test "protocol" {
  println("\{parse_chars("L98")}")
  assert_eq(L(98), parse_chars("L98"))
}
