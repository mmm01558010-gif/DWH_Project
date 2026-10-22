# SQL Data Warehouse Project

## 📌 Overview

This project focuses on building a modern Data Warehouse using SQL Server. It demonstrates the process of collecting, transforming, and organizing data from multiple sources to support data analysis and reporting.

The project follows a Medallion Architecture (Bronze, Silver, and Gold layers) to organize data throughout the ETL process.

## 🎯 Project Objectives

* Build a Data Warehouse using SQL Server.
* Extract data from CSV files.
* Apply data cleaning and transformation using SQL.
* Implement Bronze, Silver, and Gold layers.
* Design Fact Tables and Dimension Tables using a Star Schema.
* Prepare data for analytical queries and reporting.

## 🛠️ Tools & Technologies

* SQL Server
* SQL Server Management Studio (SSMS)
* SQL
* Draw.io (for data architecture diagrams)

## 🏗️ Data Architecture

The project is organized into three layers:

* **Bronze Layer:** Stores raw data loaded from source files.
* **Silver Layer:** Cleans and transforms data to improve quality and consistency.
* **Gold Layer:** Contains business-ready data modeled for analytical queries and reporting.

## 🔄 ETL Process

1. **Extract:** Load data from CSV source files.
2. **Transform:** Clean, validate, and standardize the data.
3. **Load:** Organize the processed data into the appropriate Data Warehouse layers.

## 📊 Data Modeling

The Gold Layer uses a Star Schema consisting of:

* **Fact Tables:** Store measurable business events, such as sales.
* **Dimension Tables:** Store descriptive information about customers, products, and dates.

## 📚 What I Learned

* Data Warehouse architecture and design.
* ETL processes using SQL.
* Data cleaning and transformation.
* Medallion Architecture.
* Dimensional Modeling and Star Schema.
* Writing SQL queries for analytical purposes.

## 🚀 Project Status

This project is part of my learning journey in Data Engineering. I will continue improving it as I develop my skills in data integration, data modeling, and pipeline development.
