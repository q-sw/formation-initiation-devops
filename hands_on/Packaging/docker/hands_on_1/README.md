# TP Container & Docker: Créer sa première image
## Enoncé:
Développer le Dockerfile permettant d’afficher une page WEB avec les caractéristiques suivantes: 
- images de base nginx
- héberger une page index.html personnelle

Construire l’image et démarré un container avec cette image et afficher la page.  
Publier l’image sur le Docker hub ou une autre registry

## Correction
Le dockerfile est relativement simple (cf: code ci-dessous ou le fichier [Dockerfile](Dockerfile))

```
FROM nginx:1.20

COPY index.html /usr/share/nginx/html
```

Pour construire l'image, on utilise la commande:
```
docker build -t monimage:1.0 -f Dockerfile .
```
Pour publier l'image sur le DockerHUB, il faut bien évidement un compte sur le DockerHub, et créer son premier repo. La suite se passe sur notre poste en ligne de commande
```
docker login -u <DockerHub Account>
```
> remplace "<DockerHub Account>" par votre compte
> il vous sera ensuite demande votre mot de passe

la dernière étape est de pousser l'image sur DockerHub
```
docker tag monimage:1.0 <DockerHub Account>/monimage:1.0
docker push <DockerHub Account>/monimage:1.0
```

Vous pouvez réaliser l'ensemble des actions à partir du fichier [makefile](makefile).  
Pour cela, il faut simplement remplir la variable **"DOCKER_ACCOUNT"** à la ligne 1 et la variable **"tag"** à la ligne deux. 

ensuite jouer les commandes suivantes:
```
#Construire l'image
make build-image

#Se connecter au Docker Hub
make docker-login

#Pousser l'image
make push-image
```