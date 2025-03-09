cluster_name = "eksdemo1"
cluster_service_ipv4_cidr = "172.20.0.0/16"
cluster_version = "1.28"
cluster_endpoint_private_access = false
cluster_endpoint_public_access = true
# 現在はすべてのIPを許可していますが、本番環境では限定すべきです
# 例: cluster_endpoint_public_access_cidrs = ["YOUR_IP/32"]
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

