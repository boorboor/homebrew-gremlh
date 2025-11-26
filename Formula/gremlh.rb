class Gremlh < Formula
  desc "CLI tool to find and fix invisible 'gremlin' characters in source code"
  homepage "https://github.com/boorboor/gremlh"
  url "https://github.com/boorboor/gremlh/archive/refs/tags/v1.0.1.tar.gz"
  sha256 ""
  license "Apache-2.0"
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Create a dirty file based on your project's tests
    (testpath/"dirty.txt").write("H\u200Bello")
    
    # Run gremlh and capture output. 
    # We expect exit code 1 (failure) because gremlins are found.
    output = shell_output("#{bin}/gremlh dirty.txt", 1)
    
    # Assert that the output contains the description of the character
    assert_match "Zero Width Space", output
  end
end
