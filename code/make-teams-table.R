# =================================================
# Title: Make Teams Table
# Description: Data pre-processing for Workout01.
# Input(s): nba2018.csv
# Output(s): nba2018-teams.csv
# =================================================

wo_data <- read.csv('../data/nba2018.csv', stringsAsFactors = FALSE)
wo_data$experience[wo_data$experience == 'R'] <- "0"
wo_data$experience <- as.integer(wo_data$experience)
wo_data$salary <- (wo_data$salary)/1000000
wo_data$position[wo_data$position == 'C'] <- "center"
wo_data$position[wo_data$position == 'PF'] <- "power_fwd"
wo_data$position[wo_data$position == 'PG'] <- "point_guard"
wo_data$position[wo_data$position == 'SF'] <- "small_fwd"
wo_data$position[wo_data$position == 'SG'] <- "shoot_guard"
library(dplyr)
wo_data <- mutate(wo_data, missed_fg = wo_data$field_goals - wo_data$field_goals_atts, missed_ft = (wo_data$points1 - wo_data$points1_atts), rebounds = (wo_data$off_rebounds + wo_data$def_rebounds))
wo_data <- mutate(wo_data, efficiency_index = (wo_data$points + wo_data$rebounds + wo_data$assists + wo_data$steals + wo_data$blocks - wo_data$missed_fg - wo_data$missed_ft - wo_data$turnovers)/ wo_data$games)
sink(file = '../output/efficiency-summary.txt')
summary(wo_data$efficiency_index)
sink()
teams <- data.frame(wo_data %>%
  group_by(team) %>%
  summarise(total_rebounds = sum(off_rebounds + def_rebounds), experience = sum(experience), salary = sum(salary), points3 = sum(points3), points2 = sum(points2), points1 = sum(points1), points = sum(points), off_rebounds = sum(off_rebounds), def_rebounds = sum(def_rebounds), assists = sum(assists), steals = sum(steals), blocks = sum(blocks), turnovers = sum(turnovers), fouls = sum(fouls), efficiency_index = sum(efficiency_index)))
sink(file = '../data/teams-summary.txt')
summary(teams)
sink()
write_csv(teams, path = '../data/nba2018-teams.csv')

