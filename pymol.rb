class Pymol < Formula
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.7/pymol-v1.7.2.1.tar.bz2"
  sha1 "477ac127794ddf40f5177ffa4f141f097ca2fc9f"
  head "https://pymol.svn.sourceforge.net/svnroot/pymol/trunk/pymol"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "f5dc810c3e76fc9822565767f582ccce5e7b342a" => :yosemite
    sha1 "bab1e2f537e946a5fcb49b7cf7a48707f02e4cd6" => :mavericks
    sha1 "f4467ac59d136eae2d3d8ce379ef549c8e3eb414" => :mountain_lion
  end

  deprecated_option "default-stereo" => "with-default-stereo"

  option "with-default-stereo", "Set stereo graphics as default"

  depends_on "homebrew/dupes/tcl-tk" => ["enable-threads", "with-x11"]
  depends_on "glew"
  depends_on "python" => "with-brewed-tk"
  depends_on "freetype"
  depends_on "libpng"
  depends_on :x11

  # To use external GUI tk must be built with --enable-threads
  # and python must be setup to use that version of tk with --with-brewed-tk
  depends_on "Tkinter" => :python

  resource "pmw" do
    url "https://downloads.sourceforge.net/project/pmw/Pmw/Pmw.1.3.3/Pmw.1.3.3.tar.gz"
    sha1 "0ff7f03245640da4f37a97167967de8d09e4c6a6"
  end

  # This patch adds checks that force mono as default
  if build.without? "default-stereo"
    patch :p1 do
      url "https://gist.githubusercontent.com/scicalculator/1b84b2ad3503395f1041/raw/2a85dc56b4bd1ea28d99ce0b94acbf7ac880deff/pymol_disable_stereo.diff"
      sha1 "03585cef10b1f0729f4a50e306e0f448ddfc6b4c"
    end
  end

  # This patch disables the vmd plugin. VMD is not something we can depend on for now.
  # The plugin is set to always install as of revision 4019.
  patch :p1 do
    url "https://gist.githubusercontent.com/scicalculator/4966279/raw/9eb79bf5b6a36bd8f684bae46be2fcf834fea8de/pymol_disable_vmd_plugin.diff"
    sha1 "796d3999b9484957752e24252967b77679b2244b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("pmw").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # PyMol uses ./ext as a backup to look for ./ext/include and ./ext/lib
    ln_s HOMEBREW_PREFIX, "./ext"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    args = [
      "install",
      "--verbose",
      "--install-scripts=#{libexec}/bin",
      "--install-lib=#{libexec}/lib/python2.7/site-packages",
    ]

    system "python", "-s", "setup.py", *args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pymol", libexec/"lib/python2.7/site-packages/pymol/pymol_path/data/demo/pept.pdb"
  end

  def caveats
    <<-EOS.undent

    In order to get the most out of pymol, you will want the external
    gui. This requires a thread enabled tk installation and python
    linked to it. Install these with the following commands.
      brew tap homebrew/dupes
      brew install homebrew/dupes/tcl-tk --enable-threads --with-x11
      brew install python --with-brewed-tk

    On some macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until x11 is completely closed. This may even require
    restarting your computer. Therefore, we install pymol in a way that
    defaults to mono graphics. This is equivalent to running pymol with
    the "-M" option. You can still run in stereo mode by running
      pymol -S

    You can install pymol such that it defaults to stereo with the
    "--default-stereo" option.

    EOS
  end
end
