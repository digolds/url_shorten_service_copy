output "role_obj" {
  value = module.iam_roles.roles_map[var.role_name]
}
