class Gremlh < Formula
  desc "A CLI tool to find and fix invisible 'gremlin' characters (homoglyphs, zero-width spaces, Bidi overrides) in source code."
  homepage "https://github.com/boorboor/gremlh"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.1.0/gremlh-aarch64-apple-darwin.tar.xz"
      sha256 "1ef092a874d908aa235f0bdaae0fba2c4c8519986c973e034afd4ef3aeffff1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.1.0/gremlh-x86_64-apple-darwin.tar.xz"
      sha256 "6c434467e730f11876f6d6270012aa53110ee5410c45626800884ddc06061c77"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.1.0/gremlh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f50ccc45296aed84d4b57a372471fdd47c7d4a5abc67abfc192e97eec547dba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.1.0/gremlh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "35e57a0f36dd47d90d5684d93abb6f41b7ca4d886d60924a956d89ca1d855a59"
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
