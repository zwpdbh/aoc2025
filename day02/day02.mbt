///|
// Main package file for your library code.
// Put public APIs and shared helpers here.
// Keep blocks small and focused for easy refactors.

pub(all) suberror Day02Error {
  InvalidStart
  InvalidEnd
  InvalidInputFile
  InvalidCase
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
fn get_invalid_case02(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch { e => raise InvalidStart }
  let end : Int64 = @string.from_str(y) catch { e => raise InvalidEnd }
  let invalids : Array[Int64] = []
  for each in start..<=end {
    let each_str = "\{each}"
    invalids.append([process_case02(each_str)])
  }
  invalids
}

///|
/// Now, an ID is invalid if it is made only of some sequence of 
/// digits repeated at least twice. So, 12341234 (1234 two times), 
/// 123123123 (123 three times), 1212121212 (12 five times), 
/// and 1111111 (1 seven times) are all invalid IDs.
fn process_case02(input : String) -> Int64 {
  0
}

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

///|
test "11-22" {
  assert_eq(get_invalid_case01("11-22"), [11, 22])
}

///|
test "95-115" {
  assert_eq(get_invalid_case01("95-115"), [99])
}

///|
test "998-1012" {
  assert_eq(get_invalid_case01("998-1012"), [1010])
}

///|
test "1188511880-1188511890" {
  assert_eq(get_invalid_case01("1188511880-1188511890"), [1188511885])
}

///|
test "222220-222224" {
  assert_eq(get_invalid_case01("222220-222224"), [222222])
}

///|
test "1698522-1698528" {
  assert_eq(get_invalid_case01("1698522-1698528"), [])
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
