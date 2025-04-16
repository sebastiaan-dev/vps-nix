{ pkgs, ... }:

{
	environment.etc."bind/zones/db.lab" = {
	enable  = true;
	user    = "named";
	group   = "named";
	mode    = "0644";
	text = ''
		$TTL    86400
		@   IN  SOA dns.lab. dev.sebastiaan.io. (
				2025041601 ; Serial
				3600       ; Refresh
				600        ; Retry
				86400      ; Expire
				86400 )    ; Minimum
			IN  NS  dns.lab.
		dns IN  A   100.115.206.109
	'';
	};

	services.bind = {
		enable = true;
		directory = "/var/cache/named";
		configFile = ./named.conf;
	};
	
	services.adguardhome = {
		enable = true;
		host = "0.0.0.0";
		port = 3000;

		settings = {
			dns = {
				upstream_dns = [
					"127.0.0.1:5353" # Bind DNS server
				];
			};
		};
	};
}

# settings = {
#         dns = {
#          upstream_dns = [
#            "9.9.9.9" #dns.quad9.net
#            "149.112.112.112" #dns.quad9.net
#          ];
#          anonymize_client_ip = true;
#          enable_dnssec = true;
#         };
	
#         filtering = {
#           protection_enabled = true;
#           filtering_enabled = true;

#          parental_enabled = false; # Parental control-based DNS requests filtering.
#          safe_search.enabled = false; # Enforcing "Safe search" option for search engines, when possible.
#         };

#         filters =
#          map (url: {
#            enabled = true;
#            url = url;
#          }) [
#            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
#            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
#            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt" # uBlock₀ filters – Badware risk
#            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # AdGuard DNS filter
#            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt" # AdGuard DNS Popup Hosts filter
#            "https://big.oisd.nl"
#            "https://hblock.molinero.dev/hosts"
#            "https://hblock.molinero.dev/hosts_adblock.txt"
#          ];
# };