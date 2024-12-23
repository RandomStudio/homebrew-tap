class TetherUtils < Formula
  desc "Utilities for Tether Systems"
  homepage "https://github.com/RandomStudio/tether"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.1/tether-utils-aarch64-apple-darwin.tar.xz"
      sha256 "5c4faf57493c4da2ac755d051086a9c633f5cf4ae396511fce8a9e895a7eeffa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.1/tether-utils-x86_64-apple-darwin.tar.xz"
      sha256 "db4e11a90bf665196100b445a35cc529e0b2b0d0dc7991fdba115f6aaa0914a8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether/releases/download/tether-utils-v0.11.1/tether-utils-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3d111cd3be5c60cb96c4f14e9eefe3270f0eb9745359748e9a7126edb6742fa4"
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
