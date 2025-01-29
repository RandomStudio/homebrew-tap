class TetherLidar2dConsolidation < Formula
  desc "Tether Lidar2D Consolidator Agent, Rust edition"
  homepage "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.2.0/tether-lidar2d-consolidation-aarch64-apple-darwin.tar.xz"
      sha256 "1e6583601dd18403c8dcf3a1e28e4262fb19dd9f511b75fb69d9e630ec2973e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.2.0/tether-lidar2d-consolidation-x86_64-apple-darwin.tar.xz"
      sha256 "4715afdc9b3c0c7115b341bfdf2a9637134150976e0a830f30416c765e8575d8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-lidar2d-consolidation-rs/releases/download/v1.2.0/tether-lidar2d-consolidation-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bf62b8ba145a718f5002b11a960baac83fe1c031219504d6506fe06fcf41704a"
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
