require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.1.tar.gz'
  sha1 '487d012ca83de458ce104f6d812e8cca2de4b55e'
  head 'https://bitbucket.org/petsc/petsc', :using => :git

  # do not use superenv
  env :std

  option 'enable-ptscotch', 'Compile with scotch support'
  option 'enable-metis', 'Compile with metis support'
  option 'enable-mumps', 'Compile with mumps support'
  option 'enable-ml', 'Compile with ml support'
  option 'enable-blas', 'Compile with blas support'
  option 'enable-mkl', 'Compile with MKL support'
  option 'enable-scalapack', 'Compile with scalapack support'
  option 'without-check', 'Skip build-time tests (not recommended)'
  option 'without-debug', 'Disable building debug flavor'
  option 'without-opt', 'Disable building opt flavor'

  depends_on :mpi => [:cc, :fortran, :cxx]
  depends_on 'hdf5' => [:recommended, 'enable-parallel']
  depends_on 'cmake' => :build

  depends_on :mpi => :cc
  depends_on :fortran
  #depends_on 'metis' => :recommended
  #depends_on 'parmetis' => :recommended
  depends_on 'scotch5' => :recommended
  depends_on 'mumps' => [:recommended, 'with-scotch5']
  depends_on 'suite-sparse' => :recommended
  depends_on 'scalapack' => :recommended
  depends_on :x11 => MacOS::X11.installed? ? :recommended : :optional

  def install
    ENV.deparallelize
    ldflags=[]
    args=["--with-pic=1",
          "--with-shared-libraries",
          "--with-clanguage=C++"];

    if build.with? 'metis'
      args += ["--with-metis=1", "--with-metis-include=#{HOMEBREW_PREFIX}/include/", "--with-metis-lib=\[#{HOMEBREW_PREFIX}/lib/libmetis.a\]"]
    end
    if build.include? 'enable-metis'
      args+=["--download-metis"]
    end
    if build.with? 'parmetis'
      args += ["--with-parmetis=1", "--with-parmetis-include=#{HOMEBREW_PREFIX}/include/", "--with-parmetis-lib=\[#{HOMEBREW_PREFIX}/lib/libparmetis.a\]"]
    end

    if build.with? 'scalapack'
      args += ["--with-scalapack=1", "--with-scalapack-include=#{HOMEBREW_PREFIX}/include/", "--with-scalapack-lib=\[#{HOMEBREW_PREFIX}/lib/libscalapack.a\]"]
    end

    # cholmod
    if build.with? 'suite-sparse'
      args += ["--with-suitesparse=1",
               "--with-suitesparse-include=#{HOMEBREW_PREFIX}/include/",
               "--with-suitesparse-lib=\[#{HOMEBREW_PREFIX}/lib/libumfpack.a,#{HOMEBREW_PREFIX}/lib/libklu.a,#{HOMEBREW_PREFIX}/lib/libcholmod.a,#{HOMEBREW_PREFIX}/lib/libcolamd.a,#{HOMEBREW_PREFIX}/lib/libamd.a,#{HOMEBREW_PREFIX}/lib/libsuitesparseconfig.a\]"]
    end
    # ptscotch
    if build.include? 'enable-ptscotch'
      args+=["--download-ptscotch"]
    end
    if build.with? 'scotch5'
      args += ["--with-ptscotch=1","--with-ptscotch-include=#{HOMEBREW_PREFIX}/opt/scotch5/include/",
               "--with-ptscotch-lib=[#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptesmumps.a,#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptscotch.a,#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptscotcherr.a]"]
    end
    # mumps
    if build.with? 'mumps'
      args += ["--with-mumps=1",
               "--with-mumps-include=#{HOMEBREW_PREFIX}/include",
               "--with-mumps-lib=[#{HOMEBREW_PREFIX}/lib/libdmumps.a,#{HOMEBREW_PREFIX}/lib/libzmumps.a,#{HOMEBREW_PREFIX}/lib/libsmumps.a,#{HOMEBREW_PREFIX}/lib/libcmumps.a,#{HOMEBREW_PREFIX}/lib/libmumps_common.a,#{HOMEBREW_PREFIX}/lib/libpord.a]"
              ]
    end
    if build.include? 'enable-mumps'
      args+=["--download-mumps"]
    end
    if build.include? 'enable-ml'
      args+=["--download-ml"]
    end
    if build.include? 'enable-blas'
      args+=["--download-f-blas-lapack=1"]
    end
    if build.include? 'enable-scalapack'
      args+=["--download-scalapack"]
    end
    if build.include? 'enable-mkl'
      args+=["--with-blas-lapack-dir=/opt/intel/mkl/lib","--with-mkl_pardiso-dir=/opt/intel/mkl"]
      ENV['LDFLAGS'] += ' -L/opt/intel/lib -L/opt/intel/mkl/lib -Xlinker -rpath -Xlinker /opt/intel/lib -Xlinker -rpath -Xlinker /opt/intel/mkl/lib'
    end

    args << "--with-x=0" if build.without? 'x11'
    args += ["--LDFLAGS=#{ENV.ldflags}"]

    ENV['PETSC_DIR'] = Dir.getwd  # configure fails if those vars are set differently.

    if not build.without? 'debug'
      petsc_arch = 'arch-darwin-cxx-debug'
      ENV['PETSC_ARCH'] = petsc_arch
      system "./configure", "--prefix=#{prefix}/#{petsc_arch}","--with-debugging=1",*args
      system "make all"
      system "make test" if build.with? "check"
      system "make install"
    end
    if not build.without? 'opt'
      petsc_arch = 'arch-darwin-cxx-opt'
      ENV['PETSC_ARCH'] = petsc_arch
      system "./configure", "--prefix=#{prefix}/#{petsc_arch}","--with-debugging=0",*args
      system "make all"
      system "make test" if build.with? "check"
      system "make install"

      # Link only what we want in opt
      # include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"], "#{prefix}/#{petsc_arch}/include/finclude", "#{prefix}/#{petsc_arch}/include/petsc-private"
      # prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
      # lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
      # share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
    end

  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}
    and PETSC_ARCH to arch-darwin-cxx-opt or arch-darwin-cxx-debug.
    Fortran module files are in #{prefix}/arch-darwin-cxx-opt/include.
    EOS
  end
end
