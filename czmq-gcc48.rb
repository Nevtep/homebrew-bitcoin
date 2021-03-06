require 'formula'

class CzmqGcc48 < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-2.0.3.tar.gz'
  sha1 'df8e6d547f43545bcd058697a2476474f9e3a0c1'

  head do
    url 'https://github.com/zeromq/czmq.git'

    depends_on 'autoconf'
    depends_on 'automake'
    depends_on 'libtool'
  end

  option :universal

  depends_on 'Nevtep/bitcoin/zeromq2-gcc48'

  def install
    ENV.prepend_path 'PATH', "#{HOMEBREW_PREFIX}/opt/gcc48/bin"
    ENV['CC'] = "gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "g++-4.8"

    zeromq = Formula['Nevtep/bitcoin/zeromq2-gcc48']
    ENV.append 'CPPFLAGS', "-I#{zeromq.include}"
    ENV.append 'LDFLAGS', "-L#{zeromq.lib}"
    
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/czmq_selftest"
  end
end
