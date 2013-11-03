require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.4.3.tar.gz'
  sha1 '7458f01c003dc7381d694445b5a2ecdbca91aa57'

  # do not use superenv
  env :std

  depends_on :mpi => [:cc, :fortran, :cxx]
  depends_on 'hdf5' => :build
  depends_on 'cmake' => :build
  depends_on :fortran

  def install
    ENV.deparallelize
    args=["--with-pic=1",
          "--with-shared-libraries",
          "--with-clanguage=C++",
          "--download-metis",
          "--download-parmetis",
          "--download-blacs",
          "--download-scalapack",
          "--download-umfpack",
          "--download-mumps",
          "--download-ml",
          "--download-ptscotch"
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
