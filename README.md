# Mann-Kendall-SenSlope-3D-Drought-MATLAB
MATLAB code for pixel-wise Modified Mann-Kendall trend analysis and Sen's slope estimation of 3D SPI and SPEI drought index datasets.
# Analysis of Spatiotemporal Drought Trends Using Modified Mann–Kendall Test and Sen's Slope Estimation

## Overview

This repository contains MATLAB code used to investigate the spatiotemporal trends of drought conditions in Sicily using the Standardized Precipitation Index (SPI) and the Standardized Precipitation Evapotranspiration Index (SPEI) derived from ERA5-Land reanalysis data.

The workflow applies the Modified Mann–Kendall (MMK) trend test to detect statistically significant drought trends while accounting for serial autocorrelation and uses Sen's slope estimator to quantify trend magnitude at each grid cell.

The methodology was developed and applied in the following publication:

Aschale, T. M., Cancelliere, A., Palazzolo, N., Buonacera, G., & Peres, D. J. (2024). Analysis of the spatiotemporal trends of standardized drought indices in Sicily using ERA5-Land reanalysis data (1950–2023). Water, 16(18), 2593. https://doi.org/10.3390/w16182593

---

## Repository Structure

### Main Workflow

#### MK_SPI_SPEI_all_Final.m

This is the primary script that performs the complete drought trend analysis workflow.

The script:

* Loads SPI and SPEI datasets
* Performs pixel-wise trend analysis
* Removes missing values
* Applies the Modified Mann–Kendall test
* Computes Sen's slope
* Stores trend statistics
* Generates spatial trend maps
* Produces Sen's slope maps
* Visualizes increasing, decreasing, and non-significant drought trends

---

### Core Function

#### Modified_MannKendall_test.m

This function performs the Modified Mann–Kendall trend test.

Outputs include:

* Kendall Tau statistic
* Z statistic
* p-value
* Trend significance classification
* Sen's slope estimate

The modified version corrects for serial correlation, improving the reliability of trend detection in hydroclimatic time series.

---

## Input Data

The workflow analyzes gridded drought indices derived from ERA5-Land reanalysis data covering Sicily from 1950–2023.

### SPI Datasets

* SPI-1
* SPI-3
* SPI-6
* SPI-12
* SPI-24

### SPEI Datasets

* SPEI-1
* SPEI-3
* SPEI-6
* SPEI-12
* SPEI-24

Data structure:

```text
Longitude × Latitude × Time
```

Example:

```text
33 × 18 × 888
```

where:

* 33 = longitude grid cells
* 18 = latitude grid cells
* 888 = monthly observations

---

## Methodology

### Step 1: Data Extraction

A drought time series is extracted for each grid cell.

### Step 2: Missing Data Handling

Grid cells with excessive missing values are excluded.

### Step 3: Modified Mann–Kendall Test

Trend significance is evaluated using the Modified Mann–Kendall test with autocorrelation correction.

Significance level:

```matlab
alpha = 0.05;
alpha_ac = 0.05;
```

### Step 4: Sen's Slope Estimation

Trend magnitude is quantified using Sen's slope estimator.

### Step 5: Spatial Visualization

Spatial maps are generated showing:

* Increasing drought trends
* Decreasing drought trends
* Non-significant trends
* Sen's slope magnitude

---

## Output Variables

For each SPI and SPEI timescale, the workflow generates:

### tau

Kendall's Tau coefficient.

### z

Standardized test statistic.

### p

p-value.

### H

Trend classification:

```text
-1 = Significant decreasing trend
 0 = No significant trend
 1 = Significant increasing trend
```

### b_sen

Sen's slope trend magnitude.

---

## Required Files

```text
MK_SPI_SPEI_all_Final.m
Modified_MannKendall_test.m

SPI_Data.mat
spei_data.mat

Italia_Regioni_GEO.shp
EV_SIC_2023_12.nc
```

---

## Applications

This workflow can be applied to:

* Drought trend analysis
* Climate change impact assessment
* Hydroclimatic variability studies
* Regional drought monitoring
* Early warning systems
* Water resources planning

---

## Citation

If you use this code, please cite:

Aschale, T. M., Cancelliere, A., Palazzolo, N., Buonacera, G., & Peres, D. J. (2024). Analysis of the spatiotemporal trends of standardized drought indices in Sicily using ERA5-Land reanalysis data (1950–2023). Water, 16(18), 2593. https://doi.org/10.3390/w16182593

