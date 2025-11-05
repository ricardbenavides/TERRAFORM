

# PASO 1: Creación de Grupo de Recursos y Redes

# Creación del Grupo de Recursos

module "resource_group" {
  source   = "./modules/resource_group"
  name     = "RG_${var.country}_${var.customer}_${var.environment}"
  location = var.primary_location
  tags     = local.tags_default
}

# Creación de Redes Virtuales

# VNET 

module "virtual_network_dmz" {
  source         = "./modules/virtual_network"
  resource_group = "RG_${var.country}_${var.customer}_${var.environment}"
  location       = var.primary_location
  tags           = local.tags_default
  name           = "VNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  address_space  = ["10.${var.environment == "PROD" ? "2" : "12"}.${var.red}.0/24"]
  depends_on     = [module.resource_group]
}

module "virtual_network_subnet_dmz" {
  source               = "./modules/virtual_network_subnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  name                 = "SUBNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  address_space        = ["10.${var.environment == "PROD" ? "2" : "12"}.${var.red}.0/28"]
  depends_on           = [module.resource_group, module.virtual_network_dmz]
}

module "virtual_network_sql" {
  source         = "./modules/virtual_network"
  resource_group = "RG_${var.country}_${var.customer}_${var.environment}"
  location       = var.primary_location
  tags           = local.tags_default
  name           = "VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  address_space  = ["10.${var.environment == "PROD" ? "3" : "13"}.${var.red}.0/24"]
  depends_on     = [module.resource_group]
}

module "virtual_network_subnet_sql" {
  source               = "./modules/virtual_network_subnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  name                 = "SUBNET_${var.country}_${var.customer}_SQL_${var.environment}"
  address_space        = ["10.${var.environment == "PROD" ? "3" : "13"}.${var.red}.0/28"]
  depends_on           = [module.virtual_network_sql, module.virtual_network_subnet_dmz]
}

module "virtual_network_etl" {
  source         = "./modules/virtual_network"
  resource_group = "RG_${var.country}_${var.customer}_${var.environment}"
  location       = var.primary_location
  tags           = local.tags_default
  name           = "VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  address_space  = ["10.${var.environment == "PROD" ? "4" : "14"}.${var.red}.0/24"]
  depends_on     = [module.resource_group]
}

module "virtual_network_subnet_etl" {
  source               = "./modules/virtual_network_subnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  name                 = "SUBNET_${var.country}_${var.customer}_ETL_${var.environment}"
  address_space        = ["10.${var.environment == "PROD" ? "4" : "14"}.${var.red}.0/28"]
  depends_on           = [module.virtual_network_etl, module.virtual_network_subnet_sql]
}

module "virtual_network_sftp" {
  source         = "./modules/virtual_network"
  resource_group = "RG_${var.country}_${var.customer}_${var.environment}"
  location       = var.primary_location
  tags           = local.tags_default
  name           = "VNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  address_space  = ["10.${var.environment == "PROD" ? "5" : "15"}.${var.red}.0/24"]
  depends_on     = [module.resource_group]
}

module "virtual_network_subnet_sftp" {
  source               = "./modules/virtual_network_subnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  name                 = "SUBNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  address_space        = ["10.${var.environment == "PROD" ? "5" : "15"}.${var.red}.0/28"]
  depends_on           = [module.virtual_network_sftp, module.virtual_network_subnet_etl]
}

# Peering

module "peering_dmz_vnet_sql" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  name                 = "Peer_DMZ_Vnet_to_VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  vnet_id              = module.virtual_network_sql.vnet_id
  depends_on           = [module.virtual_network_subnet_dmz, module.virtual_network_subnet_sql]
}

module "peering_sql_vnet_dmz" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  name                 = "Peer_SQL_Vnet_to_VNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  vnet_id              = module.virtual_network_dmz.vnet_id
  depends_on           = [module.virtual_network_subnet_dmz, module.virtual_network_subnet_sql, module.peering_dmz_vnet_sql]
}

module "peering_etl_vnet_sql" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  name                 = "Peer_ETL_Vnet_to_VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  vnet_id              = module.virtual_network_sql.vnet_id
  depends_on           = [module.virtual_network_subnet_etl, module.virtual_network_subnet_sql]
}

module "peering_sql_vnet_etl" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  name                 = "Peer_SQL_Vnet_to_VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  vnet_id              = module.virtual_network_etl.vnet_id
  depends_on           = [module.virtual_network_subnet_etl, module.virtual_network_subnet_sql, module.peering_etl_vnet_sql]
}

module "peering_etl_vnet_sftp" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  name                 = "Peer_ETL_Vnet_to_VNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  vnet_id              = module.virtual_network_sftp.vnet_id
  depends_on           = [module.virtual_network_subnet_etl, module.virtual_network_subnet_sftp]
}

module "peering_sftp_vnet_etl" {
  source               = "./modules/vnet_peering_vnet"
  resource_group       = "RG_${var.country}_${var.customer}_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  name                 = "Peer_SFTP_Vnet_to_VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  vnet_id              = module.virtual_network_etl.vnet_id
  depends_on           = [module.virtual_network_subnet_etl, module.virtual_network_subnet_sftp]
}

# Azure SQL Database

data "azurerm_subnet" "subnet_sql" {
  name                 = "SUBNET_${var.country}_${var.customer}_SQL_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SQL_${var.environment}"
  resource_group_name  = "RG_${var.country}_${var.customer}_${var.environment}"
  depends_on           = [module.virtual_network_subnet_sql, module.virtual_network_subnet_etl]
}

module "azure_sql_database" {
  source                              = "./modules/azure_sql"
  resource_group                      = "RG_${var.country}_${var.customer}_${var.environment}"
  location                            = var.primary_location
  tags                                = local.tags_default
  name                                = lower("sqlserver-${var.country}-${var.customer}-emx-${var.environment}")
  database_name                       = upper("EMX6.${var.country}.${var.customer}.${var.environment}")
  administrator_login_az_sql          = var.administrator_login_az_sql
  administrator_login_password_az_sql = var.administrator_login_password_az_sql
  subnet_id_sql                       = data.azurerm_subnet.subnet_sql.id
  depends_on                          = [module.virtual_network_subnet_sql, module.virtual_network_subnet_etl]
}


# Azure App Service

data "azurerm_subnet" "subnet_dmz" {
  name                 = "SUBNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_DMZ_${var.environment}"
  resource_group_name  = "RG_${var.country}_${var.customer}_${var.environment}"
  depends_on           = [module.virtual_network_subnet_dmz, module.azure_sql_database]
}

module "azure_app_service" {
  source         = "./modules/app_service"
  name           = "AS-PLAN-${var.country}-EMX-${var.customer}-${var.environment}"
  resource_group = "RG_${var.country}_${var.customer}_${var.environment}"
  location       = var.primary_location
  tags           = local.tags_default
  os_type        = "Windows"
  sku_name       = "S1"
  name_ui        = "AS-${var.country}-${var.customer}-EMX-UI-${var.environment}"
  name_api       = "AS-${var.country}-${var.customer}-EMX-API-${var.environment}"
  name_cs        = "AS-${var.country}-${var.customer}-EMX-CS-${var.environment}"
  subnet_id_api  = data.azurerm_subnet.subnet_dmz.id
  app_customer   = lower("${var.customer}")
  depends_on     = [module.virtual_network_subnet_dmz, module.azure_sql_database]
}

# Azure VM Pentaho

data "azurerm_subnet" "subnet_etl" {
  name                 = "SUBNET_${var.country}_${var.customer}_ETL_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_ETL_${var.environment}"
  resource_group_name  = "RG_${var.country}_${var.customer}_${var.environment}"
  depends_on           = [module.virtual_network_subnet_etl, module.azure_app_service]
}

module "azure_vm_pentaho" {
  source                           = "./modules/vm_pentaho"
  name                             = "VM-${var.country}-EMX-${var.customer}-PENTAHO-${var.environment}"
  resource_group                   = "RG_${var.country}_${var.customer}_${var.environment}"
  location                         = var.primary_location
  red                              = var.red
  environment                      = var.environment
  tags                             = local.tags_default
  subnet_id_etl                    = data.azurerm_subnet.subnet_etl.id
  administrator_login_etl          = var.administrator_login_etl
  administrator_login_password_etl = var.administrator_login_password_etl
  size_vm_pentaho                  = var.size_vm_pentaho
  storage_type_os_etl              = var.storage_type_os_pentaho
  depends_on                       = [module.virtual_network_subnet_etl, module.azure_app_service]
}


# Azure VM SFTP

data "azurerm_subnet" "subnet_sftp" {
  name                 = "SUBNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  virtual_network_name = "VNET_${var.country}_${var.customer}_SFTP_${var.environment}"
  resource_group_name  = "RG_${var.country}_${var.customer}_${var.environment}"
  depends_on           = [module.virtual_network_subnet_sftp, module.azure_vm_pentaho]
}

module "azure_vm_sftp" {
  source                            = "./modules/vm_sftp"
  name                              = "VM-${var.country}-EMX-${var.customer}-SFTP-${var.environment}"
  resource_group                    = "RG_${var.country}_${var.customer}_${var.environment}"
  location                          = var.primary_location
  environment                       = var.environment
  red                               = var.red
  tags                              = local.tags_default
  subnet_id_sftp                    = data.azurerm_subnet.subnet_sftp.id
  administrator_login_sftp          = var.administrator_login_sftp
  administrator_login_password_sftp = var.administrator_login_password_sftp
  size_vm_sftp                      = var.size_vm_sftp
  storage_type_os_sftp              = var.storage_type_os_sftp
  depends_on                        = [module.virtual_network_subnet_sftp, module.azure_vm_pentaho]
}
