class TetherUtils < Formula
  desc "Utilities for Tether Systems"
  homepage "https://github.com/RandomStudio/tether"
  version "0.11.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.2/tether-utils-aarch64-apple-darwin.tar.xz"
      sha256 "a915b05a476b1b18b9f96eedc57a194dde761ea90348e4b701156a8017053712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.2/tether-utils-x86_64-apple-darwin.tar.xz"
      sha256 "200502602ca25dab3c117bfe9f43de68eff91ce2fac84495c4d56b192d30fb23"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.2/tether-utils-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "694f26cfe1de86eb205ef484af2f47a3ecdaebc4818835835193d21b4dbf0116"
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
