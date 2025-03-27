{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker-compose
    dive # explore docker layers
    lazydocker # Docker terminal UI.
  ];
}