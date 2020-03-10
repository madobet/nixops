{ # 这个最顶层的属性整体定义了一个逻辑机器 (logical machine)

  # 元信息 network set 的 description 字符串变量定义该逻辑机器的元信息 (meta-information)
  network.description = "Web server";

  # Each attribute not named "network" describes a logical machine
  # 每一个逻辑机器属性的值是一个 “NixOS 配置模块”
  webserver =
    { config, pkgs, ... }:
    { services.httpd.enable = true;
      services.httpd.adminAddr = "alice@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    };
}
