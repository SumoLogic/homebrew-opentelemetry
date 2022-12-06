class OcbSumo < Formula
  desc "OpenTelemetry Collector Builder"
  homepage "https://github.com/open-telemetry/opentelemetry-collector"
  url "https://github.com/open-telemetry/opentelemetry-collector/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "d301ee65d224e3567bfa6eef3c18c22a54438093335c2f55e89fe97e63a6fffb"
  license "Apache-2.0"

  head do
    url "https://github.com/open-telemetry/opentelemetry-collector.git", branch: "main"
  end

  depends_on "go@1.18" => :build

  def install
    build_ts = Time.now().strftime("%Y-%m-%d_%H:%M:%S")
    ldflags = "-s -w"
    ldflags << " -X go.opentelemetry.io/collector/cmd/builder/internal.version=#{version}"
    ldflags << " -X go.opentelemetry.io/collector/cmd/builder/internal.date=#{build_ts}"

    chdir "cmd/builder" do 
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"opentelemetry-collector-builder"), "."
    end
  end

  test do
    system "#{bin}/opentelemetry-collector-builder version"
  end
end
