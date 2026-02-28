class SapBotOrchestrator < Formula
  desc "Bot orchestrator with SAP AI Core provider support"
  homepage "https://github.com/ausardcompany/sap-bot-orchestrator"
  url "https://github.com/ausardcompany/sap-bot-orchestrator.git",
      tag:      "v0.1.0",
      revision: ""
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

    # Create wrapper script
    (bin/"sap-bot").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@22"].opt_bin}/node" "#{libexec}/dist/cli/program.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      sap-bot-orchestrator requires SAP AI Core credentials.
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
    assert_match "SAP AI Core bot orchestrator", shell_output("#{bin}/sap-bot --help")
  end
end
