{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kokkos";
  version = "4.6.00";

  src = fetchFromGitHub {
    owner = "kokkos";
    repo = "kokkos";
    rev = finalAttrs.version;
    hash = "sha256-4Or6Z/ZXH/WmA8GW6/Odn9+w7E/jdBDMCkWSpMf5Zoc=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "Kokkos_ENABLE_TESTS" true)
  ];

  postPatch = ''
    patchShebangs .
  '';

  doCheck = true;
  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "C++ Performance Portability Programming EcoSystem";
    homepage = "https://github.com/kokkos/kokkos";
    changelog = "https://github.com/kokkos/kokkos/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
