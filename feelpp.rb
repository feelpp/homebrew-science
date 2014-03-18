require 'formula'

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.97.3/feelpp-0.97.3-final.tar.gz'
  version '0.97.3-final'
  sha1 '046f1b80fb1981619de434ae08d080fb44cbbe8e'

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
