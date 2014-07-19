require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Paraview < Formula
  homepage "http://www.paraview.org"
  url "https://github.com/Kitware/ParaView/archive/v4.1.0.tar.gz"
  sha1 ""

  depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on qt
  depends_on python

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    args = std_cmake_args + ["-Wno-dev",
                             "-DCMAKE_INSTALL_RPATH=#{lib}/paraview",
                             "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF",
                             "-DCMAKE_SKIP_RPATH=OFF",
                             "-DBUILD_SHARED_LIBS=ON",
                             "-DVTK_USE_SYSTEM_FREETYPE=ON",
                             "-DVTK_USE_SYSTEM_JPEG=ON",
                             "-DVTK_USE_SYSTEM_JSONCPP=ON",
                             "-DVTK_USE_SYSTEM_PNG=ON",
                             "-DBUILD_TESTING=OFF",
                             "-DVTK_USE_MPEG2_ENCODER=OFF",
                             "-DVTK_USE_FFMPEG_ENCODER=ON",
                             "-DPARAVIEW_ENABLE_FFMPEG=ON",
                             "-DPARAVIEW_ENABLE_WEB=OFF",
                             "-DVTK_USE_OGGTHEORA_ENCODER=ON",
                             "-DVTK_USE_SYSTEM_OGGTHEORA=ON",
                             "-DVTK_INSTALL_LIBRARY_DIR=#{lib}/paraview", 
                             "-DVTK_INSTALL_ARCHIVE_DIR=#{lib}/paraview",
                             "-DVTK_INSTALL_INCLUDE_DIR=#{include}/paraview",
                             "-DVTK_INSTALL_DATA_DIR=#{share}/paraview",
                             "-DVTK_INSTALL_DOC_DIR=#{doc}/paraview",
                             "-DVTK_INSTALL_PACKAGE_DIR=#{lib}/cmake/paraview",
                             "-DVTK_CUSTOM_LIBRARY_SUFFIX=\"\"",
                             "-DVTK_USE_SYSTEM_TIFF=ON",
                             "-DVTK_USE_SYSTEM_ZLIB=ON",
                             "-DBUILD_EXAMPLES=OFF",
                             "-DVTK_USE_SYSTEM_LIBXML2=ON",
                             "-DVTK_USE_SYSTEM_EXPAT=ON",
                             "-DDOCUMENTATION_HTML_HELP=ON",
                             "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON",
                             "-DBUILD_DOCUMENTATION=ON",
                             "-DPARAVIEW_USE_MPI=ON",
                             "-DMPI_INCLUDE_PATH=#{include}/mpi",
                             "-DVTK_USE_SYSTEM_HDF5=ON",
                             "-DPARAVIEW_ENABLE_PYTHON=ON",
                             "-DPARAVIEW_BUILD_PLUGIN_AdiosReader:BOOL=ON",
                             "-DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON",
                             "-DEigen_DIR=#{include}/eigen3"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ParaView`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
