class OtelcolSumo < Formula
  desc "Sumo Logic Distribution for OpenTelemetry Collector"
  homepage "https://github.com/SumoLogic/sumologic-otel-collector"
  url "https://github.com/SumoLogic/sumologic-otel-collector/archive/refs/tags/v0.57.2-sumo-1.tar.gz"
  sha256 "3499ae08577c1fd9b15fe6340198fa7d6f91015d733f8eb1e40d38d44c6fac7d"
  license "Apache-2.0"

  head do
    url "https://github.com/SumoLogic/sumologic-otel-collector.git", branch: "main"
  end

  depends_on "go@1.18" => :build
  depends_on "ocb-sumo" => :build

  def install
    # Enable CGO to use the macOS DNS resolver rather than Go's DNS resolver.
    ENV["CGO_ENABLED"] = "1"

    chdir "otelcolbuilder" do
      system "make", "build"

      chdir "cmd" do
        bin.install "otelcol-sumo"
      end
    end
  end

  test do
    system "#{bin}/otelcol-sumo -v"
  end
end
