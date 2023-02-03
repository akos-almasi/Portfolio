# Tableau project

### Goal ###
The main question of my tableau dashboard is to find what influences winning in online chess games. I wanted to investigate whether it is influenced by side selection, opening selection or players rating.
### Worksheets ###
To answer this question, I created 4 visualizations.
First (Side selection) -> I created a bar chart to visualize the differences based on side selection, this shows that white has a slightly higher chance of winning the match.
Second (Players rating) -> I used a bar chart to see if players ratings affect the outcome of matches. To get the right conclusion, I had to take into consideration the number of matches that ended in a draw and where the rating was exactly the same. I decided to remove these, as the bar chart was trying to answer the question of whether or not the difference in rating had an effect on the win rate.
It can be clearly seen that the player with the higher rating usually wins the game.
Third (Opening selection) -> I used a stacked bar chart to see if the opening selections has an effect on the outcome of the games.
It is clear to see that different win rates are obtained based on the opening choice, so it does matter which one you choose.
Fourth (Opening selection 2) -> I made a scatter plot with custom shapes to visualize how many games were played by the different openings, and to see what the average game rating of the different openings is.
### Dashboard ###
I decided to link the third and fourth worksheets filters so that we can see how many games were played with the different openings and what their average rating was.
The filters are interactive on the dashboard.
### Created calculated fields ###
I had to create new calculations in order to answer the main question:
- Number of games: calculate how many games appeared in the table - White wins: calculate how many times White won a game
- Black wins: calculate how many times Black won a game
- Draw count: number of games ended in a draw
- Higher rating wins: the number of games in which the higher rated player wins - Lower rating wins: the number of games in which the lower rated player wins - Average game rating: the average rating per game
- Rating is the same: number of games in which the rating is exactly the same
- Higher/lower rating wins: number of games in which the higher or lower rated player wins.
