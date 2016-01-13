class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.17.0/nextflow"
  version "0.17.0"
  sha256 "c07827502d8b14a9eb0a84aedc98063d9becf0223d56ea68e5692402f0d3ca19"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2aaa7aefc0338ccc1cbf672681d0ffc041baa9de4fdd786b11915f2ceb6fd9e5" => :el_capitan
    sha256 "495f741f28fe7a5bd91090f9b00c9b2d7ea61ee95d564db82d6d3704ac849930" => :yosemite
    sha256 "54d056dd15849c5b6083750726c8fe4b1b2a1fd2e3a47049a738a2093b568e70" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system "#{bin}/nextflow", "-download"
    system "echo", "println \'hello\' | #{bin}/nextflow -q run - |grep hello"
  end
end
