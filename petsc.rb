require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.4.3.tar.gz'
# 3.4.4  sha1 '2f507195a3142eb0599e78a909446175a597480a'
  sha1 '7458f01c003dc7381d694445b5a2ecdbca91aa57'
  head 'https://bitbucket.org/petsc/petsc', :using => :git

  # do not use superenv
  env :std

  option 'enable-ptscotch', 'Compile with scotch support'
  option 'enable-metis', 'Compile with metis support'
  option 'enable-mumps', 'Compile with mumps support'
  option 'enable-ml', 'Compile with ml support'
  option 'enable-opt', 'Compile optimized petsc version'

  depends_on :mpi => [:cc, :fortran, :cxx]
  depends_on 'hdf5' => :recommended
  depends_on 'cmake' => :build

  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on :mpi => :cc
  depends_on :fortran
  #depends_on 'metis' => :recommended
  #depends_on 'parmetis' => :recommended
  depends_on 'scotch5' => :recommended
  depends_on 'mumps' => [:recommended, 'with-scotch5']
  depends_on 'suite-sparse' => :recommended
  depends_on 'scalapack' => :recommended
  depends_on :x11 => MacOS::X11.installed? ? :recommended : :optional

  option 'without-debug', 'Disable building debug flavor'

  def install
    ENV.deparallelize
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
      args += ["--with-cholmod=1",
               "--with-cholmod-include=#{HOMEBREW_PREFIX}/include/",
               "--with-cholmod-lib=\[#{HOMEBREW_PREFIX}/lib/libcholmod.a,#{HOMEBREW_PREFIX}/lib/libcolamd.a\]"]
      args += ["--with-umfpack=1", "--with-umfpack-include=#{HOMEBREW_PREFIX}/include/",
               "--with-umfpack-lib=\[#{HOMEBREW_PREFIX}/lib/libumfpack.a,#{HOMEBREW_PREFIX}/lib/libcholmod.a,#{HOMEBREW_PREFIX}/lib/libcolamd.a,#{HOMEBREW_PREFIX}/lib/libamd.a,#{HOMEBREW_PREFIX}/lib/libsuitesparseconfig.a\]"]
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

    args << "--with-x=0" if build.without? 'x11'
    ENV['PETSC_DIR'] = Dir.getwd  # configure fails if those vars are set differently.
    if not build.without? 'debug'
      petsc_arch = 'arch-darwin-cxx-debug'
      ENV['PETSC_ARCH'] = petsc_arch
      system "./configure", "--prefix=#{prefix}/#{petsc_arch}","--with-debugging=1",*args
      system "make all"
      system "make test" if build.with? "check"
      system "make install"

      # Link only what we want.
      # include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"], "#{prefix}/#{petsc_arch}/include/finclude", "#{prefix}/#{petsc_arch}/include/petsc-private"
      # prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
      # lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
      # share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
    end

    if build.include? 'enable-opt'
      petsc_arch = 'arch-darwin-cxx-opt'
      ENV['PETSC_ARCH'] = petsc_arch
      system "./configure", "--prefix=#{prefix}/#{petsc_arch}","--with-debugging=0",*args
      system "make all"
      system "make test" if build.with? "check"
      system "make install"
      # Link only what we want.
      # include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"], "#{prefix}/#{petsc_arch}/include/finclude", "#{prefix}/#{petsc_arch}/include/petsc-private"
      # prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
      # lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
      # share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
    end

  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}
    and PETSC_ARCH to arch-darwin-cxx-opt.
    Fortran module files are in #{prefix}/arch-darwin-cxx-opt/include.
    EOS
  end
end
