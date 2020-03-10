# 为了部署这个机器,我们还需要提供配置选项来告诉 NixOps 要部署什么样的环境:

# 我要 deployed as a VirtualBox instance

# Note that for this to work the "vboxnet0" network has to exist
# you can add it in the VirtualBox general settings under Networks
# Host-only Networks if necessary.
# If you are running NixOps in a headless environment,
# then you should also add the option deployment.virtualbox.headless = true; 
# to the configuration. Otherwise, VirtualBox will fail when it tries to open
# a graphical display on the host's desktop.

{
  webserver =
    { config, pkgs, ... }:
    { deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024; # megabytes
      deployment.virtualbox.vcpu = 2; # number of cpus
    };
}
