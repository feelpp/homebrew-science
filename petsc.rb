require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.4.3.tar.gz'
  sha1 '7458f01c003dc7381d694445b5a2ecdbca91aa57'

  # do not use superenv
  env :std

  depends_on :mpi => [:cc, :fortran, :cxx]
  depends_on 'hdf5' => :recommended
  depends_on 'cmake' => :build
  depends_on :fortran
  depends_on 'metis' => :recommended
  depends_on 'parmetis' => :recommended
  depends_on 'scotch5' => :recommended
  depends_on 'mumps' => [:recommended, 'with-scotch5']
  depends_on 'suite-sparse' => :recommended
  depends_on 'scalapack' => :recommended


  def install
    ENV.deparallelize
    args=["--with-pic=1",
          "--with-shared-libraries",
          "--with-clanguage=C++",
          "--with-metis=1", "--with-metis-include=#{HOMEBREW_PREFIX}/include/", "--with-metis-lib=\[#{HOMEBREW_PREFIX}/lib/libmetis.a\]",
          "--with-parmetis=1", "--with-parmetis-include=#{HOMEBREW_PREFIX}/include/", "--with-parmetis-lib=\[#{HOMEBREW_PREFIX}/lib/libparmetis.a\]",
          "--with-scalapack=1", "--with-scalapack-include=#{HOMEBREW_PREFIX}/include/", "--with-scalapack-lib=\[#{HOMEBREW_PREFIX}/lib/libscalapack.a\]",
          # cholmod
          "--with-cholmod=1",
          "--with-cholmod-include=#{HOMEBREW_PREFIX}/include/",
          "--with-cholmod-lib=\[#{HOMEBREW_PREFIX}/lib/libcholmod.a,#{HOMEBREW_PREFIX}/lib/libcolamd.a\]",
          # umfpack
          "--with-umfpack=1", "--with-umfpack-include=#{HOMEBREW_PREFIX}/include/",
          "--with-umfpack-lib=\[#{HOMEBREW_PREFIX}/lib/libumfpack.a,#{HOMEBREW_PREFIX}/lib/libcholmod.a,#{HOMEBREW_PREFIX}/lib/libcolamd.a,#{HOMEBREW_PREFIX}/lib/libamd.a,#{HOMEBREW_PREFIX}/lib/libsuitesparseconfig.a\]",
          # ptscotch
          "--with-ptscotch=1","--with-ptscotch-include=#{HOMEBREW_PREFIX}/opt/scotch5/include/",
          "--with-ptscotch-lib=[#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptesmumps.a,#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptscotch.a,#{HOMEBREW_PREFIX}/opt/scotch5/lib/libptscotcherr.a]",
          # mumps
          "--with-mumps=1",
          "--with-mumps-include=#{HOMEBREW_PREFIX}/include",
	  "--with-mumps-lib=[#{HOMEBREW_PREFIX}/lib/libdmumps.dylib,#{HOMEBREW_PREFIX}/lib/libzmumps.dylib,#{HOMEBREW_PREFIX}/lib/libsmumps.dylib,#{HOMEBREW_PREFIX}/lib/libcmumps.dylib,#{HOMEBREW_PREFIX}/lib/libmumps_common.dylib,#{HOMEBREW_PREFIX}/lib/libpord.dylib]"

#          "--download-ml",
         ]

    system "./configure", "PETSC_ARCH=arch-darwin-cxx-debug","--prefix=#{prefix}/lib/petscdir/3.4.3/darwin-cxx-debug","--with-debugging=1",*args
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug all"
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug test"
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-debug install"

    system "./configure", "PETSC_ARCH=arch-darwin-cxx-opt","--prefix=#{prefix}/lib/petscdir/3.4.3/darwin-cxx-opt","--with-debugging=0",*args
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt all"
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt test"
    system "make PETSC_DIR=#{Dir.pwd} PETSC_ARCH=arch-darwin-cxx-opt install"
  end
end
