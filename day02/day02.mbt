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
    _e => {
      println("\{x} is invalid")
      raise InvalidStart
    }
  }
  let end : Int64 = @string.from_str(y) catch { _e => raise InvalidEnd }
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
/// Return the input if it is some digit sequence repeated two or more times,
/// otherwise return None.
/// The general idea is: 
/// try every possible repeating-unit length, and check whether the string is that unit repeated.
fn find_invalid(input : String) -> String? {
  let n = input.length()
  // unit_length is length of repeating candidate's length, since we are testing if there at least repeating twice
  // the maxium repeating candidate's length must be equal to the half of the input string
  for unit_length in 1..<=(n / 2) {
    // the repeating units's length must also be： Divisible of the length of input string
    if n % unit_length != 0 {
      continue
    }

    // This checks whether the string really is that unit repeated.
    let mut matches = true
    for i in unit_length..<n {
      let current_char = input.get_char(i)
      // that is the key part: exepcted_char's index is the current examing one's index % the length of the repeated unit
      let expected_char = input.get_char(i % unit_length)
      if current_char != expected_char {
        matches = false
        // only exits the loop it is directly inside.
        break
      }
    }
    if matches {
      return Some(input)
    }
  }
  None
}

///|
///case02
fn get_invalid_case02(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch { _e => raise InvalidStart }
  let end : Int64 = @string.from_str(y) catch { _e => raise InvalidEnd }
  let invalids : Array[Int64] = []
  for each in start..<=end {
    match find_invalid("\{each}") {
      Some(s) => {
        let n : Int64 = @string.from_str(s) catch {
          _e => raise InvalidStringToNum
        }
        invalids.push(n)
      }
      None => continue
    }
  }
  invalids
}

///|

///|
pub fn run(case : String) -> Unit raise Day02Error {
  let content = @fs.read_file_to_string(
    "/home/zw/code/moonbit_programming/aoc2025/day02/tmp/input.txt",
  ) catch {
    _e => raise InvalidInputFile
  }

  let start = @env.now()
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
  let elapsed = @env.now() - start
  println("add all of invalid IDs equal to: \{total}")
  println("elapsed: \{elapsed} ms")
}
