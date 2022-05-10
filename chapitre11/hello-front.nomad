job "hello-app" {
  datacenters = ["dc1"]
  group "hello-front" {
    count = 2
    network {
      port "web" {
        static = 8080
        to = 5000
      }
    }
    task "flask-app" {
      driver = "docker"
      config {
        image = "flask-app:local"
        ports = ["web"]
      }
    }
  }
}
