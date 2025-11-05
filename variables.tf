// Variables para nombres de Recursos
variable "country" {
  description = "Codigo País según dominios en internet: AR, CL, MX"
  type        = string
}

variable "environment" {
  description = "Ambiente a desplegar: PROD, HOMO, DESA, POC"
  type        = string
}

variable "customer" {
  description = "Cliente: CLA, HITES, ABCDIN, ITAU, AVN, GNP"
  type        = string
}

// Variables para Tags

variable "pais" {
  description = "Tag Pais del cliente"
  type        = string
}

variable "cliente" {
  description = "Tag Nombre del cliente"
  type        = string
}

variable "ambiente" {
  description = "Tag Entorno del recurso: produccion, homologacion, desarrollo, poc"
  type        = string
}

variable "area" {
  description = "Tag Area responsable del recurso"
  type        = string
}

variable "owner" {
  description = "Tag Responsable del recurso"
  type        = string
}

variable "clasificacion" {
  description = "Tag clasificación de información del activo"
  type        = string
}

// Otras
variable "red" {
  description = "Red de la VNET: 10.red1.x.0 / 10.red2.x.0"
  type        = string
}

variable "primary_location" {
  description = "Ubicación del recurso en Azure región Primaria"
  type        = string
}

variable "secondary_location" {
  description = "Ubicación del recurso en Azure región Secundaria"
  type        = string
}

variable "administrator_login_az_sql" {
  description = "Usuario administrador Azure SQL Database"
  type        = string
}

variable "administrator_login_password_az_sql" {
  description = "Clave administrador Azure SQL Database"
  type        = string
}

variable "administrator_login_etl" {
  description = "Usuario administrador VM ETL"
  type        = string
}

variable "administrator_login_password_etl" {
  description = "Clave administrador VM ETL"
  type        = string
}

variable "size_vm_pentaho" {
  description = "VM size etl"
  type        = string
}

variable "storage_type_os_pentaho" {
  description = "OS type storage etl"
  type        = string
}




variable "administrator_login_sftp" {
  description = "Usuario administrador VM SFTP"
  type        = string
}

variable "administrator_login_password_sftp" {
  description = "Clave administrador VM SFTP"
  type        = string
}

variable "size_vm_sftp" {
  description = "VM size SFTP"
  type        = string
}

variable "storage_type_os_sftp" {
  description = "OS type storage SFTP"
  type        = string
}
