# Configure the Google Cloud Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"  # Or a more recent version
    }
  }
}

# Configure the Google Cloud Provider with your Project ID and Region
provider "google" {
  project = "bta-ruler"  # Replace with your GCP Project ID
  region  = "us-central1"   # Replace with your desired region.  Consider using a variable for this.
}

# Create the Google Cloud Storage bucket
resource "google_storage_bucket" "beta_ruler" {
  name          = "beta-ruler"
  location      = "US"   # Replace with the desired bucket location.  Consider using a variable for this.
  force_destroy = false  # Set to true to allow bucket deletion even with objects in it.  BE CAREFUL!

  # Optional settings - consider enabling these for production:

  # Versioning
  versioning {
    enabled = false # Enable versioning if you want to keep versions of your files
  }

  # Uniform Bucket-Level Access (Recommended)
  uniform_bucket_level_access = true


  # Bucket Lifecycle Rules (example - delete old versions)
  /*
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  # Delete objects older than 30 days
      matches_storage_class = ["STANDARD", "NEARLINE", "COLDLINE"]  # Limit to certain storage classes. This is important as ARCHIVE is generally immutable and will error out on DELETE
    }
  }
  */

  # Prevent public access at the bucket level (Recommended)
  #  This prevents objects from being made public accidentally
  /*
  bucket_policy_only = true
  */

}

# Output the bucket name
output "bucket_name" {
  value = google_storage_bucket.beta_ruler.name
}

# Output the bucket URL
output "bucket_url" {
  value = "gs://${google_storage_bucket.beta_ruler.name}"
}