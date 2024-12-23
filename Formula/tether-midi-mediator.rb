class TetherMidiMediator < Formula
  desc "MIDI to Tether messages"
  homepage "https://github.com/RandomStudio/tether-midi-mediator.git"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-midi-mediator/releases/download/v0.4.4/tether-midi-mediator-aarch64-apple-darwin.tar.xz"
      sha256 "423fceb67bdccb18966a449419850cc573e50ca49d0278208fc7d9f326c73472"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-midi-mediator/releases/download/v0.4.4/tether-midi-mediator-x86_64-apple-darwin.tar.xz"
      sha256 "29d9797190f7296dfb7302880430a97bd3527c3b64edcd7cbaf3c48c72366cd3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-midi-mediator/releases/download/v0.4.4/tether-midi-mediator-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "55753ab231ba360953a626b6f67e31cde8a9bcc802e6921ef06073e9f0dd74b1"
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
    bin.install "tether-midi" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether-midi" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether-midi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
