require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.4.3.tar.gz'
  sha1 '8c5d97ba4a28ea8fa830e513a9dcbfd61b51beaf'
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
          #"--with-shared-libraries",
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

    if not build.without? 'debug'
      system "./configure", "PETSC_ARCH=arch-darwin-cxx-debug","--prefix=#{prefix}/lib/petscdir/3.4.3/darwin-cxx-debug","--with-debugging=1",*args
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug all"
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug test"
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug install"
    end

    if build.include? 'enable-opt'

      system "./configure", "PETSC_ARCH=arch-darwin-cxx-opt","--prefix=#{prefix}/lib/petscdir/3.4.3/darwin-cxx-opt","--with-debugging=0",*args
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt all"
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt test"
      system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt install"
    end

    # Link only what we want.
    #include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"], "#{prefix}/#{petsc_arch}/include/finclude", "#{prefix}/#{petsc_arch}/include/petsc-private"
    #prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    #lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    #share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}
    and PETSC_ARCH to arch-darwin-c-opt.
    Fortran module files are in #{prefix}/arch-darwin-c-opt/include.
    EOS
  end
end
