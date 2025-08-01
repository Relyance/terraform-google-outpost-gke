terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.3"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.3"
    }
  }

  required_version = "~> 1.9"
}
