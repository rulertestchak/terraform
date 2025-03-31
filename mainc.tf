resource "google_compute_instance" "default" {
  name         = "e1-micro-vm"
  machine_type = "e1-micro"
  zone         = "us-central1-f"  # Replace with your desired zone
  project      = "beta-ruler" # Replace with your GCP Project ID.  Consider a variable.

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Replace with your desired image
    }
  }

  network_interface {
    network = "default"  # Uses the default VPC network
    access_config {
      # Include this to give the VM a public IP address
    }
  }

  # Optional:  Adding SSH key for login
  metadata = {
    ssh-keys = "your_username:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..." # Replace with your public SSH key
  }


  # Optional:  Tag for firewall rules
  tags = ["http-server", "https-server"]  # Example tags.  Make sure firewall rules allow this.
}

# Output the instance's external IP address
output "instance_external_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
  description = "The external IP address of the instance."
}

# Output the instance's internal IP address
output "instance_internal_ip" {
  value = google_compute_instance.default.network_interface[0].network_ip
  description = "The internal IP address of the instance."
}

# Output the instance name
output "instance_name" {
  value = google_compute_instance.default.name
  description = "The name of the instance."
}