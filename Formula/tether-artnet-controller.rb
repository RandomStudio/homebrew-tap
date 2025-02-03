class TetherArtnetController < Formula
  desc "A remote control software lighting desk"
  homepage "https://github.com/RandomStudio/tether-artnet-controller"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.4/tether-artnet-controller-aarch64-apple-darwin.tar.xz"
      sha256 "8aeefa52a5efe58827bc75004c03df9c384c796ca6dff4bb9ec65c14c4f4da89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.4/tether-artnet-controller-x86_64-apple-darwin.tar.xz"
      sha256 "30c3ce49472974db9468e43ea80af4f6474f4ba2a66a72530daf142602aaf92f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.4/tether-artnet-controller-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ee7bba66cb67f9d496f98cd35afc5efe6c9bfcecc659bb3537858606a95809e8"
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
