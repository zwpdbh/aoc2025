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
fn get_invalid_case02(input : StringView) -> Array[Int64] raise Day02Error {
  let (x, y) = input.split_once("-").unwrap()
  let start : Int64 = @string.from_str(x) catch { e => raise InvalidStart }
  let end : Int64 = @string.from_str(y) catch { e => raise InvalidEnd }
  let invalids : Array[Int64] = []
  for each in start..<=end {
    let each_str = "\{each}"
    match process_case02(each_str) {
      None => continue
      Some(s) => {
        let n : Int64 = @string.from_str(s) catch {
          e => raise InvalidStringToNum
        }
        if n >= start && n <= end {
          invalids.append([n])
        }
      }
    }
  }
  invalids
}

///|
fn get_invalid_case02v2(input : StringView) -> Array[Int64] raise Day02Error {
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
priv struct RepeatPattern {
  pattern : String
  times : Int32
}

///|
fn RepeatPattern::new(pattern~ : Array[Char], count~ : Int32) -> RepeatPattern {
  RepeatPattern::{ pattern: pattern |> String::from_array(), times: count, }
}

///|
fn RepeatPattern::to_int(self : Self) -> Int64 raise Day02Error {
  let s = self.pattern |> n_repeat(self.times)
  let n : Int64 = @string.from_str(s) catch { e => raise InvalidStringToNum }
  n
}

///|
fn RepeatPattern::to_string(self : Self) -> String? {
  if self.times > 1 {
    Some(self.pattern |> n_repeat(self.times))
  } else {
    None
  }
}

///|
/// Now, an ID is invalid if it is made only of some sequence of 
/// digits repeated at least twice. So, 12341234 (1234 two times), 
/// 123123123 (123 three times), 1212121212 (12 five times), 
/// and 1111111 (1 seven times) are all invalid IDs.
fn process_case02(input : String) -> String? {
  let chars = input.iter().collect()
  process(current=[], rest=chars, acc=[], count=1)
}

///|
fn process(
  current~ : Array[Char],
  rest~ : ArrayView[Char],
  acc~ : Array[Char],
  count~ : Int32,
) -> String? {
  // println("current: ~\{current}, rest: \{rest}, acc: \{acc}, count: \{count}")
  match (current, rest, acc) {
    (current, [], []) => {
      let rp = RepeatPattern::new(pattern=current, count~)
      rp.to_string()
    }
    ([], [x, .. others], []) =>
      // println("case01")
      process(current=[x], rest=others, acc=[], count=1)
    (current, [x, .. others], acc) =>
      if current == acc + [x] {
        // println("case02-a")
        process(current~, rest=others, acc=[], count=count + 1)
      } else if current.length() == (acc + [x]).length() {
        // println("case02-b")
        let a = process(
          current=n_times(current, count) + acc + [x],
          rest=others,
          acc=[],
          count=1,
        )
        let b = process(
          current=n_times(current, count) + acc,
          rest=others,
          acc=[x],
          count~,
        )
        match (a, b) {
          (Some(x), None) => Some(x)
          (None, Some(y)) => Some(y)
          (_, _) => None
        }
      } else {
        // println("case02-c")
        process(current~, rest=others, acc=acc + [x], count~)
      }
    (current, [], acc) => None
  }
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
      "case02" => get_invalid_case02v2(each_line)
      _ => raise InvalidCase
    }
    for each in invalids {
      total += each
    }
  }
  println("add all of invalid IDs equal to: \{total}")
}
