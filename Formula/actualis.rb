class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/6e/37/a49e56a70ff6b7002135a82b320367e2d29561f027077852fb21e39752dd/actualis-0.2.2.tar.gz"
  sha256 "1925d33019e4de3840a278d44dbd8037e10d1a2f3e7c9b8d22c30ac8f07ccbbf"
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
    assert_match "actualis 0.2.2", shell_output("#{bin}/actualis --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
