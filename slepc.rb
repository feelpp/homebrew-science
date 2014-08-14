require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc/'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.4.4.tar.gz'
  sha1 'd7c09f3e2bb8910758e488e84c16a6eb266cf379'

  depends_on 'petsc' => :build
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11  => MacOS::X11.installed? ? :recommended : :optional

  env :std

  option 'enable-opt', 'Compile optimized petsc version'
  option 'without-debug', 'Disable building debug flavor'
  # Trick SLEPc into thinking we don't have a prefix install of PETSc.
  #patch :DATA

  def install
    ENV.deparallelize

    args=["--download-blopex"]

    petsc_arch = 'arch-darwin-cxx-debug'
    petsc_dir = Formula["petsc"].prefix
    ENV['SLEPC_DIR'] = Dir.getwd

    ENV['PETSC_ARCH'] = ""
    ENV['PETSC_DIR'] = "#{petsc_dir}/#{petsc_arch}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch}",*args
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} PETSC_ARCH=arch-installed-petsc"
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} PETSC_ARCH=arch-installed-petsc install"

    #ENV['PETSC_DIR'] = Formula["petsc"].opt_prefix
    #ENV['PETSC_ARCH'] = petsc_arch
    #system "./configure", "--prefix=#{prefix}/#{petsc_arch}"
    #system "make PETSC_ARCH=#{petsc_arch}"
    # system "make PETSC_ARCH=#{petsc_arch} install"
    # ENV['PETSC_ARCH'] = ''
    # system "make SLEPC_DIR=#{prefix}/#{petsc_arch} test"
    # ohai 'Test results are in ~/Library/Logs/Homebrew/slepc. Please check.'

    # # Link what we need.
    # include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"], "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    # lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    # prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    # doc.install 'docs/slepc.pdf', Dir["docs/*.htm"], 'docs/manualpages'  # They're not really man pages.
    # share.install 'share/slepc/datafiles'
  end


end
