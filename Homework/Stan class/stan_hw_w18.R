
library(rstan) #attach Rstan package
#options(mc.cores = parallel::detectCores()) #let Stan use multiple cores

library(ncdf4)

setwd('C:/Users/Faizan/Documents/GitHub/Projects/Homework/Stan class')  #setwd(<wd must contain .stan file>)
#setwd('C:\Users\Faizan\Documents\GitHub\Projects\Homework\Stan class')

fname <- 'global_omi_sl_area_averaged_mean_19930101_P20180220.nc'
myncdf <- nc_open(fname)
t <- ncvar_get( myncdf, 'time' )
tp = t-15706
s <- ncvar_get( myncdf, 'sla' )
n = length(t)
plot(tp,s,type = 'l', xlab= 'days', ylab="Average global mean sea level (m)")

#set.seed(123)
#n <- 100
#x <- seq(0.1, 5, 0.1)
#y <- sin(a)
mydata <- list(N = n, y = s, x=tp)


fit <- stan(file = 'stan_hw_w18.stan', data = mydata, 
            iter = 1000, chains = 1, warmup = 500)
#plot(x,y)
result <- extract(fit)
hist(result$beta)
summary(lm(s~tp))

int = -4.24e-03
beta = 9.202e-06
y_p = int + beta*tp
diff_y = s-y_p
plot(tp,diff_y,'l',xlab= 'days', ylab="(m)")

