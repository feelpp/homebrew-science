require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class BlacsMpi < Formula
  homepage "http://www.netlib.org/blacs/"
  url "http://www.netlib.org/blacs/mpiblacs.tgz"
  sha1 ""

  depends_on "gfortran" => :build

  def patches
    DATA
  end

  def install
    system "BASEDIR=#{pwd} MPI=openmpi make mpi"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test blacs-mpi`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff -Nru blacs-mpi-1.1.orig//Bmake.inc blacs-mpi-1.1//Bmake.inc
--- blacs-mpi-1.1.orig//Bmake.inc	2011-08-15 21:08:36.474630178 -0700
+++ blacs-mpi-1.1//Bmake.inc	2011-08-15 21:11:41.535007658 -0700
@@ -1,4 +1,38 @@
 #=============================================================================
+#=========================== SECTION 3: COMPILERS ============================
+#=============================================================================
+#  The following macros specify compilers, linker/loaders, the archiver,
+#  and their options.  Some of the fortran files need to be compiled with no
+#  optimization.  This is the F77NO_OPTFLAG.  The usage of the remaining
+#  macros should be obvious from the names.
+#
+#  This section has been moved before Section 1 to allow redefinition of the
+#  F77 and CC options in the MPI implementation specific clauses.
+#=============================================================================
+   F77            = gfortran
+   F77NO_OPTFLAGS = $(FPIC) -w
+   F77FLAGS       = $(F77NO_OPTFLAGS) -O4
+   F77LOADER      = $(F77)
+   F77LOADFLAGS   =
+   CC             = cc
+   CCFLAGS        = $(FPIC) -O4
+   CCLOADER       = $(CC)
+   CCLOADFLAGS    =
+
+#  --------------------------------------------------------------------------
+#  The archiver and the flag(s) to use when building an archive (library).
+#  Also the ranlib routine.  If your system has no ranlib, set RANLIB = echo.
+#  --------------------------------------------------------------------------
+   ARCH      = ar
+   ARCHFLAGS = r
+   RANLIB    = ranlib
+
+#=============================================================================
+#=============================== End SECTION 3 ===============================
+#=============================================================================
+
+
+#=============================================================================
 #====================== SECTION 1: PATHS AND LIBRARIES =======================
 #=============================================================================
 #  The following macros specify the name and location of libraries required by
@@ -44,24 +78,38 @@
    BLACSCINIT  = $(BLACSdir)/blacsCinit_$(COMMLIB)-$(PLAT)-$(BLACSDBGLVL).a
    BLACSLIB    = $(BLACSdir)/blacs_$(COMMLIB)-$(PLAT)-$(BLACSDBGLVL).a

+# Default unless overridden below:
+   CC          = cc
+
 #  -------------------------------------
 #  Name and location of the MPI library.
 #  -------------------------------------
 ifeq ($(MPI),mpich)
 # for compilation with mpich:
    MPIdir = /usr/lib/mpich
-   MPIdev = ch_p4
-   MPIplat = LINUX
    MPILIBdir = $(MPIdir)/lib
    MPIINCdir = $(MPIdir)/include
-   MPILIB = $(MPILIBdir)/shared/libmpich.so $(MPILIBdir)/shared/libpmpich.so $(MPILIBdir)/libmpich.a
-else
+   MPILIB = -lmpich
+   CC = mpicc.mpich
+   F77 = mpif90.mpich
+endif
+ifeq ($(MPI),lam)
 # for compilation with lam:
    MPILIBdir = /usr/lib/lam/lib
    MPIINCdir = /usr/include/lam
    MPILIB = -L/usr/lib/lam/lib -llam
+   CC = mpicc.lam
+   F77 = mpif90.lam
+endif
+ifeq ($(MPI),openmpi)
+# for compilation with openmpi:
+   MPIdir = /usr/lib/openmpi
+   MPILIBdir = $(MPIdir)/lib
+   MPIINCdir = $(MPIdir)/include
+   MPILIB = -L/usr/lib/openmpi/lib -lmpi -lmpi_f77
+   CC = mpicc.openmpi
+   F77 = mpif90.openmpi
 endif
-

 #  -------------------------------------
 #  All libraries required by the tester.
@@ -98,11 +146,7 @@
 #  The directory to find the required communication library include files,
 #  if they are required by your system.
 #  -----------------------------------------------------------------------
-ifeq ($(MPI),mpich)
-   SYSINC = -I$(MPIINCdir) -I$(MPIdir)/build/$(MPIplat)/$(MPIdev)/include
-else
-   SYSINC = -I$(MPIINCdir)
-endif
+SYSINC = -I$(MPIINCdir)

 #  ---------------------------------------------------------------------------
 #  The Fortran 77 to C interface to be used.  If you are unsure of the correct
@@ -208,33 +252,3 @@
 #=============================== End SECTION 2 ===============================
 #=============================================================================

-
-#=============================================================================
-#=========================== SECTION 3: COMPILERS ============================
-#=============================================================================
-#  The following macros specify compilers, linker/loaders, the archiver,
-#  and their options.  Some of the fortran files need to be compiled with no
-#  optimization.  This is the F77NO_OPTFLAG.  The usage of the remaining
-#  macros should be obvious from the names.
-#=============================================================================
-   F77            = gfortran
-   F77NO_OPTFLAGS = $(FPIC) -w
-   F77FLAGS       = $(F77NO_OPTFLAGS) -O4
-   F77LOADER      = $(F77)
-   F77LOADFLAGS   =
-   CC             = cc
-   CCFLAGS        = $(FPIC) -O4
-   CCLOADER       = $(CC)
-   CCLOADFLAGS    =
-
-#  --------------------------------------------------------------------------
-#  The archiver and the flag(s) to use when building an archive (library).
-#  Also the ranlib routine.  If your system has no ranlib, set RANLIB = echo.
-#  --------------------------------------------------------------------------
-   ARCH      = ar
-   ARCHFLAGS = r
-   RANLIB    = ranlib
-
-#=============================================================================
-#=============================== End SECTION 3 ===============================
-#=============================================================================
diff -Nru blacs-mpi-1.1.orig/SRC/MPI/Makefile blacs-mpi-1.1/SRC/MPI/Makefile
--- blacs-mpi-1.1.orig/SRC/MPI/Makefile	2011-08-15 20:33:19.000000000 -0700
+++ blacs-mpi-1.1/SRC/MPI/Makefile	2011-08-15 20:34:39.870603642 -0700
@@ -194,8 +194,8 @@
 	$(F77) -c $(F77FLAGS) $*.f

 mpif.h: $(MPIINCdir)/mpif.h
-	rm -f mpif.h
-	ln -s $< $@
+	rm -f mpif*
+	ln -s $(MPIINCdir)/mpif* .

 #  ------------------------------------------------------------------------
 #  We move C .o files to .C so that we can use the portable suffix rule for
diff -Nru blacs-mpi-1.1.orig/TESTING/Makefile blacs-mpi-1.1/TESTING/Makefile
--- blacs-mpi-1.1.orig/TESTING/Makefile	2011-08-15 20:33:19.000000000 -0700
+++ blacs-mpi-1.1/TESTING/Makefile	2011-08-15 20:34:39.870603642 -0700
@@ -59,8 +59,8 @@
 	$(F77) -c $(F77FLAGS) $*.f

 mpif.h: $(MPIINCdir)/mpif.h
-	rm -f mpif.h
-	ln -s $< $@
+	rm -f mpif*
+	ln -s $(MPIINCdir)/mpif* .

 fpvm3.h : $(PVMINCdir)/fpvm3.h
 	rm -f fpvm3.h
