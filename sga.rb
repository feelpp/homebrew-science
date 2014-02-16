require 'formula'

class Sga < Formula
  homepage 'https://github.com/jts/sga'
  url 'https://github.com/jts/sga/archive/v0.10.13.tar.gz'
  sha1 '36d5a23a393c968120988dd94bad9d561b0e0c4e'
  head 'https://github.com/jts/sga.git'

  depends_on :autoconf => :build
  depends_on :automake => :build
  # Only header files are used, so :build is appropriate
  depends_on 'google-sparsehash' => :build
  depends_on 'bamtools'

  def install
    cd 'src' do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-bamtools=#{Formula.factory('bamtools').opt_prefix}",
                            "--with-sparsehash=#{Formula.factory('google-sparsehash').opt_prefix}"
      system "make install"
    end
  end

  test do
    system "#{bin}/sga", "--version"
  end
end
