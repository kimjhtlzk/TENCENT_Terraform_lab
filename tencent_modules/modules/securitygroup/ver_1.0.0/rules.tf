variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
  default = {
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
    # HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
    # SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]
    # Redis
    redis-tcp = [6379, 6379, "tcp", "Redis"]
    # Carbon relay
    carbon-line-in-tcp = [2003, 2003, "tcp", "Carbon line-in"]
    carbon-line-in-udp = [2003, 2003, "udp", "Carbon line-in"]
    carbon-pickle-tcp  = [2013, 2013, "tcp", "Carbon pickle"]
    carbon-pickle-udp  = [2013, 2013, "udp", "Carbon pickle"]
    carbon-admin-tcp   = [2004, 2004, "tcp", "Carbon admin"]
    carbon-gui-udp     = [8081, 8081, "tcp", "Carbon GUI"]
    # Cassandra
    cassandra-clients-tcp        = [9042, 9042, "tcp", "Cassandra clients"]
    cassandra-thrift-clients-tcp = [9160, 9160, "tcp", "Cassandra Thrift clients"]
    cassandra-jmx-tcp            = [7199, 7199, "tcp", "JMX"]
    # Consul
    consul-tcp          = [8300, 8300, "tcp", "Consul server"]
    consul-cli-rpc-tcp  = [8400, 8400, "tcp", "Consul CLI RPC"]
    consul-webui-tcp    = [8500, 8500, "tcp", "Consul web UI"]
    consul-dns-tcp      = [8600, 8600, "tcp", "Consul DNS"]
    consul-dns-udp      = [8600, 8600, "udp", "Consul DNS"]
    consul-serf-lan-tcp = [8301, 8301, "tcp", "Serf LAN"]
    consul-serf-lan-udp = [8301, 8301, "udp", "Serf LAN"]
    consul-serf-wan-tcp = [8302, 8302, "tcp", "Serf WAN"]
    consul-serf-wan-udp = [8302, 8302, "udp", "Serf WAN"]
    # DNS
    dns-udp = [53, 53, "udp", "DNS"]
    dns-tcp = [53, 53, "tcp", "DNS"]
    # NTP - Network Time Protocol
    ntp-udp = [123, 123, "udp", "NTP"]
    # Elasticsearch
    elasticsearch-rest-tcp = [9200, 9200, "tcp", "Elasticsearch REST interface"]
    elasticsearch-java-tcp = [9300, 9300, "tcp", "Elasticsearch Java interface"]
    # IPSEC
    ipsec-500-udp  = [500, 500, "udp", "IPSEC ISAKMP"]
    ipsec-4500-udp = [4500, 4500, "udp", "IPSEC NAT-T"]
    # Kafka
    kafka-broker-tcp = [9092, 9092, "tcp", "Kafka broker 0.8.2+"]
    # LDAPS
    ldaps-tcp = [636, 636, "tcp", "LDAPS"]
    # Memcached
    memcached-tcp = [11211, 11211, "tcp", "Memcached"]
    # MongoDB
    mongodb-27017-tcp = [27017, 27017, "tcp", "MongoDB"]
    mongodb-27018-tcp = [27018, 27018, "tcp", "MongoDB shard"]
    mongodb-27019-tcp = [27019, 27019, "tcp", "MongoDB config server"]
    # MySQL
    mysql-tcp = [3306, 3306, "tcp", "MySQL"]
    # MSSQL Server
    mssql-tcp           = [1433, 1433, "tcp", "MSSQL Server"]
    mssql-udp           = [1434, 1434, "udp", "MSSQL Browser"]
    mssql-analytics-tcp = [2383, 2383, "tcp", "MSSQL Analytics"]
    mssql-broker-tcp    = [4022, 4022, "tcp", "MSSQL Broker"]
    # NFS/EFS
    nfs-tcp = [2049, 2049, "tcp", "NFS/EFS"]
    # Nomad
    nomad-http-tcp = [4646, 4646, "tcp", "Nomad HTTP"]
    nomad-rpc-tcp  = [4647, 4647, "tcp", "Nomad RPC"]
    nomad-serf-tcp = [4648, 4648, "tcp", "Serf"]
    nomad-serf-udp = [4648, 4648, "udp", "Serf"]
    # OpenVPN
    openvpn-udp       = [1194, 1194, "udp", "OpenVPN"]
    openvpn-tcp       = [943, 943, "tcp", "OpenVPN"]
    openvpn-https-tcp = [443, 443, "tcp", "OpenVPN"]
    # PostgreSQL
    postgresql-tcp = [5432, 5432, "tcp", "PostgreSQL"]
    # Oracle Database
    oracle-db-tcp = [1521, 1521, "tcp", "Oracle"]
    # Puppet
    puppet-tcp   = [8140, 8140, "tcp", "Puppet"]
    puppetdb-tcp = [8081, 8081, "tcp", "PuppetDB"]
    # RabbitMQ
    rabbitmq-4369-tcp  = [4369, 4369, "tcp", "RabbitMQ epmd"]
    rabbitmq-5671-tcp  = [5671, 5671, "tcp", "RabbitMQ"]
    rabbitmq-5672-tcp  = [5672, 5672, "tcp", "RabbitMQ"]
    rabbitmq-15672-tcp = [15672, 15672, "tcp", "RabbitMQ"]
    rabbitmq-25672-tcp = [25672, 25672, "tcp", "RabbitMQ"]
    # RDP
    rdp-tcp = [3389, 3389, "tcp", "Remote Desktop"]
    rdp-udp = [3389, 3389, "udp", "Remote Desktop"]
    # Redshift
    redshift-tcp = [5439, 5439, "tcp", "Redshift"]
    # Splunk
    splunk-indexer-tcp = [9997, 9997, "tcp", "Splunk indexer"]
    splunk-web-tcp     = [8000, 8000, "tcp", "Splunk Web"]
    splunk-splunkd-tcp = [8089, 8089, "tcp", "Splunkd"]
    splunk-hec-tcp     = [8088, 8088, "tcp", "Splunk HEC"]
    # Squid
    squid-proxy-tcp = [3128, 3128, "tcp", "Squid default proxy"]
    # Storm
    storm-nimbus-tcp     = [6627, 6627, "tcp", "Nimbus"]
    storm-ui-tcp         = [8080, 8080, "tcp", "Storm UI"]
    storm-supervisor-tcp = [6700, 6703, "tcp", "Supervisor"]
    # Web
    web-jmx-tcp = [1099, 1099, "tcp", "JMX"]
    # WinRM
    winrm-http-tcp  = [5985, 5985, "tcp", "WinRM HTTP"]
    winrm-https-tcp = [5986, 5986, "tcp", "WinRM HTTPS"]
    # Zipkin
    zipkin-admin-tcp       = [9990, 9990, "tcp", "Zipkin Admin port collector"]
    zipkin-admin-query-tcp = [9901, 9901, "tcp", "Zipkin Admin port query"]
    zipkin-admin-web-tcp   = [9991, 9991, "tcp", "Zipkin Admin port web"]
    zipkin-query-tcp       = [9411, 9411, "tcp", "Zipkin query port"]
    zipkin-web-tcp         = [8080, 8080, "tcp", "Zipkin web port"]
    # Zookeeper
    zookeeper-2181-tcp = [2181, 2181, "tcp", "Zookeeper"]
    zookeeper-2888-tcp = [2888, 2888, "tcp", "Zookeeper"]
    zookeeper-3888-tcp = [3888, 3888, "tcp", "Zookeeper"]
    zookeeper-jmx-tcp  = [7199, 7199, "tcp", "JMX"]
    # Open all ports & protocols
    all-all  = [-1, -1, "all", "All protocols"]
    all-tcp  = [0, 65535, "tcp", "All TCP ports"]
    all-udp  = [0, 65535, "udp", "All UDP ports"]
    all-icmp = [-1, -1, "icmp", "All IPV4 ICMP"]
    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", "tcp", ""]
  }
}

variable "auto_groups" {
  description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
  type        = map(map(list(string)))

  # Valid keys - ingress_rules, egress_rules
  default = {
    http-80 = {
      ingress_rules = ["http-80-tcp"]
      egress_rules  = ["all-all"]
    }
    http-8080 = {
      ingress_rules = ["http-8080-tcp"]
      egress_rules  = ["all-all"]
    }
    https-443 = {
      ingress_rules = ["https-443-tcp"]
      egress_rules  = ["all-all"]
    }
    https-8443 = {
      ingress_rules = ["https-8443-tcp"]
      egress_rules  = ["all-all"]
    }
    ssh = {
      ingress_rules = ["ssh-tcp"]
      egress_rules  = ["all-all"]
    }
    redis = {
      ingress_rules = ["redis-tcp"]
      egress_rules  = ["all-all"]
    }
    carbon-relay-ng = {
      ingress_rules = ["carbon-line-in-tcp", "carbon-line-in-udp", "carbon-pickle-tcp", "carbon-pickle-udp", "carbon-gui-udp"]
      egress_rules  = ["all-all"]
    }
    cassandra = {
      ingress_rules = ["cassandra-clients-tcp", "cassandra-thrift-clients-tcp", "cassandra-jmx-tcp"]
      egress_rules  = ["all-all"]
    }
    consul = {
      ingress_rules = ["consul-tcp", "consul-cli-rpc-tcp", "consul-webui-tcp", "consul-dns-tcp", "consul-dns-udp", "consul-serf-lan-tcp", "consul-serf-lan-udp", "consul-serf-wan-tcp", "consul-serf-wan-udp"]
      egress_rules  = ["all-all"]
    }
    ntp = {
      ingress_rules = ["ntp-udp"]
      egress_rules  = ["all-all"]
    }
    elasticsearch = {
      ingress_rules = ["elasticsearch-rest-tcp", "elasticsearch-java-tcp"]
      egress_rules  = ["all-all"]
    }
    ipsec-500 = {
      ingress_rules = ["ipsec-500-udp"]
      egress_rules  = ["all-all"]
    }
    ipsec-4500 = {
      ingress_rules = ["ipsec-4500-udp"]
      egress_rules  = ["all-all"]
    }
    kafka = {
      ingress_rules = ["kafka-broker-tcp"]
      egress_rules  = ["all-all"]
    }
    ldaps = {
      ingress_rules = ["ldaps-tcp"]
      egress_rules  = ["all-all"]
    }
    memcached = {
      ingress_rules = ["memcached-tcp"]
      egress_rules  = ["all-all"]
    }
    mongodb = {
      ingress_rules = ["mongodb-27017-tcp", "mongodb-27018-tcp", "mongodb-27019-tcp"]
      egress_rules  = ["all-all"]
    }
    mysql = {
      ingress_rules = ["mysql-tcp"]
      egress_rules  = ["all-all"]
    }
    mssql = {
      ingress_rules = ["mssql-tcp", "mssql-udp", "mssql-analytics-tcp", "mssql-broker-tcp"]
      egress_rules  = ["all-all"]
    }
    nfs = {
      ingress_rules = ["nfs-tcp"]
      egress_rules  = ["all-all"]
    }
    nomad = {
      ingress_rules = ["nomad-http-tcp", "nomad-rpc-tcp", "nomad-serf-tcp", "nomad-serf-udp"]
      egress_rules  = ["all-all"]
    }
    openvpn = {
      ingress_rules = ["openvpn-udp", "openvpn-tcp", "openvpn-https-tcp"]
      egress_rules  = ["all-all"]
    }
    postgresql = {
      ingress_rules = ["postgresql-tcp"]
      egress_rules  = ["all-all"]
    }
    oracle-db = {
      ingress_rules = ["oracle-db-tcp"]
      egress_rules  = ["all-all"]
    }
    puppet = {
      ingress_rules = ["puppet-tcp", "puppetdb-tcp"]
      egress_rules  = ["all-all"]
    }
    rabbitmq = {
      ingress_rules = ["rabbitmq-4369-tcp", "rabbitmq-5671-tcp", "rabbitmq-5672-tcp", "rabbitmq-15672-tcp", "rabbitmq-25672-tcp"]
      egress_rules  = ["all-all"]
    }
    rdp = {
      ingress_rules = ["rdp-tcp", "rdp-udp"]
      egress_rules  = ["all-all"]
    }
    redshift = {
      ingress_rules = ["redshift-tcp"]
      egress_rules  = ["all-all"]
    }
    splunk = {
      ingress_rules = ["splunk-indexer-tcp", "splunk-clients-tcp", "splunk-splunkd-tcp", "splunk-hec-tcp"]
      egress_rules  = ["all-all"]
    }
    squid = {
      ingress_rules = ["squid-proxy-tcp"]
      egress_rules  = ["all-all"]
    }
    storm = {
      ingress_rules = ["storm-nimbus-tcp", "storm-ui-tcp", "storm-supervisor-tcp"]
      egress_rules  = ["all-all"]
    }
    web = {
      ingress_rules = ["http-80-tcp", "http-8080-tcp", "https-443-tcp", "web-jmx-tcp"]
      egress_rules  = ["all-all"]
    }
    winrm = {
      ingress_rules = ["winrm-http-tcp", "winrm-https-tcp"]
      egress_rules  = ["all-all"]
    }
    zipkin = {
      ingress_rules = ["zipkin-admin-tcp", "zipkin-admin-query-tcp", "zipkin-admin-web-tcp", "zipkin-query-tcp", "zipkin-web-tcp"]
      egress_rules  = ["all-all"]
    }
    zookeeper = {
      ingress_rules = ["zookeeper-2181-tcp", "zookeeper-2888-tcp", "zookeeper-3888-tcp", "zookeeper-jmx-tcp"]
      egress_rules  = ["all-all"]
    }
  }
}
