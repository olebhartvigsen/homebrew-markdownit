class Markdownit < Formula
  desc "Native markdown viewer and editor"
  homepage "https://olebhartvigsen.github.io/MarkDownIt/"
  # The v0.2.1 tag predates the macOS port, so this pins the last commit whose
  # macOS build passed CI. Once a v0.2.2 tag exists this becomes a tag URL and
  # the version line follows the tag.
  url "https://github.com/olebhartvigsen/MarkDownIt/archive/adb773d7aa0e90b9ea83e2ba740ed2ba719ded80.tar.gz"
  version "0.2.1"
  sha256 "8fc9e0f57249c20b84a999f6fb63a0a6389e091a719379d120a493739c1f1f2b"
  license "MIT"
  head "https://github.com/olebhartvigsen/MarkDownIt.git", branch: "main"

  depends_on "cmake" => :build
  depends_on :macos

  def install
    # The same two commands CI runs. The project sets its own deployment
    # target (12.0) and native architecture in CMakeLists.txt, so the build
    # gets no extra architecture flags from here.
    system "cmake", "-S", ".", "-B", "build-mac", "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build-mac", "--target", "MarkDownItMac", "-j", ENV.make_jobs

    prefix.install "build-mac/MarkDownIt.app"

    # Homebrew re-signs nested binaries while it relocates a pulled bottle,
    # and the linker's signature is not enough for a relocated bundle. A
    # source build lands in the Cellar either way, so the seal is renewed
    # here; every arm64 binary needs a valid one to launch at all.
    system "codesign", "--force", "--deep", "--sign", "-", prefix/"MarkDownIt.app"
  end

  def caveats
    <<~EOS
      MarkDownIt.app is installed at:
        #{opt_prefix}/MarkDownIt.app

      Homebrew does not write to /Applications. To get the app into Launchpad
      and your Applications folder, link it once:
        ln -sfn #{opt_prefix}/MarkDownIt.app /Applications/MarkDownIt.app

      The app is built from source on this Mac, so Gatekeeper has no download
      to object to and the first launch is a plain double-click.
    EOS
  end

  test do
    app = prefix/"MarkDownIt.app"
    assert_predicate app/"Contents/MacOS/MarkDownIt", :executable?
    assert_match "valid on disk",
                 shell_output("codesign --verify --deep --strict --verbose=2 #{app} 2>&1")
  end
end
