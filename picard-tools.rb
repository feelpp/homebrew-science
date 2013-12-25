require 'formula'

class PicardTools < Formula
  homepage 'http://picard.sourceforge.net/'
  version '1.105'
  url "http://downloads.sourceforge.net/project/picard/picard-tools/#{version}/picard-tools-#{version}.zip"
  sha1 '34e9e6a959b8d5e2c4c2751516da596f9c4ac777'

  def install
    (share/'java').install Dir['*.jar', "picard-tools-#{version}/*.jar"]
  end

  def caveats
    <<-EOS.undent
      The Java JAR files are installed to
          #{HOMEBREW_PREFIX}/share/java
    EOS
  end
end
