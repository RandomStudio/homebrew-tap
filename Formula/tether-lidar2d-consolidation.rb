class TetherLidar2dConsolidation < Formula
  desc "Tether Lidar2D Consolidator Agent, Rust edition"
  homepage "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.3/tether-lidar2d-consolidation-aarch64-apple-darwin.tar.xz"
      sha256 "532e189fb8e89f5ecaba2d05e07bc7c0242a95048837f3b0fbf6a4c474ca7c48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.3/tether-lidar2d-consolidation-x86_64-apple-darwin.tar.xz"
      sha256 "bf93d08bd4686a8c454f404c3b084c19314a049f5f795121c373d3defb20c84d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.0.3/tether-lidar2d-consolidation-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "83b96031fa08eed4efcdf41dc2c7c056920804640b141af93fbca64a317b69ef"
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
