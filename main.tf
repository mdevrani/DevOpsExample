terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker",
      version = "3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_container" "mysql" {
  image = "mysql:8.0"
  name  = "mysql"
  ports {
    internal = 3306
    external = 3306
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  env = [
    "MYSQL_ROOT_PASSWORD=root",
    "MYSQL_DATABASE=testDb",
    "MYSQL_PASSWORD=root",
  ]
}

resource "docker_image" "spring_app" {
  name = "spring-boot-app"
  build {
    context = "${path.module}/"
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "spring_app" {
  image = "spring-boot-app"
  name  = docker_image.spring_app.name
  ports {
    internal = 8080
    external = 8080
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  env = [
    "SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/testDb?createDatabaseIfNotExist=true",
    "SPRING_DATASOURCE_USERNAME=root",
    "SPRING_DATASOURCE_PASSWORD=root",
    "SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.MySQLDialect",
    "SPRING_JPA_HIBERNATE_DDL_AUTO=update"
  ]
}