{prev, ...}:
prev.slstatus.overrideAttrs (o: {
  src = prev.fetchFromGitHub {
    owner = "hcssmith";
    repo = "slstatus";
    rev = "4d8eb4efc07f4a6f72d37f3c42e3363790cfb8a5";
    hash = "sha256-UxEpvEZFbPpZ414Xgc9WRlCQSB9tqS/X/V6hYqaWMn0=";
  };
})
