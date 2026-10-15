///|
pub(all) suberror DownloadError {
  /// Server answered with a non-success HTTP status (status, url).
  BadStatus(Int32, String)
  /// Redirect chain exceeded the hop limit.
  TooManyRedirects(String)
  /// Primary (and backup, when given) URL both failed.
  DownloadFailed(String)
  /// Redirect `Location` was neither absolute nor origin-relative.
  BadRedirect(String)
}

///|
pub const PROJECT_ROOT = "/home/zw/code/moonbit_programming/aoc2025"

///|
fn filename_from_url(url : String) -> String {
  let qustion_mark = url.find("?")
  let hash = url.find("#")

  let end = match (qustion_mark, hash) {
    (Some(a), Some(b)) => if a < b { a } else { b }
    (Some(a), None) => a
    (None, Some(b)) => b
    (None, None) => url.length()
  }

  let path = url[:end]

  let start = match path.rev_find("/") {
    Some(i) => i + 1
    None => 0
  }

  path[start:].to_owned()
}

///|
fn proxy_url_from_env() -> String? {
  for name in ["https_proxy", "HTTPS_PROXY", "http_proxy", "HTTP_PROXY"] {
    if @env.get_env_var(name) is Some(v) && !v.is_empty() {
      return Some(v)
    }
  }
  None
}

///|
/// Resolve a redirect `Location` against the URL that produced it.
fn resolve_redirect(current : String, location : String) -> String raise {
  if location.has_prefix("http") {
    return location
  }
  if location.has_prefix("/") {
    let after_scheme = match current.find("://") {
      Some(i) => i + 3
      None => raise DownloadError::BadRedirect(location)
    }
    let host_end = match current[after_scheme:].find("/") {
      Some(i) => after_scheme + i
      None => current.length()
    }
    return current[:host_end].to_owned() + location
  }
  raise DownloadError::BadRedirect(location)
}

///|
async fn open_stream(url : String) -> (@http.Response, @http.Client) {
  println("open_stream: \{url}")
  let mut url = url
  for _ in 0..<5 {
    let (resp, body) = @http.get_stream(url)

    match resp.code {
      301 | 302 | 303 | 307 | 308 as x =>
        match resp.headers.get(@http.CaseInsensitiveString("location")) {
          None => raise DownloadError::BadStatus(x, url)
          Some(l) => {
            body.close()
            url = resolve_redirect(url, l)
            continue
          }
        }
      x if x < 200 || x >= 300 => {
        body.close()
        println("return code is: \{x}")
        raise DownloadError::BadStatus(x, url)
      }
      _ => return (resp, body)
    }
  }
  raise DownloadError::TooManyRedirects(url)
}

///|
async fn try_download(url : String, dest : String) -> Unit {
  // 1. open stream
  // 2. check remote size 
  // 3. comparing with dest file size 
  // 4. remote size == local dest size, skip download
  // 5. otherwise keep read some data from stream until end
  // 6  close stream
  println("try_download: \{url} into file: \{dest}")

  let (resp, body) = open_stream(url)
  let remote_size = resp.headers
    .get(@http.CaseInsensitiveString("content-length"))
    .unwrap_or_error(
      DownloadError::DownloadFailed("unable to get remote file size"),
    )
    |> @string.parse_int64

  guard @fs.exists(dest) else {
    raise DownloadError::DownloadFailed(
      "specified download dest: \{dest} doesn't exist",
    )
  }

  let mut current_size = @fs.file_size(dest)
  let dest_file = @fs.open(
    dest,
    mode=@fs.WriteOnly,
    create_mode=@fs.CreateOrTruncate,
  )
  defer dest_file.close()

  while current_size != remote_size {
    match body.read_some(max_len=65536) {
      Some(chunk) => {
        dest_file.write(chunk)
        current_size += chunk.length().to_int64()
        let progress = current_size * 100 / remote_size
        @stdio.stdout.write("downloaded: \{progress}%")
      }
      None => break
    }
  }
}

///|
pub async fn download_file(url~ : String, dest_dir~ : String) -> String {
  // 1. create dest folder if not exist
  // 2. use url get downloaded file name
  // 3. get proxy 
  // 4. construct file fullpath and download
  @fs.mkdir(dest_dir, recursive=true, allow_exist=true)
  let file_to_download = filename_from_url(url)
  println("file_to_download: \{file_to_download}")
  try_download(url, dest_dir + "/" + file_to_download) catch {
    e => println("try_download failed: \{e}")
  }
  dest_dir + file_to_download
}
