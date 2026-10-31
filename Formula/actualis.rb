class Actualis < Formula
  desc "What actually ran: local, read-only audit of coding-agent transcripts"
  homepage "https://actualis.app"
  url "https://files.pythonhosted.org/packages/55/93/b15202f008813426fbedcddbac19f2c7f2299697ce16c183c94a11310b8b/actualis-0.5.0.tar.gz"
  sha256 "f9294e2b2be0e9dc77fff6985ccec963b1e36d4743b608217428e29d25cd17df"
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
    assert_match "actualis 0.5.0", shell_output("#{bin}/actualis --version")
    assert_match "actualis-reputation 0.5.0", shell_output("#{bin}/actualis-reputation --version")
    # A fresh HOME has no transcripts: it must say so and exit 1, not crash.
    ENV["HOME"] = testpath
    assert_match "no agent transcripts found", shell_output("#{bin}/actualis 2>&1", 1)
  end
end
