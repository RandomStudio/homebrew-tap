class TetherLidar2dConsolidation < Formula
  desc "Tether Lidar2D Consolidator Agent, Rust edition"
  homepage "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.3.1/tether-lidar2d-consolidation-aarch64-apple-darwin.tar.xz"
      sha256 "680e59ee309a57dcddf5b163395874eb6f9d3241907a7f168157faad60130275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.3.1/tether-lidar2d-consolidation-x86_64-apple-darwin.tar.xz"
      sha256 "4e0104ad0ded46178cba3dbbca7023af2c27f9c2f2e6e615f177d599107cfdb7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.3.1/tether-lidar2d-consolidation-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fb23232c3ceeb4e0ccf9e8f2defad7dd52bc40e22d23592f496bd54e8d5e8c41"
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
