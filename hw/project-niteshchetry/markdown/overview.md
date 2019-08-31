## Project Overview
##### By Joo Cha, Nitesh Chetry, Alex Htut, Gregory Ketron

The following report is a statistical analysis aimed at simulating parallel processes that real MLB organizations use to seek World Series championships.  We explore past postseason success stories, benchmark levels of output exceeding league averages, salary thresholds for top talent and skill positions, and recruiting epicenters to build vibrant farm systems.  Specifically, we strive to answer a number of critical questions:
* Historically, are World Series champions (and other successful playoff teams) more likely to have exceptional hitting or pitching?
* What regions of the country are most rich in talent, and which colleges are expected to churn out future major league all-stars? 
* How is a baseball player valued by team executives?

The [Sean Lahman baseball database](http://www.seanlahman.com/baseball-archive/statistics/) is a publicly available repository containing virtually every statistic imaginable since 1871.  Taken from the core folder inside Lahman’s most up-to-date databank, we performed data wrangling on each of the following .csv files to render our visualizations:
* Batting
* Fielding
* Salaries
* TeamFranchises
* CollegePlaying
* People
* Schools
* Teams <br/>

We also used [Google's Geocoding API](https://developers.google.com/maps/documentation/geocoding/start) to retrieve the locations of the colleges.
