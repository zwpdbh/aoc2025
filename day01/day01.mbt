// Main package file for your library code.
// Put public APIs and shared helpers here.
// Keep blocks small and focused for easy refactors.

///|
const DAY01INPUT = "https://adventofcode.com/2025/day/1/input"

///|
pub(all) suberror Day01Error {
  InvalidInput
}

///|
async fn read_input() -> String {
  let download_dir = @utils.PROJECT_ROOT + "/day01" + "/tmp"
  let input_file = @utils.download_file(url=DAY01INPUT, dest_dir=download_dir)
  guard @fs.path_exists(input_file) else { raise InvalidInput }
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
