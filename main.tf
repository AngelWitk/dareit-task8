resource "google_storage_bucket" "t8-terraform-state-file" {
  name          = t8-terraform-state-file
  location      = EU
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "t8-static-site" {
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
  bucket = google_storage_bucket.t8-static-site.name
  role   = "READER"
  entity = "allUsers" 
}

resource "google_storage_bucket_object" "picture" {
  name   = "happy-cloud.jpg"
  source = ".website/happy-cloud.jpg"
  bucket = "t8-static-site"
}

resource "google_storage_bucket_object" "main_page" {
  name   = "index.html"
  source = ".website/index.html"
  bucket = "t8-static-site"
}