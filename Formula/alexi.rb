class Alexi < Formula
  desc "Intelligent LLM orchestrator with SAP AI Core provider support"
  homepage "https://github.com/ausardcompany/alexi"
  url "https://github.com/ausardcompany/alexi.git",
      tag:      "v1.17.12",
      revision: "4949be369d8e64a2e4d7bc85533bc7bf416f5a67"
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
