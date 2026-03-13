# Apple Global Product Sales – Azure Data Intelligence Platform
## Description du projet

Ce projet consiste à concevoir une plateforme complète d’analyse des ventes Apple à l’échelle mondiale en utilisant les services Microsoft Azure, un pipeline ETL, un modèle décisionnel en étoile, et un dashboard Power BI pour produire des analyses métiers.

L’objectif est de construire une architecture Data moderne (Data Pipeline + Data Warehouse + BI) permettant de transformer des données brutes en indicateurs stratégiques pour la prise de décision.

## Dataset utilisé

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

## Étape préliminaire : Étude des services Azure
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
- Microsoft Fabric (OneLake) 
- Azure Data Lake Storage (ADLS) Gen2
- Comptes de Stockage Azure (Blob)
- Azure Data Factory (ADF)
- Azure Functions
- Azure Databricks
- Azure Synapse Analytics
- Azure Data Explorer (Kusto /ADX) 
- Azure Stream Analytics
- Power BI Premium
- Power Apps & Power Automate


## Architecture du projet
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
## Pipeline de traitement des données
### 1- Azure Blob Storage

Utilisé pour le stockage initial des données brutes.

**Actions réalisées :** Upload du fichier CSV -> Organisation dans une Landing Zone

**Structure :**
```
blob-storage
   └── landing-zone
          └── appelglobalsales_dataset.csv
```
### 2- Azure Data Factory
Azure Data Factory est utilisé pour orchestrer le pipeline de données.

**Fonctionnalités utilisées:**

- Pipeline d’ingestion
- Déclenchement du package SSIS
- Gestion des dépendances
- Automatisation du flux de données

**Pipeline :**
- Lecture du fichier depuis Blob Storage
- Déclenchement du processus ETL SSIS
- Chargement dans SQL Server

### 3- SSIS – Processus ETL
SQL Server Integration Services est utilisé pour le traitement des données.

**Étapes ETL:**

Extraction
- Lecture des données depuis le fichier CSV.

Transformation
- Nettoyage des données
- Transformation des formats

Chargement
- Chargement dans SQL Server (Staging) puis vers le Data Warehouse.

## Modélisation du Data Warehouse
Un modèle en étoile (Star Schema) a été créé dans SQL Server.

**Table de faits**: Fact_Sales
**Tables de dimensions**: Dim_Date, Dim_Product, Dim_Geography, Dim_Channel, DimCustomerSegment


## Power BI – Visualisation
**Mesures (KPIs)**

Les mesures suivantes ont été créées :
- Total Revenue
- Total Units Sold
- Average Discount
- Return Rate %
- Revenue YoY Growth
- Revenue by Region
- Channel Performance

**Analyses métier réalisées**

Le dashboard permet de répondre à plusieurs questions business:

- Analyse de la performance géographique des ventes : Quel pays génère le plus de revenu ?
- Comparaison des ventes entre produits Apple selon les régions : Quelle catégorie domine par région ?
- Comparaison Online vs Retail vs Partner : Quel canal est le plus performant ?
- Analyse de l’impact des discounts sur les ventes : Les remises augmentent-elles le volume ?
- Comparaison entre 'Consumer', 'Corporate' et 'Education' : Quel segment client est le plus rentable ?
- Identification des périodes de forte vente : Analyse saisonnière
- Identification des produits avec le plus de retours : Taux de retour par produit

## Installation / Utilisation

**1- Cloner le projet**
```
git clone https://github.com/JanahAsmae/Azure-DATA-Full-Stack-Apple-Global-Sales-Intelligence-Platform.git
```
**2- Charger le dataset**

Uploader le fichier CSV dans Azure Blob Storage.

**3- Exécuter le pipeline Data Factory**
- Lancer le pipeline d’ingestion
- Déclencher le package SSIS

**4- Charger le modèle dans SQL Server**

Créer les tables Star Schema.

**5- Ouvrir Power BI**

Importer le fichier : dashboard.pbix
