require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc/'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.4.3.tar.gz'
  sha1 '60ed95114f9b16e1214f583921ee0afb2943e1c3'

  depends_on 'petsc' => :build
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
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
      system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test download.php?filename=slepc`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "false"
  end
end
