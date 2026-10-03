# En Windows (Docker Desktop):
# docker_host = "npipe:////.//pipe//docker_engine"

ambientes = {
  dev = {
    puerto_web = 4001
    puerto_api = 4002
    puerto_bd  = 4003
  }
  qa = {
    puerto_web = 5001
    puerto_api = 5002
    puerto_bd  = 5003
  }
}
