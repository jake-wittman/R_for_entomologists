# This script makes some alterations to the mn_buprestid_summary.csv to make
# it more useful for pedagogical purposes.

# Load libraries
if (!require(pacman)) install.packages(pacman)
pacman::p_load(tidyverse)

# Load data
dat <- read.csv("data/data_preparation_scripts/mn_buprestids_summary.csv")

# Clean data
dat <- dat %>% 
   select(scientificname, county, n, recent_collect_date, recent_id_date) %>% 
   filter(county != "")

# Simulate other data
# Add a mass variable that doesn't depend on anything
dat <- dat %>% 
   mutate(mass = runif(nrow(dat), 30, 80))

# Add a length variable that depends on the county caught in
for (i in unique(dat$county)) {
   # random length distribution for each county
   mean_length <- rgamma(1, shape = 7.5, scale = 1)
   dat$length[dat$county == i] <- rgamma(nrow(subset_dat),
                                         shape = mean_length + 5,
                                         scale = 0.5)
}


# Remove mass/length data if there was no catch observed
dat <- dat %>% 
   mutate(mass = case_when(n == 0 ~ NA_real_,
                           n != 0 ~ mass),
          length = case_when(n == 0 ~ NA_real_,
                             n != 0 ~ mass))

# Save the data to the data folder
write.csv(dat, "activities/data/example_buprestid_data.csv")
