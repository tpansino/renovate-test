tfmigrate {
  migration_dir = "migrations"

  history {
    storage "s3" {
      bucket  = "os-security-portal-global-us-west-2-terraform-state"
      key     = "security-portal-global/migrations.json"
      region  = "us-west-2"
      profile = "security-portal-global-ops"
    }
  }
}
