class TetherEgui < Formula
  desc "GUI for building and testing Tether-based applications"
  homepage "https://github.com/RandomStudio/tether-egui"
  version "0.10.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.5/tether-egui-aarch64-apple-darwin.tar.xz"
      sha256 "65a6d9912cc09828448692b26d97cb8cc0bb394f5a1f539bd6fac832be38ad95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.5/tether-egui-x86_64-apple-darwin.tar.xz"
      sha256 "bebd9c040e40245d270bcde8f5b405d437367763ab3bba1d575b26c6ebcac830"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.5/tether-egui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c6d6066eec92e2873d753f8d4fbf016b6ec3e6bdaa8d3008be5fb8885c41e144"
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
    bin.install "tether-egui" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether-egui" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether-egui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
