# Regression Analysis Project

### Introduction ###

In the EU in 2020, around 40% of 30-35 year olds will have completed tertiary education. Higher educational attainment leads to better job prospects and higher wages, which can enable people to consume more and better quality goods and services. These conditions suggest that a happier life can be achieved. But the 40% suggests that more than half of this age group do not have the same opportunities as graduates. This report aims to find out if this is true and to analyse the impact of educational attainment on life satisfaction in the EU. My question: Is life satisfaction only a matter of educational attainment and the standard of living it generates? Will we be unhappy if we don’t learn?

### Data ###

In order to adequately assess life satisfaction, I have first determined the areas through which I will test life satisfaction in certain education levels. These were job satisfaction, employment rate, relationship satisfaction and life satisfaction, for which I used four different data sources from the [Eurostat](https://ec.europa.eu/eurostat/web/main/data/database?p_p_id=NavTreeportletprod_WAR_NavTreeportletprod_INSTANCE_nPqeVbPXRmWQ&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view) website to examine my question.

### Descriptive statistics ###

<img width="1037" alt="Screenshot 2023-02-03 at 15 59 00" src="https://user-images.githubusercontent.com/113236007/216635417-c575cf8c-ed17-4504-9538-f34fa114aff8.png">

The table summarises the main characteristics of the output and explanatory variables. Life satisfaction, job satisfaction and relationship satisfaction are rated from 1 to 10 and employment rate is expressed as a percentage of the population. The average life satisfaction rating is 7.4, with a difference of 4 points between the minimum and maximum rating. For each measure, we have 105 observations with 0 missing values. In the appendix, I have created a detailed version of the descriptive statistics, where measurements are broken down by educational attainment.

There are three different education levels in the dataset:

- Less than primary, primary and lower secondary education (ISCED levels 0-2), referred to as primary in the visualizations.
- Upper secondary and post-secondary non-tertiary education (ISCED levels 3 and 4), referred to as secondary in the visualizations.
- Tertiary education (ISCED levels 5-8), referred to as tertiary in the visualizations.

<img width="1053" alt="Screenshot 2023-02-03 at 16 00 46" src="https://user-images.githubusercontent.com/113236007/216635817-95107cc1-62e7-478a-95d8-8c6d77501dff.png">

The first graph shows satisfaction with life at each level of education. We can see that the values range from 4.3 to 8 for primary education, from 5.4 to 8.1 for secondary education and from 6.1 to 8.3 for tertiary education. The higher the education level, the smaller the variance of the values. The graph shows an upward trend, meaning that on average the higher the level of education, the higher the satisfaction with life. In the appendix I also visualized the job satisfaction, relationship satisfaction and the employment rate in the different education levels, the results of which show a similar increasing trend. This suggests that there is indeed a correlation between education levels and life satisfaction.


<img width="1065" alt="Screenshot 2023-02-03 at 16 02 13" src="https://user-images.githubusercontent.com/113236007/216636216-5b29f51c-172c-4f10-9f02-2fe0fe503206.png">

For the primary education level I wanted to find an explanation for the life satisfaction variance, so I also examined this level of education by employment rate. The second graph shows, in descending order, the countries with the lowest employment rates in primary education. The graph shows that the average employment rate at this particular level of education in european countries is close to 36.45%, which means nearly 2/3 of people are unemployed or works in undeclared work. This rate is significantly higher in the secondary and tertiary education level where the values are 64.05% and 78.64%. Slovakia has the lowest employment rate, which is exactly 18% and in this case Montenegro has the highest with 21.2%. The values of the five countries with the lowest employment rates are very close to each other, yet far from the average.


### Models ###

<img width="1014" alt="Screenshot 2023-02-03 at 16 04 20" src="https://user-images.githubusercontent.com/113236007/216636759-f0dc6883-df02-42fe-ac1a-ceb272f998cf.png">


Based on the results of Model 1, if we exclude the control variables, we see that having a primary education would mean an average life satisfaction score of 6.69, a secondary education would increase it by 0.48, and a tertiary education would mean that our life satisfaction would increase by 0.95 rating compared to primary education level. From Model 2 we can see that if job satisfaction is on average 1 rating higher, then life satisfaction ratings are on average 1.02 rating higher. From Model 3 we see that the employment rate is not significant. The first model already explains about 20% of the total variation of the life satisfaction. If we include job satisfaction in the model, we see that it increases to 80%, so it is indeed an important predictor of life satisfaction. In the third and fourth regressions I added additional variables, from which we can see that relationship satisfaction also seems to be an important predictor. We also have a very low RMSE value for each model which indicates that we have models with fairly low error values (RMSE is useful since it has a squared term which indicates that large errors will be squared, and thus it would highly effect our RMSE value).

### Conclusion ###

To my question whether life satisfaction is only a matter of educational attainment and the standard of living it generates, the answer is that it is not solely but significantly influenced. Although all of the variables I examined showed significant differences between educational attainment levels. Most importantly, job satisfaction and relationship satisfaction influence the happiness level of people at each educational level. We cannot conclude that a higher level of education will pre-determine future happiness, as we do not have access to all the relevant measures, such as the average earnings for each level of education. Nevertheless, the results confirm that, on average, higher educational attainment provides more opportunities.


### Appendix ###

#### Descriptive statistics by education level ####

<img width="1080" alt="Screenshot 2023-02-03 at 16 10 15" src="https://user-images.githubusercontent.com/113236007/216638048-ce7a15d4-63a5-484a-b29a-94002ec278d7.png">

#### Loess smooth for each variable ####

<img width="1071" alt="Screenshot 2023-02-03 at 16 11 26" src="https://user-images.githubusercontent.com/113236007/216638247-1fdc1a65-7755-46b6-9ba7-0d1adf89f426.png">



#### Distribution of values across variables based on educational attainment ####

<img width="1074" alt="Screenshot 2023-02-03 at 16 12 36" src="https://user-images.githubusercontent.com/113236007/216638493-fa7c503a-aeb0-4b53-a253-dcee087c6f14.png">






