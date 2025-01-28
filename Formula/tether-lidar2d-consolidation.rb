class TetherLidar2dConsolidation < Formula
  desc "Tether Lidar2D Consolidator Agent, Rust edition"
  homepage "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.0/tether-lidar2d-consolidation-aarch64-apple-darwin.tar.xz"
      sha256 "a6fe67f3c7a27b68e8a85427c8a00bafae80bb6e6752b56a0ecf4e3bb4036311"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.0/tether-lidar2d-consolidation-x86_64-apple-darwin.tar.xz"
      sha256 "e66297ef0d8147704f00c79c371948c31f5bbf67a4ddc74b979f8ba64cf220ee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.0/tether-lidar2d-consolidation-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "abffd4b4604239590925964f4e737144450c7a31d924b583db646543820bf707"
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
    bin.install "lidar2d-backend", "lidar2d-frontend" if OS.mac? && Hardware::CPU.arm?
    bin.install "lidar2d-backend", "lidar2d-frontend" if OS.mac? && Hardware::CPU.intel?
    bin.install "lidar2d-backend", "lidar2d-frontend" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
