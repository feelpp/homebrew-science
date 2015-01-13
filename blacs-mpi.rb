class BlacsMpi < Formula
  homepage "http://www.netlib.org/blacs/"
  url "http://www.netlib.org/blacs/mpiblacs.tgz"
  version '1.1'
  sha1 "b9503a2fddd4136a2b7ce3f5a9cd97dd5ec0d6b6"

  #depends_on "gfortran" => :build

  def install
    system "cp BMAKES/Bmake.MPI-LINUX Bmake.inc"
    system "sed -i.bak \"s|\\$(HOME)/BLACS|`(pwd)`|g\" Bmake.inc"
    system "sed -i.bak \"s|PLAT = LINUX|PLAT = MACOS|g\" Bmake.inc"
    system "sed -i.bak \"s|MPIdir = /usr/local/mpich|MPIdir = |g\" Bmake.inc"
    system "sed -i.bak \"s|MPILIBdir = \\$(MPIdir)/lib/|MPILIBdir = |g\" Bmake.inc"
    system "sed -i.bak \"s|MPIINCdir = \\$(MPIdir)/include|MPIINCdir = /usr/local/include/ |g\" Bmake.inc"
    system "sed -i.bak \"s|MPILIB = \\$(MPILIBdir)/libmpich.a|MPILIB = |g\" Bmake.inc"
    system "sed -i.bak \"s|TRANSCOMM = -DCSameF77|TRANSCOMM = -DUseMpi2|g\" Bmake.inc"
    
    system "sed -i.bak \"s|SYSINC = -I\\$(MPIINCdir)|SYSINC = |g\" Bmake.inc"
    
    system "sed -i.bak \"s|g77|mpif77|g\" Bmake.inc"
    system "sed -i.bak \"s|gcc|mpicc|g\" Bmake.inc"
    system "make mpi"
    #system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test blacs-mpi`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "ls"
  end
end
