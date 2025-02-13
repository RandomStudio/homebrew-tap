class TetherSoundscape < Formula
  desc "A remote-controllable audio sequencer"
  homepage "https://github.com/RandomStudio/tether-soundscape-rs"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RandomStudio/tether-soundscape-rs/releases/download/v0.5.3/tether-soundscape-aarch64-apple-darwin.tar.xz"
      sha256 "9aa88da710ef602bc71be66eaf6a572e443a164eb9f30b9b45ca6809dc84a651"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RandomStudio/tether-soundscape-rs/releases/download/v0.5.3/tether-soundscape-x86_64-apple-darwin.tar.xz"
      sha256 "0728ca0ea98b0eb27b108649c2bd15d4407b1fdd8d266e5e6fcc9f061fdd4d2d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/RandomStudio/tether-soundscape-rs/releases/download/v0.5.3/tether-soundscape-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "29fa0f28fee6657c8ecbf35a41ad9e5febc2b0118974e53104238004ee6d5f7b"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "tether-soundscape" if OS.mac? && Hardware::CPU.arm?
    bin.install "tether-soundscape" if OS.mac? && Hardware::CPU.intel?
    bin.install "tether-soundscape" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
