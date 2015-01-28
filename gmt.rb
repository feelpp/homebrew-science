require "formula"

class Gmt < Formula
  homepage "http://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://ftp.iris.washington.edu/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://ftp.iag.usp.br/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://ftp.scc.u-tokai.ac.jp/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://gmt.mirror.ac.za/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://ftp.geologi.uio.no/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  mirror "ftp://gd.tuwien.ac.at/pub/gmt/legacy/gmt-5.1.1-src.tar.bz2"
  sha1 "ff64936dfdec8a57a89d29f505f27e435169d33f"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "82835826607bbb20641a48eb427338f30504b49f" => :yosemite
    sha1 "9c6b2ba6289adbaf8ee28d204afc561553e7a650" => :mavericks
    sha1 "2adadc07e198685629bbc7a6672e3c95a3279532" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "fftw"
  depends_on "pcre"

  conflicts_with "gmt4", :because => "both versions install the same binaries"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.iris.washington.edu/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.iag.usp.br/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.scc.u-tokai.ac.jp/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://gmt.mirror.ac.za/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://ftp.geologi.uio.no/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/gshhg-gmt-2.3.4.tar.gz"
    sha1 "dc989e96a88533e7d44b788d1be8e0d7620f56d4"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://ftp.iris.washington.edu/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://ftp.iag.usp.br/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://ftp.scc.u-tokai.ac.jp/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://gmt.mirror.ac.za/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://ftp.geologi.uio.no/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    mirror "ftp://gd.tuwien.ac.at/pub/gmt/legacy/dcw-gmt-1.1.1.tar.gz"
    sha1 "deca85f21426604c8574a18d16c931a1fd9ae27b"
  end

  def install
    gshhgdir = buildpath/"gshhg"
    dcwdir = buildpath/"dcw"

    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=TRUE
      -DGMT_DOCDIR=#{share}/doc/gmt
      -DGMT_MANDIR=#{man}
      -DGSHHG_ROOT=#{gshhgdir}
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{dcwdir}
      -DCOPY_DCW:BOOL=TRUE
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DLICENSE_RESTRICTED:BOOL=FALSE
      -DFLOCK:BOOL=TRUE
    ]

    mkdir "build" do
      gshhgdir.install resource("gshhg")
      dcwdir.install resource("dcw")
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
      GMT 5 is mostly (but not 100%) compatible with previous versions.
      Moreover, the compatibility mode is expected to exist only during a
      transitional period.

      If you want to continue using GMT 4:
      `brew install gmt4`

      We agreed to the `triangle` license
      (http://www.cs.cmu.edu/~quake/triangle.html) for you.
      If this is unacceptable you should uninstall.
    EOS
  end
end
