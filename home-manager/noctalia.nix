{
  config,
  pkgs,
  noctalia,
  ...
}: {
  programs.noctalia-shell = {
    enable = true;
  };
}
