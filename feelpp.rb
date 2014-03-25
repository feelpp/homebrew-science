require 'formula'

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.97.4/feelpp-0.97.4-final.tar.gz'
  version '0.97.4-final'
  sha1 '9de18d3d76ffbf06686e24704d4b5772835c5fe4'

  depends_on 'cmake' => :build
  depends_on 'eigen'
  depends_on 'gmsh'
  depends_on 'petsc'
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
