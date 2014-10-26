require 'formula'

class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.12.tar.gz"
  sha1 "2bdedca65e29186d1ecaaed45cb6c9b1f3f1c868"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  depends_on :fortran

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  bottle do
    root_url 'http://feelpp-bottles.u-strasbg.fr/'
    sha1 "d82f943ea18583a864e39178ad2ce329d30415f5" => :mavericks
  end

  def install
    # Must call in two steps
    system "make", "FC=#{ENV['FC']}", "libs", "netlib", "shared"
    system "make", "FC=#{ENV['FC']}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
