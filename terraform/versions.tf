terraform {
  required_version = ">= 0.15.1"

  backend "remote" {
    organization = "steve727"

    workspaces {
      name = "devops-lab"
    }
  }
  
  required_providers {

    # https://github.com/terraform-providers/terraform-provider-azurerm/releases
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.56.0"
    }

    # https://github.com/terraform-providers/terraform-provider-azuread/releases
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }

    # https://github.com/hashicorp/terraform-provider-kubernetes/releases
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.1.0"
    }

    # https://github.com/hashicorp/terraform-provider-helm/releases
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 2.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#credentials-config
provider "kubernetes" {
  host                   = module.aks.full_object.kube_admin_config[0].host
  client_certificate     = base64decode(module.aks.full_object.kube_admin_config[0].client_certificate)
  client_key             = base64decode(module.aks.full_object.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(module.aks.full_object.kube_admin_config[0].cluster_ca_certificate)
}

# https://registry.terraform.io/providers/hashicorp/helm/latest/docs#credentials-config
provider "helm" {
  kubernetes {
    host                   = module.aks.full_object.kube_admin_config[0].host
    client_certificate     = base64decode(module.aks.full_object.kube_admin_config[0].client_certificate)
    client_key             = base64decode(module.aks.full_object.kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(module.aks.full_object.kube_admin_config[0].cluster_ca_certificate)
  }
}
