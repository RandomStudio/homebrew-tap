class TetherArtnetController < Formula
  desc "A remote control software lighting desk"
  homepage "https://github.com/RandomStudio/tether-artnet-controller"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.7.4/tether-artnet-controller-aarch64-apple-darwin.tar.xz"
      sha256 "b326ba7d5107ddb2751e5262d7edd7045dedcda69968e130db805825529ff86f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.7.4/tether-artnet-controller-x86_64-apple-darwin.tar.xz"
      sha256 "5556bd808b9bcf1313fcbd3f10e9d74b0118f2755f7c5dcb9c7538aa3b66e2e7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.7.4/tether-artnet-controller-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ba88de42d5de90b2e95eb26efec872d910561b32824b0d9c5836943276d2a39c"
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
