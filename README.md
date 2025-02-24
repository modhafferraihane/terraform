# Projet Terraform pour AWS EKS

Ce projet Terraform configure et déploie une infrastructure hautement disponible sur AWS dédiée à un cluster Kubernetes (EKS). Il inclut la configuration du backend, des fournisseurs, la création de sous-réseaux publics et privés, la configuration de la sécurité, et l'installation d'outils de monitoring.

## Étapes de Configuration

### 1. Configurer Terraform
- Configurer le backend dans [backend.tf](backend.tf)
- Configurer le fournisseur dans [providers.tf](providers.tf)

### 2. Provisionner une Infrastructure AWS Hautement Disponible
- Créer une passerelle Internet
- Créer 2 sous-réseaux privés
- Créer 2 sous-réseaux publics
- Créer une IP élastique
- Créer une passerelle NAT
- Créer une table de routage privée
- Configurer les groupes de sécurité privés et publics

### 3. Provisionner un Cluster Kubernetes et les Nœuds de Travail
- Créer un cluster EKS
- Créer un groupe de nœuds EKS

### 4. Installer les Outils de Monitoring
- Installer Ingress NGINX via Helm
- Installer Cert Manager via Helm
- Installer Kube-Prometheus-Stack via Helm

### 5. Déployer les Manifests Kubernetes
- Utiliser les fichiers [helm.tf](helm.tf) et [kubernetes.tf](kubernetes.tf) pour déployer les ressources Kubernetes

## Structure du Répertoire

- `.github/workflows/`: Contient les workflows GitHub Actions pour appliquer et détruire l'infrastructure Terraform.
- `.terraform/`: Contient les fichiers de configuration Terraform.
- `kubernetes/`: Contient les manifests et les configurations Helm pour les ressources Kubernetes.
- `modules/`: Contient les modules Terraform pour EKS, IAM, et le réseau.
- `backend.tf`: Configuration du backend Terraform.
- `providers.tf`: Configuration des fournisseurs Terraform.
- `variables.tf`: Variables globales pour Terraform.
- `main.tf`: Fichier principal pour l'orchestration des modules Terraform.
- `outputs.tf`: Définitions des sorties Terraform.

## Utilisation

1. Cloner le dépôt.
2. Configurer les variables nécessaires dans [variables.tf](variables.tf).
3. Initialiser Terraform :
    ```sh
    terraform init
    ```
4. Planifier l'infrastructure :
    ```sh
    terraform plan
    ```
5. Appliquer les changements :
    ```sh
    terraform apply
    ```

## Remarques

- Assurez-vous d'avoir les bonnes permissions AWS configurées.
- Vérifiez les versions des modules et des fournisseurs pour éviter les incompatibilités.

Pour plus de détails, consultez les fichiers de configuration dans le répertoire du projet.