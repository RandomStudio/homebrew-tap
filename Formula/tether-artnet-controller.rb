class TetherArtnetController < Formula
  desc "A remote control software lighting desk"
  homepage "https://github.com/RandomStudio/tether-artnet-controller"
  version "0.8.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.6/tether-artnet-controller-aarch64-apple-darwin.tar.xz"
      sha256 "0bee25436a3985909aca2ce63539034aba30735865f181733060425b50ebf785"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.6/tether-artnet-controller-x86_64-apple-darwin.tar.xz"
      sha256 "e3cdab91e2c037190087e8792a0c04a6adfccd84959ac4deb45c38542dd5b56d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.6/tether-artnet-controller-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7507ad9e8be979a0c8d5bf759400bc5b726876d6b57885a17e761b7ba61ab4d3"
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
