require 'formula'

# We remove the use of submodules as it makes the checkout step
# fails if we don't have access to them
class GitNoSubmoduleDownloadStrategy < GitDownloadStrategy
      def submodules?; false; end
end

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.98.0/feelpp-0.98.0-final.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :using => GitNoSubmoduleDownloadStrategy
  version '0.98.0-final'
  sha1 'b711b585b4fbd3ee9271cc6a5711b4126dd19cd4'

  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'libtool'
  depends_on 'cmake' => :build
  depends_on 'cln'
  depends_on 'eigen'
  depends_on 'gmsh' => :recommended #feel++ can download and install it
  depends_on 'scalapack' => ['without-check']
  depends_on 'petsc' => ['enable-ml']
  depends_on 'slepc' => :recommended
  depends_on 'boost' => ['with-python', 'without-single', 'without-static', 'with-mpi', 'c++11']
  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended
  depends_on 'doxygen' => :optional

  def install
    args=std_cmake_args

    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "..", *args
      system "make", "quickstart"
      system "make", "install"
    end
  end

  test do
    system "make", "check"
  end
end
