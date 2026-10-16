///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.
suberror Day02MainError {
  InvalidCmdArgs
}

///|
fn main raise {
  let argv = @env.args()
  if argv.length() < 2 {
    println("run with case01 or case02")
  }
  if argv[1] == "case01" {
    @lib.run("case01")
  } else if argv[1] == "case02" {
    @lib.run("case02")
  } else {
    raise InvalidCmdArgs
  }
}
