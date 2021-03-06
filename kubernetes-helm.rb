class KubernetesHelm < Formula
  desc "The package manager for Kubernetes"
  homepage "https://helm.sh"
  url "https://github.com/helm/helm/archive/0.6.0.tar.gz"
  sha256 "6582f095af305504132c45fba28548b0bb49da51d2f7ac20a89a324606719ed1"

  depends_on :hg
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p buildpath/"src/github.com/helm/"
    ln_sf buildpath, buildpath/"src/github.com/helm/helm"

    cd "src/github.com/helm/helm" do
      system "make", "bootstrap"
      system "make", "build", "VERSION=#{version}"
      bin.install "bin/helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory?("#{testpath}/.helm/workspace/charts/foo")
  end
end
