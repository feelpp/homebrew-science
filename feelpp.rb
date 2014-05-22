require 'formula'

# We remove the use of submodules as it makes the checkout step
# fails if we don't have access to them
class GitNoSubmoduleDownloadStrategy < GitDownloadStrategy
      def submodules?; false; end
end

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.98.0-final/feelpp-0.98.0-final.tar.gz'
  head 'https://github.com/feelpp/feelpp.git', :using => GitNoSubmoduleDownloadStrategy
  version '0.98.0-final'
  sha1 '9cf3526af79b9f2536c848606df8ef336e18521f'

  depends_on 'cmake' => :build
  depends_on 'cln'
  depends_on 'eigen'
  depends_on 'gmsh'
  depends_on 'scalapack' => ['without-check']
  depends_on 'petsc'
  depends_on 'slepc'
  depends_on 'boost' => ['without-python', 'without-single', 'without-static', 'with-mpi', 'c++11']
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
