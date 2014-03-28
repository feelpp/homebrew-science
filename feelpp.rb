require 'formula'

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/releases/download/v0.98.0-beta.1/feelpp-0.98.0-beta.1.tar.gz'
  version '0.98.0-beta.1'
  sha1 '697a19eaa1728c69edee618e625fcb5094ad8b1d'

  depends_on 'cmake' => :build
  depends_on 'cln'
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
