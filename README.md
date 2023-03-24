# AB Testing Calculator

## Project description
This is an small application developed to conduct AB tests and to understand the relation between some statistical concepts such as p-value, statistical power, sample size, confidence level and types of errors. 

I also wrote a [blog post](https://typethepipe.com/post/ab-testing/) about this project on TypeThePipe. Check it out!


## The App

The application is written in R and I used Shiny to make it responsive and interactive. It is [deployed on ShinyApps.io](https://pabloct.shinyapps.io/StatisticalSignificance/).

The app has two tabs:
* In the first one we have an A/B Test Calculator where we can set the number of participants and conversions and the confidence level required for our test. It automatically displays the result of the test, the degree of certainty, the binomial distribution for both populations, conversion rates and the uplift between both groups
* The second one, more theoric, shows how the minimum detectable effect and the statistical power vary when maximum allowed alpha and beta errors change.


![](https://github.com/PabloCanovas/ABTesting-Calculator/blob/main/Snapshots/AB%20Test%20Calculator.PNG)


![](https://github.com/PabloCanovas/ABTesting-Calculator/blob/main/Snapshots/Statistical%20Power.PNG)
