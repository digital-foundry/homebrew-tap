class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/83/82/3e50019eb205c87f8cc5f21feffd9edb0f8b1dd4211110a0ed0869894f19/actualis-0.4.0.tar.gz"
  sha256 "78257149ffe32e849e913a0e8bcdb3a0379468d67b0249154b261083d0d10924"
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
    assert_match "actualis 0.4.0", shell_output("#{bin}/actualis --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
