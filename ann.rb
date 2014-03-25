require 'formula'

class Ann < Formula
  homepage 'http://www.cs.umd.edu/~mount/ANN/'
  url 'http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.tar.gz'
  sha1 '27ec04d55e244380ade3706a9b71c3d631e2ff1a'

  def install
    # Fix for Mavericks make error
    inreplace 'ann2fig/ann2fig.cpp', 'main', 'int main' if MacOS.version >= :mavericks

    system "make", "macosx-g++"
    prefix.install "bin", "lib", "sample", "doc", "include"
  end

  def test
    cd "#{prefix}/sample" do
      system "#{bin}/ann_sample", "-df", "data.pts", "-qf", "query.pts"
    end
  end
end
