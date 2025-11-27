class Gremlh < Formula
  desc "A CLI tool to find and fix invisible 'gremlin' characters (homoglyphs, zero-width spaces, Bidi overrides) in source code."
  homepage "https://github.com/boorboor/gremlh"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/1.0.0/gremlh-aarch64-apple-darwin.tar.xz"
      sha256 "c639eca0b9a4355f791b119179e82fcefe14cbcd0d01b539730d7033d034a061"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/1.0.0/gremlh-x86_64-apple-darwin.tar.xz"
      sha256 "3d94f4e2af897e0c24d16b0f2bc9a332aaf2f6f5b1e6bd7d8e7120e18b571cde"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/1.0.0/gremlh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f4458a1a3eb96458ecc2e63426175cf7a6d029fdfd94ba2eaffc4789414bb25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/1.0.0/gremlh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13c95bdaebf849f1229e8868e5ac597926210d5b8095efd986a20191680948f7"
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
