class TetherUtils < Formula
  desc "Utilities for Tether Systems"
  homepage "https://github.com/RandomStudio/tether"
  version "0.11.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.4/tether-utils-aarch64-apple-darwin.tar.xz"
      sha256 "c60f2fdb7dd685c6836ec778b452c9d62b72001a285b1f71468f893220db42a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.4/tether-utils-x86_64-apple-darwin.tar.xz"
      sha256 "a896e0d1cd3d1512be4899baf9ea936f79fa092c4489d4ea38edb15a2d8c01e2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.4/tether-utils-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "64235b8a89624f568e061d9d3930e9271eaea137f7fb16d9ca5985db510eb95e"
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
