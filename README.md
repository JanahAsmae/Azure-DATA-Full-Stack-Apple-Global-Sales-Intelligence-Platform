# Apple Global Product Sales – Azure Data Intelligence Platform
### Description du projet

Ce projet consiste à concevoir une plateforme complète d’analyse des ventes Apple à l’échelle mondiale en utilisant les services Microsoft Azure, un pipeline ETL, un modèle décisionnel en étoile, et un dashboard Power BI pour produire des analyses métiers.

L’objectif est de construire une architecture Data moderne (Data Pipeline + Data Warehouse + BI) permettant de transformer des données brutes en indicateurs stratégiques pour la prise de décision.

### Dataset utilisé

**Nom :** Apple Global Product Sales Dataset
**Contenu :**
- 📄 11 500 transactions
- 🌍 47 pays
- 🏙 514+ villes
- 📦 43 produits Apple
- 📑 27 colonnes
- 📅 Période : 2022 – 2024
**Fichier source :**
```
appelglobalsales_dataset.csv
```
Ce dataset contient les informations de vente comme :
- Date de vente
- Produit
- Pays / ville
- Canal de vente
- Quantité vendue
- Prix
- Remise
- Revenus
- Retours produits
- Segment client

### Étape préliminaire : Étude des services Azure
Avant l’implémentation technique, une étude complète de l’écosystème Azure Data a été réalisée.
**Document :**
```
azure_repport-2.pdf
```
**Objectif de cette étude**
- Comprendre l’ensemble des services Azure pour la Data
- Comparer les solutions stockage, ingestion, traitement et visualisation
- Justifier les choix d’architecture utilisés dans ce projet

**Services étudiés**

### Architecture du projet
```
                Source Data
                    │
                    │
           appelglobalsales_dataset.csv
                    │
                    ▼
        Azure Blob Storage (Landing Zone)
                    │
                    │
                    ▼
           Azure Data Factory
        (Pipeline d’ingestion + orchestration)
                    │
                    │
                    ▼
               SSIS (ETL)
        - Nettoyage
        - Transformation
        - Normalisation
                    │
                    │
                    ▼
            SQL Server (Staging)
                    │
                    │
                    ▼
        Data Warehouse (Star Schema)
                    │
                    │
                    ▼
               Power BI
        Dashboard & Business Insights
```
