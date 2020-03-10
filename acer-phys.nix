{
  acer =
    { config, pkgs, ... }:
    {
      # 部署只需要做两件事，剩下的我会自动解决：
      # 1. 部署的目标信息你需要告诉我：
      deployment.targetHost = "acer.lan";
      # 2. 你要在目标上部署什么需要告诉我：
      imports = [
          ../nixos/acer/configuration.nix
      ];
    };
}
