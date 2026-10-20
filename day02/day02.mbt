///|
// Main package file for your library code.
// Put public APIs and shared helpers here.
// Keep blocks small and focused for easy refactors.

pub(all) suberror Day02Error {
  InvalidStart
  InvalidEnd
  InvalidInputFile
  InvalidCase
  InvalidStringToNum
}

///|
fn get_invalid_case01(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch {
    e => {
      println("\{x} is invalid")
      raise InvalidStart
    }
  }
  let end : Int64 = @string.from_str(y) catch { e => raise InvalidEnd }
  let invalids : Array[Int64] = []
  for each in start..<=end {
    let each_str = "\{each}"
    if each_str.length() % 2 != 0 {
      continue
    }

    let (first, second) = each_str.split_at(each_str.length() / 2)
    if first == second {
      invalids.append([each])
    }
  }

  invalids
}

///|
///case02
fn get_invalid_case02(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch { e => raise InvalidStart }
  let end : Int64 = @string.from_str(y) catch { e => raise InvalidEnd }
  let invalids : Array[Int64] = []
  for each in start..<=end {
    let each_str = "\{each}"
    let l = Lexer::new(each_str)
    match l.find_invalid() {
      Some(s) => {
        let n : Int64 = @string.from_str(s) catch {
          e => raise InvalidStringToNum
        }
        invalids.push(n)
      }
      None => continue
    }
  }
  invalids
}

///|
fn n_repeat(s : String, n : Int32) -> String {
  let mut acc = ""
  for _ in 0..<n {
    acc += s
  }
  acc
}

///|
fn n_times(s : Array[Char], n : Int32) -> Array[Char] {
  let mut acc = []
  for _ in 0..<n {
    acc += s
  }
  acc
}

///|

///|
pub fn run(case : String) -> Unit raise Day02Error {
  let content = @fs.read_file_to_string(
    "/home/zw/code/moonbit_programming/aoc2025/day02/tmp/input.txt",
  ) catch {
    e => raise InvalidInputFile
  }

  let mut total : Int64 = 0
  for each_line in content.split(",") {
    let invalids = match case {
      "case01" => get_invalid_case01(each_line)
      "case02" => get_invalid_case02(each_line)
      _ => raise InvalidCase
    }
    for each in invalids {
      total += each
    }
  }
  println("add all of invalid IDs equal to: \{total}")
}
