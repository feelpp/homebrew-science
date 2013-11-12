require 'formula'

class Feelpp < Formula
  homepage 'http://www.feelpp.org'
  url 'https://github.com/feelpp/feelpp/archive/v0.96.0-beta.1.tar.gz'
  version '0.96.0-beta.1'
  sha1 '231f625f0ede11001d586d186fbe172878f13cf3'

  depends_on 'cmake' => :build
  depends_on 'gmsh'
  depends_on 'petsc'
  depends_on 'boost' => ['without-python', 'without-single', 'without-static', 'with-mpi', 'c++11']
  depends_on 'ann' => :recommended
  depends_on 'glpk' => :recommended

  def patches
    # bugs in cmakelists
    # - support CMAKE_BUILD_TYPE=None
    # - fix Feel++ version
    DATA
  end


  def install
    Dir.mkdir 'opt'
    cd 'opt' do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/feelpp_qs_laplacian", "--version"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index fce2fc2..fb7873c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -47,8 +47,9 @@ endif()
 string(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type_tolower)
 if(    NOT cmake_build_type_tolower STREQUAL "debug"
     AND NOT cmake_build_type_tolower STREQUAL "release"
+    AND NOT cmake_build_type_tolower STREQUAL "none"
     AND NOT cmake_build_type_tolower STREQUAL "relwithdebinfo")
-  message(FATAL_ERROR "Unknown build type \"${CMAKE_BUILD_TYPE}\". Allowed values are Debug, Release, RelWithDebInfo (case-insensitive).")
+  message(FATAL_ERROR "Unknown build type \"${CMAKE_BUILD_TYPE}\". Allowed values are None, Debug, Release, RelWithDebInfo (case-insensitive).")
 endif()


diff --git a/cmake/modules/feelpp.version.cmake b/cmake/modules/feelpp.version.cmake
index f00588f..f47b30f 100644
--- a/cmake/modules/feelpp.version.cmake
+++ b/cmake/modules/feelpp.version.cmake
@@ -62,7 +62,7 @@ set(FEELPP_VERSION_MINOR "96")
 set(FEELPP_VERSION_MICRO "0")
 set(FEELPP_REVISION "0" )
 set(FEELPP_BUILDID "0" )
-set(FEELPP_VERSION_PRERELEASE "-alpha.1" )
+set(FEELPP_VERSION_PRERELEASE "-beta.1" )
 if (FEELPP_ENABLE_GIT AND GIT_FOUND AND  EXISTS ${PROJECT_SOURCE_DIR}/.git )
   set(FEELPP_VERSION_METADATA "+${FEELPP_SCM}${Project_WC_REVISION}")
   set(FEELPP_REVISION "${Project_WC_REVISION}")
