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
    # - fix Feel++ version
    DATA
  end


  def install
    # Remove the default CMAKE_BUILD_TYPE set through std_cmake_args
    # So we can avoid setting None as a build type
    args=std_cmake_args
    args.delete_if {|x| x =~ /CMAKE_BUILD_TYPE/}

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

__END__
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
