class Alexi < Formula
  desc "Intelligent LLM orchestrator with SAP AI Core provider support"
  homepage "https://github.com/ausardcompany/alexi"
  url "https://github.com/ausardcompany/alexi.git",
      tag:      "v0.2.4",
      revision: "aaf716256edc75bd7e8cb86ceb5fcbd90a10927e"
  license "ISC"
  head "https://github.com/ausardcompany/alexi.git", branch: "master"

  depends_on "node@22"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    libexec.install Dir["*"]

    (bin/"alexi").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@22"].opt_bin}/node" "#{libexec}/dist/cli/program.js" "$@"
    EOS

    (bin/"ax").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@22"].opt_bin}/node" "#{libexec}/dist/cli/program.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Alexi requires SAP AI Core credentials.
      Set the following environment variables:
        - AICORE_SERVICE_KEY (JSON service key) or individual credentials:
        - AICORE_CLIENT_ID
        - AICORE_CLIENT_SECRET
        - AICORE_AUTH_URL
        - AICORE_BASE_URL
        - AICORE_RESOURCE_GROUP
    EOS
  end

  test do
    assert_match "alexi", shell_output("#{bin}/alexi --version")
  end
end