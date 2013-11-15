require 'formula'

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/archive/v0.96.0-beta.2.tar.gz'
  version '0.96.0-beta.2'
  sha1 '7a768de379d0b2aa2593510889c75dfd7be0e843'

  depends_on 'cmake' => :build
  depends_on 'gmsh'
  depends_on 'petsc'
  depends_on 'boost' => ['without-python', 'without-single', 'without-static', 'with-mpi', 'c++11']
  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended

  def install
    args=std_cmake_args
    # Remove the default CMAKE_BUILD_TYPE set through std_cmake_args
    # So we can avoid setting None as a build type
    #args.delete_if {|x| x =~ /CMAKE_BUILD_TYPE/}

    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/feelpp_qs_laplacian", "--version"
  end
end
