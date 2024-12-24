class TetherEgui < Formula
  desc "GUI for building and testing Tether-based applications"
  homepage "https://github.com/RandomStudio/tether-egui"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.2/tether-egui-aarch64-apple-darwin.tar.xz"
      sha256 "8da1cc15347c560813cc22324d4aaa0a7b61d47be164e24d3ca6ef0d8d89b7f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.2/tether-egui-x86_64-apple-darwin.tar.xz"
      sha256 "02542a11c468f835638684db6b26e96d35dd3cb8c493dfc7fec9d237bf216d0c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-egui/releases/download/v0.10.2/tether-egui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0fe96aef765e78de2e78b1bd58a38329f3d994fa6ee79be67e2e5c0114b12d3c"
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
