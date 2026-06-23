class Cellar < Formula
  desc "Have files. Will ISO."
  homepage "https://github.com/trapdoorsec/homebrew-tap"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/trapdoorsec/cellar/releases/download/v0.2.1/cellar-aarch64-apple-darwin.tar.xz"
    sha256 "18af5579c95df24e575039aec3c1f3ecdda815920ba14604eed71fe4d14d1896"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/trapdoorsec/cellar/releases/download/v0.2.1/cellar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b475c9084a9e5856433f8911df3890f4a08630865e54c4bfca0352361d2c83c6"
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
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
    bin.install "cellar" if OS.mac? && Hardware::CPU.arm?
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
