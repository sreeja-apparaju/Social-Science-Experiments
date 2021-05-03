###### SIMULATIONS FOR TWO-STEP PROCESS AS USED IN SSRP

### original effect size is assumed to be 1, i.e. everything is normalized to original effect size
### alpha for a single round is 2.5%, power is 90%
### Round one uses a sample to detect 75% of the original effect; Round two auch that pooled data can detect 50%

### calculate standard deviation of sampling distribution 1, pooled sample, and of second round only
sd1=0.75/(qnorm(0.975)+qnorm(0.9));
sdp=0.5/(qnorm(0.975)+qnorm(0.9));
sd2=sqrt(1/(1/sdp^2-1/sd1^2));

###relative sample sizes: Round1:Round2 and Round1:(Round1+Round)
(sd1/sdp)^2;
(sd1/sd2)^2;
### sample size of the poooled sample is about 2.25 = (0.75/0.5)^2 larger than the first round sample

#### Iterations
NI=20; NS=1000000;
### 1. simulate process to calculate alpha of the two-step process
for (i in 1:NI)
  {
### sample
  sample1=rnorm(NS, mean=0, sd=sd1); 
  sample2=rnorm(NS, mean=0, sd=sd2);
  samplep=(sample1*sd2^2+sample2*sd1^2)/(sd2^2+sd1^2);
### one tailed z-tests for sample 1 only; pooled sample; and the two-step process
  sig1=mean(sample1/sd1>qnorm(0.975)); 
  sigp=mean(samplep/sdp>qnorm(0.975));
  sig2indep=mean(sample1/sd1>qnorm(0.975)|sample2/sd2>qnorm(0.975));
  sig2step=mean(sample1/sd1>qnorm(0.975)|samplep/sdp>qnorm(0.975))
  print(c(sig1, sigp, sig2indep, sig2step), digits=4); 
  }
### this means that we get a lower expected alpha of about 0.042 compared to a case where the two samples are independent i.e. (2*alpha-alpha^2=0.0494) 

NI=10; NS=1000000;
### 2. simulate process to calculate power to detect 50% of the original effect in the two-step process
for (i in 1:NI)
  {
### sample
  sample1=rnorm(NS, mean=0.5, sd=sd1); 
  sample2=rnorm(NS, mean=0.5, sd=sd2);
  samplep=(sample1*sd2^2+sample2*sd1^2)/(sd2^2+sd1^2);
### one tailed z-tests for sample 1 only; pooled sample only which should be 0.9 ; and the two-step process
  sig1=mean(sample1/sd1>qnorm(0.975)); 
  sigp=mean(samplep/sdp>qnorm(0.975));
  sig2step=mean(sample1/sd1>qnorm(0.975)|samplep/sdp>qnorm(0.975))
### out  
  print(c(sig1, sigp, sig2step), digits=3);
  }
### we get a power of 0.911 instead of the targeted 0.900


