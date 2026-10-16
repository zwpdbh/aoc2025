///|
// Main package file for your library code.
// Put public APIs and shared helpers here.
// Keep blocks small and focused for easy refactors.

pub(all) suberror Day02Error {
  InvalidStart(String)
  InvalidEnd
  InvalidInputFile
}

///|
fn get_invalid(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch {
    e => {
      println("\{x} is invalid")
      raise InvalidStart(x.to_owned())
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
pub fn run() -> Unit raise Day02Error {
  let content = @fs.read_file_to_string(
    "/home/zw/code/moonbit_programming/aoc2025/day02/tmp/input.txt",
  ) catch {
    e => raise InvalidInputFile
  }
  let mut total : Int64 = 0
  for each_line in content.split(",") {
    let invalids = get_invalid(each_line)
    for each in invalids {
      total += each
    }
  }
  println("add all of invalid IDs equal to: \{total}")
}

///|
test "11-22" {
  assert_eq(get_invalid("11-22"), [11, 22])
}

///|
test "95-115" {
  assert_eq(get_invalid("95-115"), [99])
}

///|
test "998-1012" {
  assert_eq(get_invalid("998-1012"), [1010])
}

///|
test "1188511880-1188511890" {
  assert_eq(get_invalid("1188511880-1188511890"), [1188511885])
}

///|
test "222220-222224" {
  assert_eq(get_invalid("222220-222224"), [222222])
}

///|
test "1698522-1698528" {
  assert_eq(get_invalid("1698522-1698528"), [])
}
