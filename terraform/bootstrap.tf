module "nginx_ingress" {
  source = "./modules/nginx-ingress"
}

module "cert_manager" {
  source     = "./modules/cert-manager"
  depends_on = [module.nginx_ingress]
}

module "monitoring" {
  source     = "./modules/monitoring"
  depends_on = [module.nginx_ingress]
}

module "argocd" {
  source     = "./modules/argocd"
  depends_on = [module.nginx_ingress]
}
