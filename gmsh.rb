# -*- mode: ruby -*-
require 'formula'

class Gmsh < Formula
  homepage 'http://geuz.org/gmsh'
  url 'http://geuz.org/gmsh/src/gmsh-2.8.3-source.tgz'
  sha1 'd6308e415539f7f69bdf3dfe151dc0f1f64a3264'

  depends_on 'cmake' => :build
  depends_on 'fltk' => :build
  depends_on 'petsc' => :build
  depends_on 'texinfo' => :build

  def patches
    DATA
  end

  def install
    ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3"
    ENV['PETSC_ARCH']="darwin-cxx-opt"
    args=std_cmake_args+["-DCMAKE_BUILD_TYPE=Release",
                         "-DENABLE_OS_SPECIFIC_INSTALL=OFF",
                         "-DENABLE_BUILD_LIB=OFF",
                         "-DENABLE_BUILD_SHARED=ON",
                         "-DENABLE_NATIVE_FILE_CHOOSER:BOOL=OFF",
                         "-DENABLE_OCC:BOOL=OFF",
                         "-DENABLE_FLTK:BOOL=ON",
                         "-DENABLE_MPI:BOOL=ON",
                         "-DENABLE_GRAPHICS:BOOL=ON",
                         "-DENABLE_METIS=ON",
                         "-DENABLE_TAUCS=OFF"]

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

__END__
diff --git a/Fltk/Main.cpp b/Fltk/Main.cpp
index 3134222..5e1d2c0 100644
--- a/Fltk/Main.cpp
+++ b/Fltk/Main.cpp
@@ -2,7 +2,7 @@
 //
 // See the LICENSE.txt file for license information. Please report all
 // bugs and problems to the public mailing list <gmsh@geuz.org>.
-
+#include <cstdlib>
 #include <string>
 #include "Gmsh.h"
 #include "GmshMessage.h"
