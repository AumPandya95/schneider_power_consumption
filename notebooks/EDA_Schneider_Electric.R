####################################################
## EDA - Schneider Electric Data Set
##
## Date: 25-May-2021
####################################################

setwd("C:/vPhrase/Projects/Analytics_Features/Time_Series_Analysis/Schneider_Electric")
source('C:/vPhrase/Projects/Analytics_Features/Time_Series_Analysis/Schneider_Electric/Code/Schneider_Electric_Func.R')

#######################################################
## Read the core data set for downstream analysis
#######################################################

training_data = read.csv("power-laws-detecting-anomalies-in-usage-training-data.csv", header = TRUE, sep =";", stringsAsFactors = FALSE)

dim(training_data)
[1] 3570305       3

head(training_data)
   meter_id                 Timestamp  Values
1 38_10106 2013-11-08T17:45:00+05:30 1124367
2 38_10106 2012-01-20T15:15:00+05:30  897782
3 38_10108 2016-02-20T18:45:00+05:30 7267642
4 38_10108 2016-02-22T13:30:00+05:30 7274364
5 38_10106 2013-11-20T02:00:00+05:30 1128553
6 38_10108 2016-02-23T23:00:00+05:30 7279659

length(unique(training_data[, 1]))
[1] 28

meta_data = read.csv("power-laws-detecting-anomalies-in-usage-metadata.csv", sep=";", header = TRUE, stringsAsFactors = FALSE)

dim(meta_data)
[1] 187   6

head(meta_data)
     site_id meter_id meter_description          units surface   activity
1     038  38_9712             other            kWh      NA     office
2     038 38_52306             other            kWh      NA laboratory
3     038  38_9737             other            kWh      NA     office
4     038 38_52329       temperature degree celsius      NA     office
5     038  38_9708             other            kWh      NA     office
6     038  38_9715             other            kWh      NA     office

table(meta_data[, 1], meta_data[, 6])
           general laboratory office restaurant
038          32         34     87         13
234_203       0          0     19          0
334_61        0          0      2          0

unique(meta_data[, 'meter_description'])
[1] "other"                       "temperature"                 "main meter"                  "heating"                     "lighting"                   
[6] "outside temperature"         "compressed air"              "Lighting"                    "RTE meter: cos phi"          "main meter: reactive energy"
[11] "main meter : demand"         "elevators"                   "RTE meter"                   "virtual meter"               "virtual main"               
[16] "RTE meter: reactive"         "generator"                   "RTE meter: demand"           "main meter: cos phi"         "laboratory"                 
[21] "cold group"                  "guardhouse"                  "cuisine"                     "total workers"               "Test Bay"                   

    
table(meta_data[, 1], meta_data[, 3])
            cold group compressed air cuisine elevators generator guardhouse heating laboratory lighting Lighting main meter main meter : demand
038              2              2       2         0         0          1      10          2       10        0          1                   1
234_203          0              0       0         1         1          0       1          0        1        1          2                   0
334_61           0              0       0         0         0          0       0          0        0        0          1                   0

         main meter: cos phi main meter: reactive energy other outside temperature RTE meter RTE meter: cos phi RTE meter: demand RTE meter: reactive
038                       1                           1    82                   2         2                  2                 2                   2
234_203                   0                           0    10                   0         0                  0                 0                   0
334_61                    0                           0     0                   0         0                  0                 0                   0

              temperature Test Bay total workers virtual main virtual meter
038              39        0             2            0             0
234_203           0        1             0            1             0
334_61            0        0             0            0             1

#############################
## Identify common meters 
#############################

intersect(meta_data[, 2], training_data[, 1])
[1] "938"      "869"      "38_10110" "930"      "875"      "925"      "872"      "334_61"   "890"      "881"      "920"      "234_203"  "902"      "38_10112"
[15] "928"      "887"      "935"      "896"      "38_10107" "38_10111" "38_10106" "911"      "884"      "38_10109" "38_0"     "38_10108" "38_1"     "878" 

## Meter IDs common to both metadata and training data
common_meters = intersect(meta_data[, 2], training_data[, 1])

common_meters
[1] "938"      "869"      "38_10110" "930"      "875"      "925"      "872"      "334_61"   "890"      "881"      "920"      "234_203"  "902"      "38_10112"
[15] "928"      "887"      "935"      "896"      "38_10107" "38_10111" "38_10106" "911"      "884"      "38_10109" "38_0"     "38_10108" "38_1"     "878" 

common_meters_idx = match(common_meters, meta_data[, 2])

meta_data_filter = meta_data[common_meters_idx, ]

table(meta_data_filter[, 1], meta_data_filter[, 3])
           cold group compressed air elevators generator guardhouse heating laboratory lighting Lighting main meter other outside temperature Test Bay
038              1              1         0         0          1       0          2        1        0          0     1                   1        0
234_203          0              0         1         1          0       1          0        1        1          1    10                   0        1
334_61           0              0         0         0          0       0          0        0        0          0     0                   0        0

            total workers virtual main virtual meter
038                 1            0             0
234_203             0            1             0
334_61              0            0             1

table(meta_data_filter[, 1], meta_data_filter[, 6])
           general laboratory office
038           2          7      0
234_203       0          0     18
334_61        0          0      1

## Identify the relevant meters
## Site ID: 234_203
## meter_description: Other
## activity: Office

idx = which(meta_data[, 1] == "234_203")
idx = intersect(idx, which(meta_data[, 3] == "other"))
idx = intersect(idx, which(meta_data[, 6] == "office"))
idx = intersect(idx, which(meta_data[, 4] == "Wh"))

meta_data_new = meta_data[idx, ]

dim(meta_data_new)
[1] 10  6

meter_ids_set = meta_data_new[, 2]

training_data_filter = training_data[which(training_data[, 1] %in% meter_ids_set), ]

dim(training_data_filter)
[1] 692208      3

table(training_data_filter[, 1])
 869   881   884   890   896   902   911   920   928   935 
71904 73152 73152 73152 35760 73008 73008 73008 73008 73056 

date_vec = training_data_filter[, 2]
date_vec = gsub("\\+05:30$", "", date_vec)
date_vec = gsub("T", ":", date_vec)
date_vec = strptime(date_vec, "%Y-%m-%d:%H:%M:%S")

training_data_filter[, 2] = as.Date(date_vec)

##############################################
## Analyze the results for a single meter
##############################################

filter_idx = which(training_data_filter[, 1] == "869")
set_1 = training_data_filter[filter_idx, ]
set_1 = set_1[order(set_1[, 2]), ]

min(set_1[, 2])
[1] "2013-11-04"

max(set_1[, 2])
[1] "2018-01-08"

length(unique(set_1[, 2]))
[1] 1501

current_list = split(set_1[, 3], set_1[, 2])
current_values = sapply(current_list, avg_per_time)
current_dates = as.Date(names(current_values))

## Plot yearly data
year_2014 = which(current_dates >= as.Date("01-01-2014", "%d-%m-%Y") & current_dates <= as.Date("31-12-2014", "%d-%m-%Y"))
plot(current_values[year_2014], pch=20, type="b")

year_2015 = which(current_dates >= as.Date("01-01-2015", "%d-%m-%Y") & current_dates <= as.Date("31-12-2015", "%d-%m-%Y"))
plot(current_values[year_2015], pch=20, type="b")

year_2016 = which(current_dates >= as.Date("01-01-2016", "%d-%m-%Y") & current_dates <= as.Date("31-12-2016", "%d-%m-%Y"))
plot(current_values[year_2016], pch=20, type="b")

##############################################
## Analyze the results for a single meter
## for a single year
##############################################

library(TSA)

meter_year = current_values[year_2016]

length(meter_year)
[1] 366

acf_out = acf(as.vector(meter_year),lag.max=36, main = "ACF - Meter ID (869) - 2016")

acf_out
    Autocorrelations of series 'as.vector(meter_year)', by lag
    
      1      2      3      4      5      6      7      8      9     10     11     12     13     14     15     16     17     18     19     20 
    0.464 -0.205 -0.479 -0.484 -0.226  0.400  0.807  0.394 -0.248 -0.529 -0.518 -0.252  0.378  0.777  0.377 -0.236 -0.513 -0.506 -0.246  0.368 
    
      21     22     23     24     25     26     27     28     29     30     31     32     33     34     35     36 
    0.751  0.373 -0.219 -0.491 -0.500 -0.227  0.377  0.752  0.373 -0.218 -0.455 -0.473 -0.225  0.363  0.729  0.344 

## Estimate the periodicity in the time series    
meter_year_freq = periodogram(meter_year)

names(meter_year_freq)
[1] "freq"      "spec"      "coh"       "phase"     "kernel"    "df"        "bandwidth" "n.used"    "orig.n"    "series"    "snames"    "method"   
[13] "taper"     "pad"       "detrend"   "demean"   

length(meter_year_freq$freq)
[1] 187

top_k = sort(meter_year_freq$spec, decreasing = TRUE)[1:3]

1/meter_year_freq$freq[which(meter_year_freq$spec == top_k[1])]
[1] 6.944444

1/meter_year_freq$freq[which(meter_year_freq$spec == top_k[2])]
[1] 7.075472

1/meter_year_freq$freq[which(meter_year_freq$spec == top_k[3])]
[1] 3.504673

## ACF & PACF after removal of seasonality
meter_year_lag_7 = diff(meter_year, lag=7)

par(mfrow = c(2, 1))
acf_out_lag_7 = acf(as.vector(meter_year_lag_7),lag.max=36, main = "ACF - Meter ID (869) - 2016 - Lag = 7")
pacf_out_lag_7 = acf(as.vector(meter_year_lag_7),lag.max=36, main = "PACF - Meter ID (869) - 2016 - Lag = 7", type = "partial")

## Observed data - Before and After removal of seasonality
par(mfrow = c(2, 1))
plot(meter_year, pch=20, type="b", main = "Original Data")
plot(meter_year_lag_7, pch=20, type="b", main = "After Removal of Seasonality")

## Model 1
p = 0
d = 0
q = 1

P = 0
D = 1
Q = 1 
s = 7

## Model 2
p = 1
d = 0
q = 0

P = 3
D = 1
Q = 0 
s = 7

## Model 3 (based on data-driven approach; additional Python coding is required)

## Identify the optimal model using MSE; MSE to be calculated using 28 observations (predicted and true values)
## Use data from Jan-2016 to Oct-2018 to predict next 7 days values
## Shift the time series data set by 7 days and repeat the process 3 times

## Identify outliers using the best model
## Infer outliers in future data
## Use data from Feb-2016 to Nov-2016 to forecast values for the first 7 days in Dec

## Outliers in the trained data [additional Python coding is required]
## Use data from Feb-2016 to Nov-2016 infer predicted values for the last 7 days in Nov itself
