{ pkgs, config, ... }:
{
  languages = {
    javascript = {
      enable = true;
      package = pkgs.nodejs_24;
      corepack.enable = true;
      bun.enable = true;
    };

    typescript.enable = true;
  };

  # env.NPM_CONFIG_PREFIX = "${config.devenv.state}/npm-global";
  # env.PATH = "${config.devenv.state}/npm-global/bin:${pkgs.nodejs_24}/bin:$PATH";

  # mkdir."${config.devenv.state}/npm-global" = { };

  # packages = [
  #   pkgs.nodePackages_latest.pnpm
  #   pkgs.nodePackages_latest.yarn
  # ];
}
