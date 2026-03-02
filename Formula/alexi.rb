class Alexi < Formula
  desc "Intelligent LLM orchestrator with SAP AI Core provider support"
  homepage "https://github.com/ausardcompany/sap-bot-orchestrator"
  url "https://github.com/ausardcompany/sap-bot-orchestrator.git",
      tag:      "v0.1.5",
      revision: "090cfdfaa50fab34a3b6f01002c84ec0fb4779f8"
  license "ISC"
  head "https://github.com/ausardcompany/sap-bot-orchestrator.git", branch: "master"

  depends_on "node@22"

  def install
    # Install npm dependencies
    system "npm", "install", *std_npm_args(prefix: false)
    # Build TypeScript
    system "npm", "run", "build"

    # Install to libexec
    libexec.install Dir["*"]

    # Create wrapper scripts
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
