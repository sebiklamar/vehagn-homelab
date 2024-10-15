module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  image = {
    version        = "v1.8.1"
    update_version = "v1.8.1" # renovate: github-releases=siderolabs/talos
    schematic      = file("${path.module}/talos/image/schematic.yaml")
  }

  cilium = {
    values  = file("${path.module}/../../k8s/infra/network/cilium/values.yaml")
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
  }

  cluster = {
    name            = "test-verhagn"
    endpoint        = "10.7.4.101"
    gateway         = "10.7.4.1"
    talos_version   = "v1.7.6"
    proxmox_cluster = "iseja-lab"
  }

  nodes = {
    "vehagn-ctrl-01.test.iseja.net" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      vlan_id       = 104
      ip            = "10.7.4.101"
      mac_address   = "BC:24:11:07:04:65"
      vm_id         = 7004101
      cpu           = 2
      # ram_dedicated = 2048
      ram_dedicated = 4096
      # update        = true
    }
    "vehagn-ctrl-02.test.iseja.net" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      vlan_id       = 104
      ip            = "10.7.4.102"
      mac_address   = "BC:24:11:07:04:66"
      vm_id         = 7004102
      cpu           = 2
      # ram_dedicated = 2048
      ram_dedicated = 4096
      # update        = true
    }
    "vehagn-ctrl-03.test.iseja.net" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      vlan_id       = 104
      ip            = "10.7.4.103"
      mac_address   = "BC:24:11:07:04:67"
      vm_id         = 7004103
      cpu           = 2
      # ram_dedicated = 2048
      ram_dedicated = 4096
      # update        = true
    }
    "vehagn-work-01.test.iseja.net" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.7.4.104"
      vlan_id       = 104
      mac_address   = "BC:24:11:07:04:68"
      vm_id         = 7004104
      cpu           = 2
      # ram_dedicated = 2048
      ram_dedicated = 4096
      # update        = true
    }
    "vehagn-work-02.test.iseja.net" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.7.4.105"
      vlan_id       = 104
      mac_address   = "BC:24:11:07:04:69"
      vm_id         = 7004105
      cpu           = 2
      # ram_dedicated = 2048
      ram_dedicated = 4096
      # update        = true
    }
  }

}

module "sealed_secrets" {
  depends_on = [module.talos]
  source     = "./bootstrap/sealed-secrets"

  providers = {
    kubernetes = kubernetes
  }

  // openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout sealed-secrets.key -out sealed-secrets.cert -subj "/CN=sealed-secret/O=sealed-secret"
  cert = {
    cert = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.cert")
    key  = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.key")
  }
}

module "proxmox_csi_plugin" {
  depends_on = [module.talos]
  source     = "./bootstrap/proxmox-csi-plugin"

  providers = {
    proxmox    = proxmox
    kubernetes = kubernetes
  }

  proxmox = var.proxmox
}

module "volumes" {
  depends_on = [module.proxmox_csi_plugin]
  source     = "./bootstrap/volumes"

  providers = {
    restapi    = restapi
    kubernetes = kubernetes
  }
  proxmox_api = var.proxmox
  volumes = {
    pv-test = {
      node = "pve2"
      size = "100M"
    }
    # pv-sonarr = {
    #   node = "cantor"
    #   size = "4G"
    # }
    # pv-radarr = {
    #   node = "cantor"
    #   size = "4G"
    # }
    # pv-lidarr = {
    #   node = "cantor"
    #   size = "4G"
    # }
    # pv-prowlarr = {
    #   node = "euclid"
    #   size = "1G"
    # }
    # pv-torrent = {
    #   node = "euclid"
    #   size = "1G"
    # }
    # pv-remark42 = {
    #   node = "euclid"
    #   size = "1G"
    # }
    # pv-keycloak = {
    #   node = "euclid"
    #   size = "2G"
    # }
    # pv-jellyfin = {
    #   node = "euclid"
    #   size = "12G"
    # }
    # pv-netbird-signal = {
    #   node = "abel"
    #   size = "1G"
    # }
    # pv-netbird-management = {
    #   node = "abel"
    #   size = "1G"
    # }
    # pv-plex = {
    #   node = "abel"
    #   size = "12G"
    # }
    # pv-prometheus = {
    #   node = "abel"
    #   size = "10G"
    # }
    # pv-single-database = {
    #   node = "euclid"
    #   size = "4G"
    # }
  }
}
