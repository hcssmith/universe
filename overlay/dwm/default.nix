{prev, ...}:
prev.dwm.overrideAttrs (o: {
  src = prev.fetchFromGitHub {
    owner = "hcssmith";
    repo = "dwm";
    rev = "cc6b504eefbbe952b3976250ed07df0f54002f8c";
    hash = "sha256-KItw3+M+bUfvFXcZ4zCzwlG87yfrXKz5pHzZ0iJlvcI=";
  };
})
