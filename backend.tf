terraform {
  backend "s3" {
    bucket         = "terraform264200" 
    key            = "global/spp_app/terraform.tfstate"    
    region         = "us-east-1"                           
    dynamodb_table = "terraform-locks264200"            
    encrypt        = true
  }
}
