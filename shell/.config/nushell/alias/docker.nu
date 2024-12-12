def dlz [] {
   lazydocker
} 

def dps [] {
   docker ps | detect columns
} 
def dst [] {
   docker stop
} 

# System
def dsp [] {
   docker system prune
} 
def dcp [] {
   docker container prune
} 
def dvp [] {
   docker volume prune
} 

# Images
def dimg [] {
   docker images | detect columns
} 
def drmi [] {
   docker rmi
} 
def drmia [] {
   docker rmi (docker images -a -q | str join " ")
} 

# enter container
def dent [container_name] {
  docker exec -it $container_name bash
}

def dentsh [container_name] {
  docker exec -it $container_name sh
}

# Compose
def dcd [] {
   docker compose down
} 
def dcu [] {
   docker compose up
} 
def dcr [] {
   docker compose down and docker compose up
} 
def dcub [] {
   docker compose up --build
} 
def dcrb [] {
   docker compose down and docker compose up --build
} 
def dcud [] {
   docker compose up -d
} 
def dcrd [] {
   docker compose down and docker compose up -d
} 
def dcubd [] {
   docker compose up -d --build
} 
def dcrbd [] {
   docker compose down and docker compose up --build -d
} 
def dcexe [] {
   docker compose exec
} 
def dcps [] {
   docker compose ps | detect columns
} 
def dcat [] {
   docker compose attach
} 

def dcent [container_name] {
  docker compose exec -it $container_name bash
}

def dcentsh [container_name] {
  docker compose exec -it $container_name sh
}