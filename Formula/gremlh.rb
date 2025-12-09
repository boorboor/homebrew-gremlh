class Gremlh < Formula
  desc "A CLI tool to find and fix invisible 'gremlin' characters (homoglyphs, zero-width spaces, Bidi overrides) in source code."
  homepage "https://github.com/boorboor/gremlh"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.2.0/gremlh-aarch64-apple-darwin.tar.xz"
      sha256 "639212cca42237ba0db0564827624a75a6e8e9a0e2922d540df06fd54cdc382e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.2.0/gremlh-x86_64-apple-darwin.tar.xz"
      sha256 "3f099bd31e7e337e6cd5cc4b15f7e881cb523bcea1d9300b19fd32616170cf22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/boorboor/gremlh/releases/download/v0.2.0/gremlh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70e3b40a2863f39896ee69ce3fe6563f745b6f6579865d6d076a29aec5803547"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boorboor/gremlh/releases/download/v0.2.0/gremlh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e06c3733eac06ded98396686877bdf4445a30232e7fc8ea8310aa27fbb310063"
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
