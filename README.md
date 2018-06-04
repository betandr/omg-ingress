# Example Container with Kubernetes Ingress Controller.

```
YOU ARE STANDING AT THE END OF A ROAD BEFORE A SMALL BRICK BUILDING. AROUND YOU IS A FOREST.
A SMALL STREAM FLOWS OUT OF THE BUILDING AND DOWN A GULLY.
```

Simple Hello, World! container sample used with a Kubernetes Ingress Controller.
Implemented with the Python 3 [Flask](http://flask.pocoo.org/) microframework
and running with [Green Unicorn](http://gunicorn.org/) Python WSGI HTTP Server.

If you don't want to actually run the container locally (it's only a Hello, World!
one), skip to the
[Nginx Kubernetes Ingress Controller](#creating-an-nginx-kubernetes-ingress-controller) section

## Run Locally
You _can_ run this locally if you wish to but it's already pushed to Docker Hub,
see [Building & Deployment](#building--deployment).

### 1. Create a virtualenv, install dependencies:
```
python3 -m venv env
. env/bin/activate
pip3 install -r requirements.txt
```
### 2. Run the service:
```
python3 app/hello.py
```

### 3. Visit the application at http://localhost:5000.

## Tests
```
pytest
```

## Building & Deployment

This app is provided as with a Dockerfile which is used to build a container.
This should then be pushed to a container registry.

This container is already pushed to the
[betandr/hello-world repo](https://hub.docker.com/r/betandr/hello-world/) at
Docker Hub and this container is used in this example.

## Creating an Nginx Kubernetes Ingress Controller

Now we can create the ingress controller for this Hello, World! container.

### Create Default Backend

```
kubectl create -f https://raw.githubusercontent.com/kubernetes/contrib/master/ingress/controllers/nginx/examples/default-backend.yaml
```
```
kubectl expose rc default-http-backend \
  --port=80 \
  --target-port=8080 \
  --name=default-http-backend
```

### Generate Crypto (optional)
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout selfsigned.key \
  -out selfsigned.crt
```
```
openssl dhparam -out dhparam.pem 2048
```

### Set Kubernetes Crypto Secrets
```
kubectl create secret tls tls-certificate \
  --key selfsigned.key \
  --cert selfsigned.crt
```
```
kubectl create secret generic tls-dhparam \
  --from-file=dhparam.pem
```

### Add Access for Role (if using RBAC)
```
kubectl apply -f rbac.yaml
```

### Create Ingress Controlleer
```
kubectl create \
  -f k8s/nginx-ingress-controller_deployment.yaml \
  -f k8s/nginx-ingress-controller_service.yaml
```

### Check Running Services
```
kubectl get services | grep nginx
```

### Check Running Pods
```
kubectl get pods | grep nginx
```

### Create Application
```
kubectl create \
  -f k8s/hello-world_deployment.yaml \
  -f k8s/hello-world_service.yaml \
  -f k8s/hello-world_ingress.yaml
```

### Check Application Ingress
```
kubectl describe ingress hello-world
```
