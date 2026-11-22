class Oscar64 < Formula
  desc "Optimizing C/C++ cross compiler for 6502 family processors"
  homepage "https://github.com/drmortalwombat/oscar64"
  url "https://github.com/drmortalwombat/oscar64/archive/refs/tags/v1.32.273.tar.gz"
  sha256 "39eb90385a6beb6cb6e4e08ce53b36e70115dcca7c42941afbe3d4102ae98731"
  license "GPL-3.0-only"

  depends_on "cmake" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (include/"oscar64").install "include/new"
  end

  test do
    assert_path_exists include/"oscar64/crt.h"
    assert_path_exists include/"oscar64/stdio.h"
    assert_path_exists include/"oscar64/new"

    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("HELLO C64\\n");
        return 0;
      }
    C

    system bin/"oscar64", "hello.c", "-o=hello.prg"
    assert_path_exists testpath/"hello.prg"
    refute_predicate (testpath/"hello.prg").size, :zero?
  end
end
