class Cellar < Formula
  desc "Have files. Will ISO."
  homepage "https://github.com/trapdoorsec/homebrew-tap"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/trapdoorsec/cellar/releases/download/v0.2.1/cellar-aarch64-apple-darwin.tar.xz"
    sha256 "8a756f6684895b307b8b5968320210aeaa7234825cf725678c734a9723f557c2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/trapdoorsec/cellar/releases/download/v0.2.1/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7cea08fada5eff855f1c1c34a631b83578058980c58669d0a05c4f39c2837e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/trapdoorsec/cellar/releases/download/v0.2.1/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7a0e88fdd0b2c4468387b8e854da922715b1dfec42aef61d06503349367bdbd"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "cellar" if OS.mac? && Hardware::CPU.arm?
    bin.install "cellar" if OS.linux? && Hardware::CPU.arm?
    bin.install "cellar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
