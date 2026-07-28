# Create namespace if not default
resource "kubernetes_namespace_v1" "app_ns" {
  count = var.namespace != "default" ? 1 : 0
  
  metadata {
    name = var.namespace
  }
}

# ConfigMap for Apache index.html
resource "kubernetes_config_map_v1" "apache_config" {
  metadata {
    name      = "${var.app_name}-config"
    namespace = var.namespace
  }

  data = {
    "index.html" = <<-EOF
      <!DOCTYPE html>
      <html>
      <head>
          <title>${var.environment} Environment</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
                  margin: 40px;
                  background-color: #f0f0f0;
              }
              .container {
                  background-color: white;
                  padding: 20px;
                  border-radius: 10px;
                  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
              }
          </style>
      </head>
      <body>
          <div class="container">
              <h1>${var.index_message}</h1>
              <p>Environment: ${upper(var.environment)}</p>
              <p>Server Time: <span id="time"></span></p>
          </div>
          <script>
              document.getElementById('time').textContent = new Date().toLocaleString();
          </script>
      </body>
      </html>
    EOF
  }
}

# Kubernetes Deployment
resource "kubernetes_deployment_v1" "apache" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app     = var.app_name
      env     = var.environment
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
        env = var.environment
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
          env = var.environment
        }
      }

      spec {
        container {
          name  = "apache"
          image = var.apache_image

          port {
            container_port = 80
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/usr/local/apache2/htdocs"
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }

        volume {
          name = "config-volume"
          config_map {
            name = kubernetes_config_map_v1.apache_config.metadata[0].name
          }
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service_v1" "apache" {

  metadata {
    name      = "${var.app_name}-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
      env = var.environment
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = var.service_type
  }
  
  timeouts {
    create = "120m"
  }

}