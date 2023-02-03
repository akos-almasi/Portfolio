
# Sentiment Analysis using R and AWS for Nord Stream articles #

![image](https://user-images.githubusercontent.com/113236007/216640326-93903f84-8fa8-4413-af46-50dc06e0cfd1.png)

## Introduction ##

Nord Stream is vital for Europe, supplying nearly 40 percent of the European Union's gas needs. The two end points of the pipeline are connected by Russia as a sending country and Germany as a receiving country. During the Russia-Ukraine war last year, the EU leadership took measures to weaken the Russian economy to help Ukraine. Previously, there had been no significant reaction to these measures from Russia. Then, on 26 of September, the Nord Stream pipeline was 'damaged'. Investigations proved that there were traces of a bomb at the leak and later linked the incident to Russia. This is the first threat addressed to the EU that has been accompanied by physical atrocities. In my work, I want to focus on the sentiment of the headlines of the news articles related to the case. My hypothesis is that initially factual articles were published, and then articles with a negative tone were published due to the Russian threat, therefore I will find articles with a neutral or negative tone.

## Selection of datatype ##

In order to get a separate picture of international opinion, I selected five news sites of different nationalities and filtered out their articles on Nord Stream. In selecting the five news sites, I primarily looked for news sites from countries close to the Nord Stream, so I chose BBC (UK), Berlingske (Denmark), Dagens Nyheter (Sweden). As the events were geographically close to these countries, the incident is likely to have a higher news value in these countries and therefore more coverage. Therefore, I also wanted to have a control group, which was Origo from the Central European region in Hungary and the Italian online news portal Il Post from the Southern European region. For the articles, I looked at the titles. My choice was based on the fact that the majority of readers only read the headlines of the news, and news portals tend to focus on attracting attention. My assumption is that readers are less likely to click on neutral text, so news sites try to write headlines with a positive or negative sentiment. To determine if this is the case, I used the tools provided by AWS.

## Access to AWS ##

In order to use AWS in R, we need to create an access key with IAM (Identity and Access Management).

1. Go to security credentials

![image](https://user-images.githubusercontent.com/113236007/216640759-5e3781d8-21ba-42c8-a083-9a81839392b9.png)

2. Create access key

![image](https://user-images.githubusercontent.com/113236007/216640874-aa2ccd7d-3ae0-4545-84a7-0b146e527918.png)

3. The access key should be saved in the same folder where we will do our analysis using R(inside the working directory).

4. Run the following code in R to connect to your AWS IAM account:

```
keyTable <- read.csv("accessKeys.csv", header = T) 
# accessKeys.csv == the CSV downloaded from AWS containing your Access & Secret keys

AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

#activate
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "eu-west-1")
      
```


## Web scraping ##

For scraping, I took into account that only articles published after 27 of September should be included. The code below shows how I scraped one news site. Also I cleaned the titles to make sure I don’t have any extra characters.

```
# Scraping
url_berlingske <- read_html('https://www.berlingske.dk/search/2022-09-27/2022-11-27?query=Nord%20Stream')
title_berlingske <- url_berlingske %>% html_nodes('.font-s4') %>% html_text()
# clean the titles
title_berlingske <- gsub("[\r\n\t]", "", title_berlingske)

```

## AWS translate ##

To be able to examine the titles in a standardised way, I first translated them to English and then saved them as characters. To do this, I used the AWS Translate Tool.

```
# AWS translate
translate_berlingske <- NULL

for (i in 1:length(title_berlingske)){ 
  translate_berlingske <- (rbind(translate_berlingske,
    translate(title_berlingske[i], from = "auto", to = "en")[1]))
}
# Save it as character
translate_berlingske <- as.character(translate_berlingske)

```

## AWS comprehend ##

From the AWS Comprehend package, I used the detect_sentiment function to identify article titles based on their sentiment. The sentiment could be positive, negative, mixed or neutral.

I used the following code to get the results for the Berlingske articles:

```
# AWS detect_sentiment()
df_berlingske <- NULL
sentiment_berlingske <- NULL 

for (i in 1:length(translate_berlingske)) {   
  if (translate_berlingske[i] > "") {
    df_berlingske <- detect_sentiment(translate_berlingske[i]) 
    sentiment_berlingske <- rbind(sentiment_berlingske, df_berlingske)
  }
}
sentiment_berlingske

```

My search resulted in the following table:

![image](https://user-images.githubusercontent.com/113236007/216641710-adecea15-ca78-4c4a-ad0e-d50863f8ecca.png)

I followed the same process for every single articles and then combined them into a table so we can have an overview about their overall sentiment. To visualize the result I used the ggplot package.

```
all_sentiment <- within(all_sentiment,
               Article <- factor(Article,
                               levels=names(sort(table(Article),
                                                 decreasing=TRUE))))
all_sentiment %>% group_by(Article) %>% 
  ggplot(aes(x = Article, fill = Sentiment)) +
  geom_bar(position = 'stack') +
  scale_fill_viridis(discrete = T) +
  theme_classic()
  
```

![image](https://user-images.githubusercontent.com/113236007/216641891-96def2e4-a7d8-4402-b447-c177eeebe6e3.png)


I analysed a total of 60 articles, which were not equally distributed. I analysed 10 articles from BBC, 10 from Berlingske, 24 from Dagens Nyheter, 12 from Origo and 4 from Il Post. In response to my first question about the sentiment of the titles of the articles published, I found that for the most part they were neutral. My preliminary assumption that there would be a mixture of negative and neutral articles, although true, the proportions were not evenly distributed. This is possible, in my opinion, because journalists are trying to present events impartially, as articles can be about the disaster, its prevention and investigation, not just about the Russian threat.

My first table shows the overall sentiment of each article in the given news site. To find out their exact ranking on a positive-negative scale, I created another visualization.

```
ggplot(all_sentiment, aes(y = Positive, x = Negative, color = Article)) +
  geom_point() +
  scale_color_viridis(discrete = T, option = "H") +
  theme_minimal()
```

![image](https://user-images.githubusercontent.com/113236007/216650563-4b40d9a5-bb78-4683-b812-ec6c065bf066.png)


From this we can see that, overall, the most positive articles are from the Origo site, while the other news sites tend to give their articles neutral or negative sentiment.

I also used the detect_entities function to identify what kind of entities are in the texts. With this function anyone can isolate people, organisation, location, date etc. from a text. I decided to group certain entities because I wanted to see which operators appear most often.

```
all_entities <- NULL
for (i in 1:length(all_translated_titles)) {
  all_entities <- rbind(all_entities, 
                         detect_entities(all_translated_titles[i]))
}

```

![image](https://user-images.githubusercontent.com/113236007/216650715-ceb0eef9-b5e1-4418-9e7a-fbbd5e8bf67d.png)


## Conclusion ##

My primary assumption is that article headlines are mostly negative or neutral and furthermore the entities demonstrated that most of the articles about the North Stream were written in a way that associated it with the Russians.

To evaluate my second hypothesis, which is to find a correlation between article titles and clicks, we need to look at more data, in this case a much larger database. Although I only looked at 60 articles, you can see that AWS allows us to do a full analysis.

If you want to check out the final script click here[https://gist.github.com/akos-almasi/4029f2825b07fe3fa166742d6ceb525b].

