provider "aws" {
  region = "us-east-1" 
}

# Aquí definimos la variable para conectar con GitHub
variable "github_token" {
  description = "Token de acceso personal de GitHub"
  type        = string
  sensitive   = true
}

# Esta parte crea la conexión on Amplify
resource "aws_amplify_app" "hola_mundo" {
  name       = "mi-proyecto"
  repository = "https://github.com/JoannaMonserrat/practica-react-aws" # <--- ¡CAMBIA ESTO!
  oauth_token = var.github_token

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd mi-proyecto && npm ci
        build:
          commands:
            - cd mi-proyecto && npm run build
      artifacts:
        baseDirectory: mi-proyecto/dist  # <--- Muy importante añadir el prefijo aquí también
        files:
          - '**/*'
      cache:
        paths:
          - mi-proyecto/node_modules/**/*
  EOT
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.hola_mundo.id
  branch_name = "main"
}