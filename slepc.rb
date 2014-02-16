require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc/'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.4.3.tar.gz'
  sha1 '60ed95114f9b16e1214f583921ee0afb2943e1c3'

  depends_on 'petsc' => :build
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11  => MacOS::X11.installed? ? :recommended : :optional

  env :std

  option 'enable-opt', 'Compile optimized petsc version'
  option 'without-debug', 'Disable building debug flavor'

  def install
    ENV.deparallelize

    args=["--download-blopex"]

    if not build.without? 'debug'
      ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug"
      system "./configure","--prefix=#{prefix}/lib/slepcdir/3.4.3/darwin-cxx-debug",*args
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc"
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "test"
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
      rm_rf Dir['arch-installed-petsc']
    end

    if build.include? 'enable-opt'
      ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt"
      system "./configure","--prefix=#{prefix}/lib/slepcdir/3.4.3/darwin-cxx-opt",*args
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc"
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "test"
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
    end
  end

end
