{ config, pkgs, lib, ... }:
{
  # Reference
  # - https://www.apalrd.net/posts/2023/network_acme/
  
  sops = {
    secrets = {
      "network/step-ca/keys_password" = {
        owner = config.systemd.services.step-ca.serviceConfig.User;
        group = config.systemd.services.step-ca.serviceConfig.Group;
      };
      "network/step-ca/root_crt" = {
        owner = config.systemd.services.step-ca.serviceConfig.User;
        group = config.systemd.services.step-ca.serviceConfig.Group;
      };
      "network/step-ca/intermediate_crt" = {
        owner = config.systemd.services.step-ca.serviceConfig.User;
        group = config.systemd.services.step-ca.serviceConfig.Group;
      };           
      "network/step-ca/intermediate_key" = {
        owner = config.systemd.services.step-ca.serviceConfig.User;
        group = config.systemd.services.step-ca.serviceConfig.Group;
      };
    };
  };


  security.acme = {
    acceptTerms = true;
    # Use 1443 here cause bootstrapping loop
    certs."ca.lab" = {
      server = "https://ca.lab:1443/acme/acme/directory";
      webroot = "/var/lib/acme/acme-challenge/";
    };
    defaults.email = "dev@sebastiaan.io";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "ca.lab" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://localhost:1443";
        };
      };
    };
  };

  services.step-ca = {
    enable = true;

    address = "0.0.0.0";
    port = 1443;
    # No password for the intermediate CA key.
    intermediatePasswordFile = config.sops.secrets."network/step-ca/keys_password".path;

    # Configurations which produces ca.json.
    # Based on `step ca init` generated ca.json.
    settings = {
      root = config.sops.secrets."network/step-ca/root_crt".path;
      # We do not trust other CAs, besides our own.
	    federatedRoots = null;
	    crt = config.sops.secrets."network/step-ca/intermediate_crt".path;
      # We do not trust other CAs, besides our own.
	    key = config.sops.secrets."network/step-ca/intermediate_key".path;
      # Disable HTTP server.
	    insecureAddress = "";
      dnsNames = [
        "localhost"
        "ca.lab"
      ];
      logger = {
        format = "text";
      };
      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
        badgerFileLoadingMode = "";
      };
      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
            # For backwards compatibility with services that cannot use SAN, 
            # we set the first entry in the SAN list as the CN.
            forceCN = true;
          }
        ];
        claims = {
          # Maximum lifetime of a certificate.
          maxTLSCertDuration     = "2160h";
          # Maximum lifetime of a certificate if no validity period is specified.
          defaultTLSCertDuration = "2160h";
        };
      };
      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };
}