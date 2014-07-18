require 'formula'

class Unison232 < Formula
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-2.32.52/unison-2.32.52.tar.gz'
  sha1 '68ea5709de4fcc2f9aef7b01b24637503b61b5ac'

  depends_on 'objective-caml'

  # http://tech.groups.yahoo.com/group/unison-users/message/9348
  # required for building 2.32.52 with ocamlc 3.12.x
  patch :DATA

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end

__END__
--- unison-2.32.52/update.mli	2009-05-02 03:31:27.000000000 +0100
+++ unison-2.32.52/update.mli	2011-11-04 20:21:11.000000000 +0000
@@ -1,7 +1,7 @@
 (* Unison file synchronizer: src/update.mli *)
 (* Copyright 1999-2009, Benjamin C. Pierce (see COPYING for details) *)
 
-module NameMap : Map.S with type key = Name.t
+module NameMap : MyMap.S with type key = Name.t
 
 type archive =
     ArchiveDir of Props.t * archive NameMap.t
