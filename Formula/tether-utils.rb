class TetherUtils < Formula
  desc "Utilities for Tether Systems"
  homepage "https://github.com/RandomStudio/tether"
  version "0.11.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.3/tether-utils-aarch64-apple-darwin.tar.xz"
      sha256 "898f53d803e933847e802bcbb8cfd2a0d807afe46d79f2599b29f5b54dbd788f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.3/tether-utils-x86_64-apple-darwin.tar.xz"
      sha256 "8b87bb8bce8be715dd198f1dc28551178a920ea18e91833281ac46f1d90c228c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.3/tether-utils-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4f51af44218af6d691436cab34c94fc9389eef103b0aa1c9b9a8c3ca76853350"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "tether" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
