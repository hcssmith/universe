{prev, ...}:
prev.st.overrideAttrs (o: {
  src = prev.fetchFromGitHub {
    owner = "hcssmith";
    repo = "st";
    rev = "5038733cc46d9db18e0067b82e9450e8c0ba3e33";
    hash = "sha256-A8J/pePlBgRZDzT/I6shiAoEJ+QYktLczknAOwijuKU=";
  };
})
