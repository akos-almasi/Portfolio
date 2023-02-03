# Web scraping project

## Introduction
In my web scraping project I wanted to investigate the real estate market in Budapest. The focus of my research is to find out the factors that can influence real estate prices. I wanted to look at a district with an outstanding green area, still close to the city centre. One of these is the second district, so I focused my search on this area when I was doing my data scraping on Hungary's largest real estate website, [ingatlan.com](https://realestatehungary.hu). In my opinion, the pricing of the real estate market is heavily influenced by the availability of new build houses for potential buyers, which would distort the value of existing properties. The second district is completely built up, so there are few new houses. My assumption is that pricing in this area reflects the characteristics of the houses that have already been built, and what their pricing depends on.

<img width="230" alt="Screenshot 2022-12-27 at 15 47 07" src="https://user-images.githubusercontent.com/113236007/209724560-1f920578-7635-480a-bd1f-556e667b3602.png">

## Web scraping
To extract the data, I searched for listings in the second district on the website, and then used the code below to collect the data for a property.

```
url <- "https://realestatehungary.hu/ii-ker/elado+lakas/tegla-epitesu-lakas/33085768"

get_one_house <- function(url) {
  #Sys.sleep(30)
  t_list <- list()
  t <- read_html(url)
  t_list[["price"]]<- t %>% html_nodes('.text-nowrap span') %>% html_text()
  t_list[["area_sqm"]] <- t %>% html_nodes('.border-end .fs-5') %>% html_text()
  t_list[["room_count"]] <- t %>% html_nodes('.border-end+ .font-family-secondary .fs-5') %>% html_text()
  # Get the keys
  keys <- t %>% html_nodes('.ps-0:nth-child(1)') %>% html_text()
  keys <- trimws(keys)
  # Remove the first 5 since they are error messages
  keys <-  keys[-c(1,2, 49,50)]
  # Get the values
  values <- t %>% html_nodes(".fw-bold.ps-0") %>% html_text()
  values <- trimws(values)
  
  if (length(keys)==length(values)) {
    for (i in 1:length(keys)) {
      t_list[[keys[i]]] <- values[i]
    }
  }
  return(t_list)
}
```
Then I needed a function that would collect all the links on a given page.

```
get_one_page_link  <- function(url) {
  t <- read_html(url)
  all_link <- paste0("https://realestatehungary.hu", t %>% html_nodes('.listing__link') %>% html_attr('href'))
  house_link <- all_link[startsWith(all_link, 'https://realestatehungary.hu/ii-ker/elado+lakas/tegla-epitesu-lakas/')]
  return(house_link)
}
```
I examined 40 pages of data, covering more then 700 properties. Using the get_one_page_link function, I collected the links for the 40 pages into a list, which I saved. 
```
# The links for 40 pages
pages_for_link  <- paste0('https://realestatehungary.hu/lista/elado+lakas+ii-ker?page=', 1:40)
# All the house links for the first 40 pages
house_links <- sapply(pages_for_link,get_one_page_link)
# unlist
all_links <- as.character(unlist(house_links))
```
After gathering the links, I used the get_one_house function to gather all the data for each property, sorted into a list. To ensure that the website did not block me, I only retrieved data for 50 properties at a time. I then switched the VPN, cleared the browsing history and scanned the next 50. Finally, I combined the 50 blocks and saved the data contained in them as a dataframe on my computer so that I didn't have to retrieve the data each time.
```
# Save the data into lists
data_list1 <- lapply(all_links[1:50], get_one_house)
data_list2 <- lapply(all_links[51:100], get_one_house)
data_list3 <- lapply(all_links[101:150], get_one_house)
data_list4 <- lapply(all_links[151:200], get_one_house)
data_list5 <- lapply(all_links[201:250], get_one_house)
data_list6 <- lapply(all_links[251:300], get_one_house)
data_list7 <- lapply(all_links[301:350], get_one_house)
data_list8 <- lapply(all_links[351:400], get_one_house)
data_list9 <- lapply(all_links[401:450], get_one_house)
data_list10 <- lapply(all_links[451:500], get_one_house)
data_list11 <- lapply(all_links[501:550], get_one_house)
data_list12 <- lapply(all_links[551:600], get_one_house)
data_list13 <- lapply(all_links[601:650], get_one_house)
data_list14 <- lapply(all_links[651:700], get_one_house)
data_list15 <- lapply(all_links[701:750], get_one_house)
data_list16 <- lapply(all_links[751:771], get_one_house)

# combine together the lists
final_list <- c(data_list1,data_list2,data_list3, data_list4, data_list5,
                data_list6, data_list7, data_list8, data_list9, data_list10, data_list11, data_list12, data_list13,
                data_list14,data_list15,data_list16)
                
# create a data frame from our list
df <- rbindlist(final_list, fill = T)

# Save the data
saveRDS(df, file = "data.rds")
```

## Visualizations of the result
The first graph compares the three most expensive and the three least expensive properties currently for sale. We can see that the average price is around 130 million HUF in the district, but compared to this, the most expensive is more than six times the average price and the cheapest is only a fifth of the average price.

<img width="838" alt="Screenshot 2022-12-28 at 8 39 57" src="https://user-images.githubusercontent.com/113236007/209777473-7ceea226-f5fb-4a4f-b0ff-1492bd34e114.png">

I then looked at the situation in terms of prices per square metre.  In the second visualization, I grouped the properties into four categories according to price. 
- cheap: 0 - 70 million HUF 
- average: 70 -120 million HUF
-  expensive: 120-250 million HUF
-  luxurious: above 250 million HUF

It can be seen that cheap, average and expensive properties have a similar range of price per square metre. There are no striking differences between their prices per square metre. However, in the luxurious category, although few properties fall into this category, there is still a large spread between the prices per square metre, suggesting that other factors are influencing the price.

<img width="834" alt="Screenshot 2022-12-28 at 8 40 24" src="https://user-images.githubusercontent.com/113236007/209785667-0f7e704d-6b3b-46cf-9d21-cc9bc4a4159a.png">

The linear correlation between price and square metre is explored in more detail in the third figure.

<img width="841" alt="Screenshot 2022-12-28 at 8 40 53" src="https://user-images.githubusercontent.com/113236007/209789866-b9a0016a-b5ca-412e-9f40-6d96b78ed3e9.png">

I looked at prices based on the condition of the properties. The following graph shows that most properties are in good condition or renovated, for which the average price is nearly the same. Buildings that are like new or newly built have the highest average price, which confirms my hypothesis that they have an impact on the market price. However, there are few properties in this category to draw a far-reaching conclusion.

<img width="830" alt="Screenshot 2022-12-28 at 8 46 36" src="https://user-images.githubusercontent.com/113236007/209790033-46d9c1ee-8108-4efc-b2e2-df9dcd99af18.png">

I considered the orientation of the property to be a factor influencing pricing. As can be seen in the figure, this information is most often filled in for properties facing south, which is likely to have a price driving effect. This assumption is confirmed by the fact that for other orientations we have significantly less data while for many properties this information is not provided.

<img width="833" alt="Screenshot 2022-12-28 at 8 47 01" src="https://user-images.githubusercontent.com/113236007/209790054-889fd94f-970d-4a72-abd4-11e1332c6667.png">

Besides the basic characteristics of the properties (square meters, condition and orientation), I also wanted to look at a factor that differentiates the buildings. The last graph shows that properties in buildings with an elevator are worth on average 30 million HUF more. 

<img width="835" alt="Screenshot 2022-12-28 at 8 47 27" src="https://user-images.githubusercontent.com/113236007/209790124-404810f8-f4b5-4896-9e32-2ef81f582201.png">

## Conclusion

My project shows that the average price of a property in the second district of Budapest is around 130 million HUF, but you can find properties from 25 million HUF up to 800 million HUF. The first three of the four price categories I have identified, cheap, average and expensive, have an average price per square metre between 1.1 million and 1.5 million HUF. In contrast, the few properties in the luxurious category have an average price per square metre of 2.3 million HUF. 
Furthermore, in my analysis I found that there are many categories that are not necessarily accompanied by information. In other words, the advertisements are not written according to uniform content criteria, so it is difficult to draw general conclusions from the data, because everyone shares important information according to their own opinion. For this reason, although there is a detectable difference in orientation between properties, to get a true picture of the factors that shape the price of a property we would need advertisers to fill in all categories. 
Therefore, my question about the factors that influence the price cannot be answered with certainty on this basis, it would be worthwhile to look at a number of other factors such as: number of rooms, heating, garden connection, air conditioner, interior height.

You can find the whole coding process [here](https://github.com/akos-almasi/Webscraping/blob/main/realestatehungary.Rmd).









