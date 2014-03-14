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

    petsc_arch = 'arch-darwin-c-opt'
    ENV['SLEPC_DIR'] = Dir.getwd
    ENV['PETSC_DIR'] = Formula["petsc"].prefix
    ENV['PETSC_ARCH'] = petsc_arch
    system "./configure", "--prefix=#{prefix}/#{petsc_arch}",*args
    system "make PETSC_ARCH=#{petsc_arch}"
    system "make PETSC_ARCH=#{petsc_arch} install"
    ENV['PETSC_ARCH'] = ''
    system "make SLEPC_DIR=#{prefix}/#{petsc_arch} test"
    ohai 'Test results are in ~/Library/Logs/Homebrew/slepc. Please check.'

    # Link what we need.
    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"], "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install 'docs/slepc.pdf', Dir["docs/*.htm"], 'docs/manualpages'  # They're not really man pages.
    share.install 'share/slepc/datafiles'
  end


  #   if not build.without? 'debug'
  #     ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug"
  #     system "./configure","--prefix=#{prefix}/lib/slepcdir/3.4.3/darwin-cxx-debug",*args
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc"
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "test"
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-debug","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
  #     rm_rf Dir['arch-installed-petsc']
  #   end

  #   if build.include? 'enable-opt'
  #     ENV['PETSC_DIR']="/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt"
  #     system "./configure","--prefix=#{prefix}/lib/slepcdir/3.4.3/darwin-cxx-opt",*args
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc"
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "test"
  #     system "make", "PETSC_DIR=/usr/local/lib/petscdir/3.4.3/darwin-cxx-opt","SLEPC_DIR=#{Dir.pwd}", "PETSC_ARCH=arch-installed-petsc", "install"
  #   end
  # end

end
