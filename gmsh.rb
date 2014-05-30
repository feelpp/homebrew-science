# -*- mode: ruby -*-
require 'formula'

class Gmsh < Formula
  homepage 'http://geuz.org/gmsh'
  url 'http://geuz.org/gmsh/src/gmsh-2.8.4-source.tgz'
  sha1 'e96209c46874cb278e2028933871c7e7d60e662d'

  open 'with-X', 'build gmsh with X support'
  
  depends_on 'cmake' => :build
  
  if build.with? 'X'
    depends_on 'libpng' => :build
    depends_on 'jpeg' => :build
    depends_on 'fltk' => :build
    depends_on 'texinfo' => :build
    depends_on 'cairo' => :build
  else

  #  env :std

#  def patches
#    DATA
#  end

  def install
#    ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt"
#    ENV['SLEPC_DIR']="/usr/local/lib/slepcdir/3.4.3/darwin-cxx-opt"
    if build.with? 'X'
    args=std_cmake_args+["-DCMAKE_BUILD_TYPE=Release",
                         "-DENABLE_OS_SPECIFIC_INSTALL=OFF",
                         "-DENABLE_BUILD_LIB=OFF",
                         "-DENABLE_BUILD_SHARED=ON",
                         "-DENABLE_NATIVE_FILE_CHOOSER:BOOL=OFF",
                         "-DENABLE_OCC:BOOL=OFF",
                         "-DENABLE_FLTK:BOOL=ON",
#                         "-DENABLE_MPI:BOOL=ON",
#                         "-DENABLE_SLEPC:BOOL=ON",
                         "-DENABLE_GRAPHICS:BOOL=ON",
                         "-DENABLE_METIS=ON",
                         "-DENABLE_TAUCS=OFF"]
  else
    args=std_cmake_args+["-DCMAKE_BUILD_TYPE=Release",
                         "-DENABLE_OS_SPECIFIC_INSTALL=OFF",
                         "-DENABLE_BUILD_LIB=OFF",
                         "-DENABLE_BUILD_SHARED=ON",
                         "-DENABLE_NATIVE_FILE_CHOOSER:BOOL=OFF",
                         "-DENABLE_OCC:BOOL=OFF",
                         "-DENABLE_METIS=ON",
                         "-DENABLE_TAUCS=OFF"]
    end
    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test gmsh`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "false"
  end
end
