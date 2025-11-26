class Gremlh < Formula
  desc "CLI tool to find and fix invisible 'gremlin' characters in source code"
  homepage "https://github.com/boorboor/gremlh"
  version "1.0.1"
  license "Apache-2.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v1.0.1/gremlh-macos-arm64.tar.gz"
      sha256 "124a0926434c88fad3db213988e872fec91cb127cf37904d85bf2673bcba8a92"
    else
      url "https://github.com/boorboor/gremlh/releases/download/v1.0.1/gremlh-macos-amd64.tar.gz"
      sha256 "555e818ec8c93c5b7c804c300bde28dffc1aaa5c8abc68d6c8026392fea451e5"
    end
  elsif OS.linux?
    url "https://github.com/boorboor/gremlh/releases/download/v1.0.1/gremlh-linux-amd64.tar.gz"
    sha256 "b9de716c44cb5bb6b51b3b0c403ef7d1749faa8f9f4be3b20cd3456b09817ca5"
  end

  def install
    bin.install "gremlh"
  end

  test do
    (testpath/"dirty.txt").write("H\u200Bello")
    output = shell_output("#{bin}/gremlh dirty.txt", 1)
    assert_match "Zero Width Space", output
  end
end
