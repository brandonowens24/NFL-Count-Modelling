# Descriptive Analysis of Betting Strategies in the NFL Playoffs Through Bayesian Hierarchical Simulation

## ABSTRACT
The main goal of this competency report is to evaluate a Bayesian hierarchical modeling approach using game data from the 2024–2025 NFL regular season. We develop and analyze a Bayesian hierarchical count regression model to estimate team strengths and predict scoring outcomes in the context of the NFL Playoffs for the aforementioned season. Offensive and defensive abilities are modeled separately, allowing for a flexible representation of team performance. To capture the uncertainty within game outcomes, Monte Carlo simulations are employed, generating predictive distributions for playoff matchups and point differentials. Although profitability proved to be extremely variable due to the small sample size of the playoffs, the analysis demonstrates how hierarchical modeling and simulation can formalize betting evaluations in highly liquid markets. By integrating statistical modeling with simulation-based inference and decision-making frameworks, this competency report contributes to the growing literature on sports analytics, as well as demonstrating the practical evaluation of betting strategies in professional retail sports markets.

![Full Paper](https://github.com/brandonowens24/NFL-Count-Modelling/blob/main/Competency%20Project%20Report.pdf)

```
# Repository Structure

├── Analysis.Rmd                    # R Markdown for Primary Visualizations
├── Competency Presentation.pdf     # Presentation Slides
├── Competency Project Report.pdf   # Presentation Slides
├── Data_Gathering.Rmd              # Loading Data from nflReadR  
├── Data_Modeling.Rmd               # Creating Model Objects
├── Data_PreProcessing.Rmd          # Cleaning Loaded Data
├── scoring.stan                    # Stan model architectures
├── Simulation.Rmd                  # Posterior game simulations
├── README.md                       # Project documentation  
└── .gitignore                      # Config for ignoring csv/rds files
```
