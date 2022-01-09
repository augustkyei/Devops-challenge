
module "eks_flux_install" {
  source = "./terraform-provider-flux-main/examples/github"
  github_owner = var.github_owner
  github_token = var.github_token
  target_path  = "${var.environment}-${var.cluster_name}"
  repository_name = "si-index-flux-system"
}


#resource "null_resource" "script" {
#
#  provisioner "local-exec" {
#    command = "./script.sh"
#    interpreter = ["bash"]
#  }
#  depends_on = [module.eks_flux_install]
#}