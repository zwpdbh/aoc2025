///|
const INPUT_FILE = "/home/zw/code/moonbit_programming/aoc2025/day03/tmp/input.txt"

///|
pub(all) suberror Day03Error {
  InvalidInputFile(String)
  InvalidDigitNumberProcess
}

///|
pub fn run(case : String) -> Unit raise Day03Error {
  match case {
    "case01" => run_case01()
    "case02" => run_case02()
    _ => println("day03 \{case}: not implemented")
  }
}

///|
fn run_case01() -> Unit raise Day03Error {
  let lines = process_input(INPUT_FILE)
  let mut total = 0
  for each_line in lines {
    total += find_joltage(each_line)
  }
  println("total: \{total}")
}

///|
fn run_case02() -> Unit {
  abort("TODO")
}

///|
fn process_input(input_file : String) -> Array[String] raise Day03Error {
  let content = @fs.read_file_to_string(input_file) catch {
    _e => raise InvalidInputFile("\{input_file} could not be loaded")
  }
  let joltages : Array[String] = []
  for each in content.split("\n") {
    joltages.push(each.to_owned())
  }
  joltages
}

///|
fn char_to_int(c : Char) -> Int32 {
  c.to_int() - '0'.to_int()
}

///|
fn find_joltage(s : String) -> Int32 {
  s |> battery_numbers() |> find_max_two_digits_number()
}

///|
fn battery_numbers(s : String) -> Array[Int32] {
  s.to_array().fold(init=[], (acc, each) => acc + [char_to_int(each)])
}

///|
fn find_max_two_digits_number(input : Array[Int32]) -> Int32 {
  // println("input: \{repr(input)}")

  let last_index = input.length() - 1
  let (first_index, first_one) = input
    .iter2()
    .iter()
    .fold(init=(0, input[0]), (acc, each) => {
      guard acc is (acc_index, acc_one)
      guard each is (each_index, each_one)
      if each_one > acc_one && each_index != last_index {
        (each_index, each_one)
      } else {
        (acc_index, acc_one)
      }
    })

  // println("first_one: \{first_one}")

  let (second_index, second_one) = input
    .iter2()
    .iter()
    .fold(init=(first_index + 1, input[first_index + 1]), (acc, each) => {
      guard acc is (acc_index, acc_one)
      guard each is (each_index, each_one)

      if each_index > acc_index && each_one > acc_one {
        (each_index, each_one)
      } else {
        (acc_index, acc_one)
      }
    })
  // println("second_one: \{second_one}")
  first_one * 10 + second_one
}
