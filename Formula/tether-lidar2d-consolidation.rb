class TetherLidar2dConsolidation < Formula
  desc "Tether Lidar2D Consolidator Agent, Rust edition"
  homepage "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.1.0/tether-lidar2d-consolidation-aarch64-apple-darwin.tar.xz"
      sha256 "9603c28c1206a184c23ab632f4bfa82610b1eff0c7675668c4306d29bef4d59c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.1.0/tether-lidar2d-consolidation-x86_64-apple-darwin.tar.xz"
      sha256 "635f8746465f66b7133cb45797d3239db23f18b7779675985ea1613d759f23f7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.1.0/tether-lidar2d-consolidation-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fd7489482ec51e8c8c73dbba8d6edcc0d2dd687e8ef4f001c70e7623f2e14f20"
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
