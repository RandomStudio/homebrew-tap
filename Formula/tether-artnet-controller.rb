class TetherArtnetController < Formula
  desc "A remote control software lighting desk"
  homepage "https://github.com/RandomStudio/tether-artnet-controller"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.1/tether-artnet-controller-aarch64-apple-darwin.tar.xz"
      sha256 "c58d510936012f2a7bb4fe2c3eaacb16212b3882693ae53c7cfb68693bd6be95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.1/tether-artnet-controller-x86_64-apple-darwin.tar.xz"
      sha256 "9a6d73e17fafe2ede7fc59795366ec64be9708d6d0a1f04df2091cc8ce43990e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-artnet-controller/releases/download/v0.8.1/tether-artnet-controller-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0de5aaa4497f296c7cfecf68e19350b3b6deee810d3b61856d92dcc396116097"
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
