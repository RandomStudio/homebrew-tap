class TetherRplidar < Formula
  desc "RPLIDAR scanning over Tether messaging"
  homepage "https://github.com/RandomStudio/tether-rplidar-rs"
  version "0.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.3/tether-rplidar-aarch64-apple-darwin.tar.xz"
      sha256 "8a9362c54064e2e2e901a8f1e0c01115358ac7afbc7528737f7ad092b33a9112"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.3/tether-rplidar-x86_64-apple-darwin.tar.xz"
      sha256 "0d36da30671c5b843b8fd2f9c9c5a1f495838342eac7a9e1e216504fc7b38643"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.3/tether-rplidar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ea9e7363a3e992a3d0f55ea606a9720ba29bccd28275ca61671a53420461b8d5"
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
    bin.install "tether-rplidar" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether-rplidar" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether-rplidar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
