resource "google_container_cluster" "k8s-assignment-cluster-1" {
  name     = "k8s-assignment-cluster-1"
  location = var.location

  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-small"
    disk_size_gb = 20
    disk_type    = "pd-standard"
  }

}