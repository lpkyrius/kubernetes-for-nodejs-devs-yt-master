docker login 

# rodar na pasta raiz do projeto
docker build -t app \
    nodejs-with-postgres-api-example

docker image ls | grep postgres

# cria um apelido para a imagem, com o usuario do dockerhub/repositorio
docker tag app lpkyrius/nodejs-with-postgres-api-example 
# sobe para o dockerhub
docker push lpkyrius/nodejs-with-postgres-api-example 

# ----
minikube start 
minikube dashboard 

kubectl get nodes 
kubectl describe nodes 

# pasta kubeconfig
kubectl create -f postgres-sts.json 

kubectl get statefulset 

# pod: where the container is running
kubectl get pod 
kubectl logs postgres-0

kubectl describe sts postgres
kubectl describe pod postgres-0

kubectl create -f postgres-svc.json 
kubectl get svc
kubectl describe service postgres-svc
# after this last command above I must see the 3rd last line (probably) as:
# "Endpoints:         10.244.0.5:5432" or any IP address
# If I have a timeout in the service, probably it could not find the endpoints

kubectl create -f api-deployment.json 
kubectl get deploy
kubectl describe deploy api-heroes
kubectl get pod -w # keeps showing, observing... 
kubectl get pod 
# NAME                          READY   STATUS    RESTARTS   AGE
# api-heroes-859556f54f-g6qz6   1/1     Running   0          41s
# api-heroes-859556f54f-hc5qh   1/1     Running   0          41s
# api-heroes-859556f54f-hm78l   1/1     Running   0          41s
# api-heroes-859556f54f-lnznl   1/1     Running   0          41s
# postgres-0                    1/1     Running   0          12m
kubectl describe pod api-heroes-859556f54f-g6qz6
kubectl logs api-heroes-859556f54f-g6qz6
kubectl logs -f api-heroes-859556f54f-g6qz6 # keeps showing, observing...

kubectl apply -f api-deployment.json

kubectl create -f api-svc.json 
kubectl get svc
# NAME             TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# api-heroes-svc   LoadBalancer   10.108.184.7    <pending>     4000:32515/TCP   25s <<< <pending> because we're using minikube, for cloud services we'd have an IP address here
# kubernetes       ClusterIP      10.96.0.1       <none>        443/TCP          78m
# postgres-svc     ClusterIP      10.108.64.201   <none>        5432/TCP         46m

#  to show the endpoints:
kubectl describe svc

#  get the IP and we can use the result with, e.g. http://127.0.0.1:51580/documentation
#  using it on browser or in run.sh
minikube service api-heroes-svc --url 
# http://127.0.0.1:51580
# ❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.

#  limpa mas mantém o storage
kubectl delete -f .
kubectl create -f .

# limpa tudo, até o storage
minikube delete