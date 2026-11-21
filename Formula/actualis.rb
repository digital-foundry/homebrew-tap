class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/7e/96/d4db81b53302cf1f94f23ab89b7906b097a4ee427ea1fca8cb8ae858fd84/actualis-0.8.0.tar.gz"
  sha256 "882015ec00dccd6b631b4ba2af029d98fa11c1325d8f3a8969b36c95a4aec742"
  license "AGPL-3.0-or-later"

  # Standard library only, so there are no resources to vendor: the formula
  # installs two files and a wrapper for each, run with brew's Python.
  depends_on "python@3.13"

  def install
    libexec.install "actualis.py", "actualis_reputation.py"
    (bin/"actualis").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("python@3.13")}/python3.13" "#{libexec}/actualis.py" "$@"
    SH
    (bin/"actualis-reputation").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("python@3.13")}/python3.13" "#{libexec}/actualis_reputation.py" "$@"
    SH
  end

  test do
    assert_match "actualis 0.8.0", shell_output("#{bin}/actualis --version")
    assert_match "actualis-reputation 0.8.0", shell_output("#{bin}/actualis-reputation --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
