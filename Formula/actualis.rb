class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/64/13/c0704ea16c1cf2743da08dfd731dc5c8e4c657c0bc9a9599597421631aaf/actualis-0.3.0.tar.gz"
  sha256 "e8f687bb059110b11be913fab89edcf624f243d3aa7448231cafefa7e162a9d9"
  license "AGPL-3.0-or-later"

  # Standard library only, so there are no resources to vendor: the formula
  # installs one file and a wrapper that runs it with brew's Python.
  depends_on "python@3.13"

  def install
    libexec.install "actualis.py"
    (bin/"actualis").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("python@3.13")}/python3.13" "#{libexec}/actualis.py" "$@"
    SH
  end

  test do
    assert_match "actualis 0.3.0", shell_output("#{bin}/actualis --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
