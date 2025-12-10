class Gremlh < Formula
  desc "A CLI tool to find and fix invisible 'gremlin' characters (homoglyphs, zero-width spaces, Bidi overrides) in source code."
  homepage "https://github.com/boorboor/gremlh"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.3.0/gremlh-aarch64-apple-darwin.tar.xz"
      sha256 "5d5385555bb41a61ebb97344a5217c7b5acaec1d9597a359f9ccbb0d55fa037a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.3.0/gremlh-x86_64-apple-darwin.tar.xz"
      sha256 "b0ac798aa06c45398a6783c437e72bf5a23fc668ba0415ee621ec3794167d94c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.3.0/gremlh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dbf2b466110c4f5eb67433bae1d9b5d1bec415735667c005c33ecd510cad9059"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.3.0/gremlh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d49be9fc029ae3627f4e59776ccc20e179a0295cceb9f20b276f05ce9598794b"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gremlh" if OS.mac? && Hardware::CPU.arm?
    bin.install "gremlh" if OS.mac? && Hardware::CPU.intel?
    bin.install "gremlh" if OS.linux? && Hardware::CPU.arm?
    bin.install "gremlh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
