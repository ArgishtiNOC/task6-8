resource "aws_ecrpublic_repository" "ecr_erpo" {
  repository_name = "task4"

  catalog_data {
    about_text        = "About Text"
    description       = "Description"
    operating_systems = ["Linux"]
    
  }

  tags = {
    env = "production"
  }
}