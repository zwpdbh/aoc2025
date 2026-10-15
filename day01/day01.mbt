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
async fn stream_input() -> Iter[String] {
  let download_dir = @utils.PROJECT_ROOT + "/day01" + "/tmp"
  let input_file = @utils.download_file(url=DAY01INPUT, dest_dir=download_dir)
  guard @fs.path_exists(input_file) else { raise InvalidInput }
  abort("TODO")
}

///|
pub async fn run() -> Unit {
  let _ = stream_input()
}
