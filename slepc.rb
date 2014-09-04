require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc/'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.5.0.tar.gz'
  sha1 'c316e668e404396e8944c9bcea804f50e6f82c80'

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

    petsc_dir = Formula["petsc"].prefix
    ENV['SLEPC_DIR'] = Dir.getwd

    ENV['PETSC_ARCH'] = ""

    petsc_arch = 'arch-darwin-cxx-debug'
    ENV['PETSC_DIR'] = "#{petsc_dir}/#{petsc_arch}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch}",*args
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} "
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} install"

    petsc_arch = 'arch-darwin-cxx-opt'
    ENV['PETSC_DIR'] = "#{petsc_dir}/#{petsc_arch}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch}",*args
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} "
    system "make SLEPC_DIR=$PWD PETSC_DIR=#{petsc_dir}/#{petsc_arch} install"

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
