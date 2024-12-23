class TetherRplidar < Formula
  desc "RPLIDAR scanning over Tether messaging"
  homepage "https://github.com/RandomStudio/tether-rplidar-rs"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.2/tether-rplidar-aarch64-apple-darwin.tar.xz"
      sha256 "f3fdc1379dcaf03368eae94fd0fc0459cce72915975a1e006fe31a584bd7232a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.2/tether-rplidar-x86_64-apple-darwin.tar.xz"
      sha256 "e9bb7175ce176e82f4fec8da67546eb1b67b8abea14316a095c83fc5e9e21d4b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-rplidar-rs/releases/download/v0.7.2/tether-rplidar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8d2aa2b9123a9d12223d816de00c66d63620d7aeece567b969de4523866fda5b"
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
