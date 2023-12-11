resource "google_compute_instance" "dareit-vm-ci" {
  name         = "dareit-vm-tf-ci"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_storage_bucket" "static-site" {
  project       = "bamboo-creek-401412" 
  name          = "t8-static-site"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


resource "google_storage_bucket_object" "t8-static-site" {
  name   = "index.html"
  source = "website/index.html"
  bucket = google_storage_bucket.t8-static-site.name
}

resource "google_storage_bucket_access_control" "t8-static-site" {
  bucket = google_storage_bucket.t8-static-site.id
  role   = "READER"
  entity = "allUsers"

}

resource "google_storage_bucket_object" "file" {
  name   = "happy-cloud.jpg"
  source = "website/happy-cloud.jpg"
  bucket = google_storage_bucket.t8-static-site.name
}

resource "google_storage_bucket_object" "url" {
  name   = "url_address"
  source = "website/url_address"
  bucket = google_storage_bucket.t8-static-site.name
}