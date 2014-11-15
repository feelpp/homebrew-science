require "formula"

class Paraview < Formula
  homepage "http://paraview.org"
  url "http://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v4.2&type=source&os=all&downloadFile=ParaView-v4.2.0-source.tar.gz"
  sha1 "a440ba9912549bdd23a949e22add41696715dd32"
  head "git://paraview.org/ParaView.git"

  depends_on "cmake" => :build

  depends_on "boost" => :recommended
  depends_on "cgns" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "qt" => :recommended
  depends_on :mpi => [:cc, :cxx, :optional]
  depends_on :python => :recommended

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on :fontconfig
  depends_on :libpng

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DMACOSX_APP_INSTALL_PREFIX:PATH=#{prefix}
      -DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=OFF
      -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
      -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
      -DVTK_USE_SYSTEM_HDF5:BOOL=ON
      -DVTK_USE_SYSTEM_JPEG:BOOL=ON
      -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
      -DVTK_USE_SYSTEM_PNG:BOOL=ON
      -DVTK_USE_SYSTEM_TIFF:BOOL=ON
      -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
    ]

    args << "-DPARAVIEW_BUILD_QT_GUI:BOOL=OFF" if build.without? "qt"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "mpi"
    args << "-DPARAVIEW_ENABLE_FFMPEG:BOOL=ON" if build.with? "ffmpeg"
    args << "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON" if build.with? "boost"
    args << "-DVISIT_BUILD_READER_CGNS:BOOL=ON" if build.with? "cgns"

    mkdir "build" do
      if build.with? "python"
        args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
        # CMake picks up the system"s python dylib, even if we have a brewed one.
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      else
        args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=OFF"
      end
      args << ".."

      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{prefix}/paraview.app/Contents/MacOS/paraview", "--version"
  end
end


# require 'formula'

# class Paraview < Formula
#   homepage 'http://www.paraview.org'
#   url 'http://github.com/Kitware/ParaView/archive/v4.1.0.tar.gz'
#   sha1 '3eed7d6e2a60a09f5f9464dea7bec8c05a8c2bb3'

#   depends_on 'cmake' => :build
#   depends_on 'qt'
#   depends_on 'python'
#   depends_on 'vtk'

#   def install
#     # ENV.deparallelize  # if your formula fails when building in parallel
#     args = std_cmake_args + ['-Wno-dev',
#                              '-DCMAKE_INSTALL_RPATH=#{lib}/paraview',
#                              '-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF',
#                              '-DCMAKE_SKIP_RPATH=OFF',
#                              '-DBUILD_SHARED_LIBS=ON',
#                              '-DVTK_USE_SYSTEM_FREETYPE=ON',
#                              '-DVTK_USE_SYSTEM_JPEG=ON',
#                              '-DVTK_USE_SYSTEM_JSONCPP=ON',
#                              '-DVTK_USE_SYSTEM_PNG=ON',
#                              '-DBUILD_TESTING=OFF',
#                              '-DVTK_USE_MPEG2_ENCODER=OFF',
#                              '-DVTK_USE_FFMPEG_ENCODER=ON',
#                              '-DPARAVIEW_ENABLE_FFMPEG=ON',
#                              '-DPARAVIEW_ENABLE_WEB=OFF',
#                              '-DPARAVIEW_ENABLE_CATALYST=ON',
#                              '-DVTK_USE_OGGTHEORA_ENCODER=ON',
#                              '-DVTK_USE_SYSTEM_OGGTHEORA=ON',
#                              '-DUSE_EXTERNAL_VTK:BOOL=ON',
#                              '-DVTK_INSTALL_LIBRARY_DIR=#{lib}/paraview', 
#                              '-DVTK_INSTALL_ARCHIVE_DIR=#{lib}/paraview',
#                              '-DVTK_INSTALL_INCLUDE_DIR=#{include}/paraview',
#                              '-DVTK_INSTALL_DATA_DIR=#{share}/paraview',
#                              '-DVTK_INSTALL_DOC_DIR=#{doc}/paraview',
#                              '-DVTK_INSTALL_PACKAGE_DIR=#{lib}/cmake/paraview',
#                              '-DVTK_CUSTOM_LIBRARY_SUFFIX=""',
#                              '-DVTK_USE_SYSTEM_TIFF=ON',
#                              '-DVTK_USE_SYSTEM_ZLIB=ON',
#                              '-DBUILD_EXAMPLES=OFF',
#                              '-DVTK_USE_SYSTEM_LIBXML2=ON',
#                              '-DVTK_USE_SYSTEM_EXPAT=ON',
#                              '-DDOCUMENTATION_HTML_HELP=ON',
#                              '-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON',
#                              '-DBUILD_DOCUMENTATION=ON',
#                              '-DPARAVIEW_USE_MPI=ON',
#                              '-DMPI_INCLUDE_PATH=#{include}/mpi',
#                              '-DVTK_USE_SYSTEM_HDF5=ON',
#                              '-DPARAVIEW_ENABLE_PYTHON=ON',
#                              '-DPARAVIEW_BUILD_PLUGIN_AdiosReader:BOOL=ON',
#                              '-DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting:BOOL=ON',
#                              '-DEigen_DIR=#{include}/eigen3']

#     mkdir 'build' do
#       system 'cmake', '..', *args
#       system 'make'
#       system 'make', 'install'
#     end

#   end

#   test do
#     # `test do` will create, run in and delete a temporary directory.
#     #
#     # This test will fail and we won't accept that! It's enough to just replace
#     # 'false' with the main program this formula installs, but it'd be nice if you
#     # were more thorough. Run the test with `brew test ParaView`. Options passed
#     # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
#     #
#     # The installed folder is not in the path, so use the entire path to any
#     # executables being tested: `system '#{bin}/program', 'do', 'something'`.
#     system 'false'

