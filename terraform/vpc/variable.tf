locals {
  terraform = "gitlab.com/shoukoo/rea/terraform/${basename(path.cwd)}"
}

provider aws {
  region  = "ap-southeast-2"
  profile = "production"
}
