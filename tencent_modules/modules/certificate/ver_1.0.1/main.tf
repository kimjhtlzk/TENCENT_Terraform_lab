resource "tencentcloud_ssl_certificate" "ssl" {
  for_each = var.certificates

  name = each.key
  type = each.value.type

  cert = trimspace(file("${path.module}/certs/${each.value.cert}"))
  key  = trimspace(file("${path.module}/certs/${each.value.key}"))

  lifecycle {
    ignore_changes = [cert, key]
  }
}
