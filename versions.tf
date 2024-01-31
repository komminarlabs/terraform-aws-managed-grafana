terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    grafana = {
      source = "grafana/grafana"
    }
    okta = {
      source = "okta/okta"
    }
    influx = {
      source = "schubergphilis/influx"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
