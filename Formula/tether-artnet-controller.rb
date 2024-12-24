class TetherArtnetController < Formula
  desc "A remote control software lighting desk"
  homepage "https://github.com/RandomStudio/tether-artnet-controller"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.0/tether-artnet-controller-aarch64-apple-darwin.tar.xz"
      sha256 "c61f887b032f60d19907c6867efde17dbfc467178aa73c93492abb4f96f7e317"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.0/tether-artnet-controller-x86_64-apple-darwin.tar.xz"
      sha256 "db5723568ed81886ee104abfe4c847a9fa4043b728322e49612bd95db0c45538"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.0/tether-artnet-controller-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "04ebc2624874a5eb749624bba113180cadde612726eb56e5c205a8e48a48ad35"
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
    bin.install "tether-artnet-controller" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether-artnet-controller" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether-artnet-controller" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
