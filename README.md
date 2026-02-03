# Flux Balance Analysis (FBA)

**Developed by:** Laboratorio de Bioinformática e Ing. Metabólica  
**Institution:** Universidad de Guadalajara  
**Author:** Orfil González Reynoso and Javier Alejandro Delgado Nungaray  
**Versions:** v1.0 (2011), v1.1 (2024)

---

## **Project Overview**
This repository contains MATLAB scripts designed for the optimization of metabolic pathways through **Flux Balance Analysis (FBA)**. The code specifically focuses on the metabolic model **iJD1249** (Delgado-Nungaray, J. A., Figueroa-Yáñez, L. J., Reynaga-Delgado, E., García-Ramírez, M. A., Aguilar-Corona, K. E., & Gonzalez-Reynoso, O. (2025). Influence of Amino Acids on Quorum Sensing-Related Pathways in Pseudomonas aeruginosa PAO1: Insights from the GEM iJD1249. Metabolites, 15(4), 236. https://doi.org/10.3390/metabo15040236) to analyze the production of **Biomass** and the protein **PvdQ**.

The analysis evaluates steady-state fluxes and identifies significant metabolic "shifts" when comparing standard growth conditions against multi-objective optimizations.

---

## **Workflow Description**

### **1. Stoichiometric Matrix Construction**
The script imports reactions and flux boundaries from the **iJD1249_run.xlsx** archive. It utilizes a custom subroutine, `genmatriz.m`, to parse the Excel data into a mathematical matrix format ($Aeq$) suitable for optimization.

### **2. Linear Programming (Optimization)**
The code solves the following optimization problem:
* **Objective:** Maximize fluxes for **Biomass** (ID 251) and **PvdQ** (ID 825).
* **Solver:** `linprog`.
* **Constraints:** Mass balance ($S \cdot v = 0$) and thermodynamic bounds ($lb \leq v \leq ub$).

### **3. Comparative Flux Shift Analysis**
After optimization, the script identifies critical reactions by comparing results against the **Analysis for gene deletion.xlsx** dataset. 

**Significant reactions** are filtered based on:
* An absolute flux difference (shift) greater than **90**.
* Complete inactivation (**Flux = 0**) during the PvdQ maximization phase.

---

## **Required Files**
To run this analysis successfully, the following files must be in the same directory:

| File Name | Description |
| :--- | :--- |
| **iJD1249_run.xlsx** | Contains sheets **'Run'** (Matrix) and **'Bounds'** (Limits). |
| **Analysis for gene deletion.xlsx** | Reference data for flux shift comparison. |
| **genmatriz.m** | Internal function to generate the stoichiometric matrix. |

---

## **Instructions for Use**
1. Ensure all **Excel archives** and the **genmatriz.m** (The code are available from the corresponding author (Ph.D. Orfil G.) upon reasonable request) function are in your MATLAB path.
2. Execute the script.
3. The program will display:
    * **Optimization Results:** Values for Biomass and PvdQ.
    * **Visualizations:** A sparsity plot (`spy`) of the matrix structure.
    * **Filtered Results:** A table displaying the most significant reaction shifts.

---

## **Technical Requirements**
* **Software:** MATLAB R2021a or newer recommended.
* **Toolboxes:** Optimization Toolbox.
