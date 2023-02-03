# Term Project DE2
### Group members: ###
 - Shahana Ayobi
 - Alima Dzhanybaeva
 - Akos Almasi


### Abstract ###
This report is part of the second term project for Data Engineering 1: Different Shapes of Data course at the Central European University. The task required us to select a dataset of our choice, merge it with one or more additional datasets, and then conduct a thorough analysis of the resulting dataset to find hidden correlations and patterns. To answer our analytical questions and visualize the results, we were instructed to use the tools we used in class such as SQL, API, and KNIME.

To continue with our analysis, we built an ETL data pipeline with Knime using the data extracted from MongoDB, MySQL, and Eurostat API. The main indicators in our data are Gender Pay Gap, GDP per Capita, and Gender Ratio for European countries. We chose the year 2020 since the data for the selected countries is readily available on all data sources.

The analysis results demonstrate that, with the exception of construction, the pay gap is positive in all other industries, with the finance and insurance sector having the largest gap. Furthermore, after running linear regression and visualizing the data to investigate the relationship between pay gap and gender ratio, we discover that countries with a higher female to male ratio have a larger pay gap.




## Overview of Data Flow ##
### Data Sources ###
Gender Pay Gap from Eurostat: https://ec.europa.eu/eurostat/databrowser/view/earn_gr_gpgr2$DV_593/default/table?lang=en

GDP at Market Prices from Eurostat API: https://ec.europa.eu/eurostat/databrowser/view/tec00001/default/table?lang=en

Gender Ratio from Kaggle: https://www.kaggle.com/datasets/programmerrdai/gender-ratio-inequality

Country Codes from Kaggle: https://www.kaggle.com/datasets/andradaolteanu/iso-country-codes-global

Indicators considered:
- Pay Gap in unadjusted form
- GDP per capita
- Gender ratio

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/upd_eer.png" width="600" height="500">


### Data collection ###
#### Eurostat ####
- Gender pay gap

The first dataset that was used in the project contains information on the gender pay gap for European countries between 2011-2020. The original data has 7 variables: year, country, unit, field, flag, and ID. For this source we used NoSQL, and the csv file was imported to the platform by MongoDB Shell.    
![MongoDB shell](https://github.com/akos-almasi/Term2/blob/main/pics/mongodb_bash.png)

- GDP at Market Prices

To look into the relationship between gender pay gap and GDP, Eurostat API was used to access GDP at market prices for European countries. The json data was acquired using data code (nama_10_gdp) in Eurostat Query Builder and filtered for year 2020, GDP at Market prices, and countries.  The data was then extracted using Postman.

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/Postman.png" width="800" height="500">

#### Kaggle ####
- Gender ratio

We added the Gender ratio table in order to investigate whether the connection with the Pay Gap table is present. The original dataset has information on 35 countries for 2020. 

- Country Codes

We obtained the Alpha-2 country codes from Kaggle in order to access the GDP data via postman. The csv file was then loaded to MySQL for further analysis in Knime.

## Knime Workflow ##

![Knime Workflow](https://github.com/akos-almasi/Term2/blob/main/pics/knime.png)

### MongoDB ###
In order to access NoSQL we added MongoDB Connector and then we applied MongoDB Reader node to be able to read the pay gap table. For the next step we transformed the obtained JSON to a Table and filtered the data to our needs, such as: leaving only 2020, keeping only necessary columns, deleting missing values, etc.
You can check the MongoDB workflow [here](https://github.com/akos-almasi/Term2/blob/main/pics/pay_gap.png).
### SQL ###
We used MySQL workbench to access the gender ratio and the country codes csv files, and we used the MySQL connector node to import it to Knime, and we configured the Query Reader for 2020. You can check the SQL workflow [here](https://github.com/akos-almasi/Term2/blob/main/pics/ratio_codes.png)
### Joiner ###
Using the joiner node, we first inner joined the gender gap and gender ratio tables by country. Then, we used the second joiner to combine the obtained table with the country codes dataset by country.
### Eurostat API ###
We configured the string manipulation node to access the GDP dataset, pasted the country codes to acquire GDP information for each country. We then used the get request node to access the JSON URL for each country.  We used the JSON Path node to extract the GDP at market prices, country names, country codes, year, and unit. We then performed data cleaning by removing unnecessary columns. You can check the API workflow [here](https://github.com/akos-almasi/Term2/blob/main/pics/gdp_api.png)

### Analytics on MongoDB ###
We wanted to visualize the average pay gap in each country, so we grouped by the country column. Based on the bar chart we can see that the highest gap is in Latvia (21.3%), and the lowest is in Romania(4.7%) .

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/pay_gap_by_countries.png" width="800" height="500">

Then we wanted to investigate this observation further so we checked what is the mean gap in each field. The result shows us that there is a negative pay gap in construction, which means women tend to earn more in this field, probably it's because there aren't many women in this occupation or most of the time they are in higher average salary positions compared to men who work on construction sites.

### Analytics on the Data Warehouse ###
Our Data Warehouse consists of the following four dimensions and it has been created to provide one single table for both qualitative and quantitative parameters:

<img src="https://user-images.githubusercontent.com/113236007/206479158-5c7a9dd0-5376-4134-93e9-5b5270571c1a.png" width="600" height="400">

We included the summary statistics table for the Data Warehouse:

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/statistics.png" width="900" height="200">

We took the log GDP for the following models:
First we ran a linear regression on pay gap conditioned on gender ratio and log GDP. We found out that if the female to male gender ratio increases by 1% the pay gap also increases by 1.2 %. Ln GDP is not significant probably because we are checking EU countries. Our adjusted R-squared value is low, so we would advise to add additional explanatory variable(s) to the model. 

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/linear.png" width="500" height="300">

Since we found a significant relationship between gender ratio and pay gap, we wanted to visualize this correlation using a box plot. The plot confirms the regression result, the mean pay gap has an increasing trend meaning that as the proportion of women in the country rises the difference between average wage of men and women becomes bigger.  

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/box_plot.png" width="800" height="500">


### Views: ###
Additionally, we created two table views that demonstrate the average pay gap and gender ratio by countries and by different fields. The user can specify the country displayed, the order of the observations based on the two indicators.

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/view_country.png" width="900" height="200">

<img src="https://github.com/akos-almasi/Term2/blob/main/pics/view_fields.png" width="900" height="200">


### Conclusion ###

First, as we have seen from the visualizations for the Pay Gap table, in the fields where there are not that many women involved the gender pay gap can be even negative indicating that females in these professions earn more than men. However, in all other fields the pay gap is positive and this gap is the highest in the financial sector. Furthermore, in order to prove our finding we ran linear regression on pay gap conditioned on gender ratio and log(GDP) and constructed a box plot. The previously observed pattern is also found in the obtained results, the gender ration and pay gap are indeed positively correlated. 






