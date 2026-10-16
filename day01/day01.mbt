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
  // let input_file = @utils.download_file(url=DAY01INPUT, dest_dir=download_dir)
  let input_file = "/home/zw/code/moonbit_programming/aoc2025/day01/tmp/input"
  guard @fs.path_exists(input_file) else {
    raise InvalidInput("file now exist")
  }
  let conent = @fs.read_file_to_string(input_file)

  conent
}

///|
priv struct Dial {
  mut at : Int32
}

///|
fn Dial::new(at : Int32) -> Dial {
  Dial::{ at, }
}

///|
fn Dial::rotate(self : Dial, rotate : Rotate) -> Int32 {
  let mut triggered = 0
  match rotate {
    L(n) =>
      for _ in 0..<n {
        self.at -= 1
        if self.at == 0 {
          triggered += 1
        }
        if self.at == -1 {
          self.at = 99
        }
      }
    R(n) =>
      for _ in 0..<n {
        self.at += 1

        if self.at == 100 {
          self.at = 0
        }
        if self.at == 0 {
          triggered += 1
        }
      }
  }

  triggered
}

///|
fn get_passwd_from(content~ : String) -> Int32 raise Day01Error {
  let lines = content.split("\n")
  let dial = Dial::new(50)
  let mut triggered = 0
  for each_line in lines {
    if each_line.trim().is_empty() {
      continue
    }
    let rotate = parse_to_rotate(each_line.to_owned())
    triggered += dial.rotate(rotate)
  }
  triggered
}

///|
pub async fn run() -> Unit {
  let content = read_input()
  let passwd = get_passwd_from(content~)
  println("passwd is: \{passwd}")
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
fn parse_to_rotate(line : String) -> Rotate raise Day01Error {
  match line.trim().to_array() {
    ['L', .. rest] => L(parse_num(rest))
    ['R', .. rest] => R(parse_num(rest))
    others => {
      println("line: \{line} is invalid format")
      raise InvalidFormat(line)
    }
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
  println("\{parse_to_rotate("L98")}")
  assert_eq(L(98), parse_to_rotate("L98"))
}

///|
test "day01b" {
  let content =
    #| L68
    #| L30
    #| R48
    #| L5
    #| R60
    #| L55
    #| L1
    #| L99
    #| R14
    #| L82
    #|

  let passwd = get_passwd_from(content~)

  assert_eq(6, passwd)
}
