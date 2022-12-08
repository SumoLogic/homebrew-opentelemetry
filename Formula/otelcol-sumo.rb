class OtelcolSumo < Formula
  desc "Sumo Logic Distribution for OpenTelemetry Collector"
  homepage "https://github.com/SumoLogic/sumologic-otel-collector"
  license "Apache-2.0"

  stable do
    version "0.66.0-sumo-0"
    url "https://github.com/SumoLogic/sumologic-otel-collector/archive/refs/tags/v#{version}.tar.gz"
    sha256 "d4b68fe90556c7961317b0662cb51c68ec98db45d995a8c5e63f3e0b6673b61c"
  end

  head do
    url "https://github.com/SumoLogic/sumologic-otel-collector.git", branch: "main"
  end

  livecheck do
    url "https://github.com/SumoLogic/sumologic-otel-collector/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+-sumo-\d+)["' >]}i)
  end

  depends_on "go" => :build
  depends_on "ocb-sumo" => :build

  def install
    # Enable CGO to use the macOS DNS resolver rather than Go's DNS resolver.
    ENV["CGO_ENABLED"] = "1"

    chdir "otelcolbuilder" do
      system "make", "build", "VERSION=version"

      chdir "cmd" do
        bin.install "otelcol-sumo"
      end
    end
  end

  test do
    system "#{bin}/otelcol-sumo -v"
  end
end
