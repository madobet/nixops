let

  # change this as necessary or wipe and use ENV vars
  credentials = {
    project = "madobet";
    serviceAccount = "madobet@outlook.com";
    accessKey = "~/.ssh/madobet_rsa";
  };

  gce = { resources, ...}:  {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    deployment.targetEnv = "gce";
    deployment.gce = credentials // {
      region = "us-east1-b";
      tags = [ "http-server" "https-server" "proxy-server" ];
      network = resources.gceNetworks.lb-net;
    };
  };

in {

  # create a network that allows SSH traffic(by default), pings
  # and HTTP traffic for machines tagged "public-http"
  resources.gceNetworks.lb-net = credentials // {
    addressRange = "192.168.4.0/24";
    firewall = {
      allow-http = {
        targetTags = [ "nixops-http" ];
        allowed.tcp = [ 80 443 ];
      };
      allow-ping.allowed.icmp = null;
    };
  };

  # by default, health check pings port 80, so we don't have to set anything
  resources.gceHTTPHealthChecks.plain-hc = credentials;

  resources.gceTargetPools.backends = { resources, nodes, ...}: credentials // {
    region = "us-east1";
    healthCheck = resources.gceHTTPHealthChecks.plain-hc;
    machines = with nodes; [ backend1 backend2 ];
    # machines = with nodes; [ backend1 ];
  };

  resources.gceForwardingRules.lb = { resources, ...}: credentials // {
    protocol = "TCP";
    region = "us-east1";
    portRange = "80";
    targetPool = resources.gceTargetPools.backends;
    description = "Alternative HTTP Load Balancer";
  };

  proxy    = gce;
  backend1 = gce;
  backend2 = gce;
}
