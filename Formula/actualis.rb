class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/2d/6f/054e3e6a861fb8eaf15fbcd4cff30651da742a1c5cdbc81ea2ca1f232780/actualis-0.5.1.tar.gz"
  sha256 "55516f95aadced972911834506f260ca063bf4cc8113cd55a6d0fabe088dd7f3"
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
    assert_match "actualis 0.5.1", shell_output("#{bin}/actualis --version")
    assert_match "actualis-reputation 0.5.1", shell_output("#{bin}/actualis-reputation --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
