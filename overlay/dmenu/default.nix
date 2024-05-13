{prev, ...}:
prev.dmenu.overrideAttrs (o: {
	src = prev.fetchFromGitHub {
	  owner = "hcssmith";
	  repo = "dmenu";
    rev = "c4ea96bb7a80b8a4d942fd6f2cb1375b1598b2e6";
    hash = "sha256-NwaXr4G+ITfhZW+oTKS0FxNPCTEz5beXjuMLJmk5CJs=";
	};
})
