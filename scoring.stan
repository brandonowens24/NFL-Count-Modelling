data {
  int<lower=1> N;
  int<lower=1> T;
  array[N] int home_team;
  array[N] int away_team;
  
  array[N] int home_rush_td;
  array[N] int away_rush_td;
  array[N] int home_pass_td;
  array[N] int away_pass_td;
  array[N] int home_ret_td;
  array[N] int away_ret_td;
  array[N] int home_def_td;
  array[N] int away_def_td;
  array[N] int home_fg;
  array[N] int away_fg;
  array[N] int home_safeties;
  array[N] int away_safeties;
  
  array[N] int home_exp;
  array[N] int home_exp_attempt;
  array[N] int away_exp;
  array[N] int away_exp_attempt;
  array[N] int home_2p;
  array[N] int home_2p_attempt;
  array[N] int away_2p;
  array[N] int away_2p_attempt;
  
  array[N] int home_td;
  array[N] int away_td;
}

parameters {
  // Intercept terms
  real<lower=-5> home_advantage_pass;
  real<lower=-5> home_advantage_rush;
  real<lower=-5> home_advantage_def;
  real<lower=-5> home_advantage_ret;
  real<lower=-5> home_advantage_safety;
  real<lower=-5> home_advantage_fg;
  real<lower=-5> int_td_pass;
  real<lower=-5> int_td_rush;
  real<lower=-5> int_td_ret;
  real<lower=-5> int_td_def;
  real<lower=-5> int_safety;
  real<lower=-5> int_fg;
  
  real<lower=0> sigma_rush;
  real<lower=0> sigma_pass;
  real<lower=0> sigma_ret;
  real<lower=0> sigma_def;
  real<lower=0> sigma_fg;
  real<lower=0> sigma_safety;
  
  real<lower=-5> mu_rush;
  real<lower=-5> mu_pass;
  real<lower=-5> mu_ret;
  real<lower=-5> mu_def;
  real<lower=-5> mu_fg;
  real<lower=-5> mu_safety;
  
  real<lower=0, upper=1> theta_ret;
  real<lower=0, upper=1> theta_def;
  real<lower=0, upper=1> theta_safety;
  
  // Decision for 2pc or exp
  array[T] simplex[2] p_attempts;
  
  // Bernoulli probs for 2pc or exp  
  vector<lower=0, upper=1>[T] bp_2p;
  vector<lower=0, upper=1>[T] bp_exp;
  
  // Raw Off/Def rates
  vector[T] att_rush_td_raw;
  vector[T] att_pass_td_raw;
  vector[T] att_ret_td_raw;
  vector[T] att_def_td_raw;
  vector[T] att_safeties_raw;
  vector[T] att_fg_raw;

  vector[T] def_rush_td_raw;
  vector[T] def_pass_td_raw;
  vector[T] def_ret_td_raw;
  vector[T] def_def_td_raw;
  vector[T] def_safeties_raw;
  vector[T] def_fg_raw;
}

transformed parameters {
  
  vector[T] att_rush_td = att_rush_td_raw - mean(att_rush_td_raw);
  vector[T] att_pass_td = att_pass_td_raw - mean(att_pass_td_raw);
  vector[T] att_ret_td = att_ret_td_raw - mean(att_ret_td_raw);
  vector[T] att_def_td = att_def_td_raw - mean(att_def_td_raw);
  vector[T] att_safeties = att_safeties_raw - mean(att_safeties_raw);
  vector[T] att_fg = att_fg_raw - mean(att_fg_raw);
  vector[T] def_rush_td = def_rush_td_raw - mean(def_rush_td_raw);
  vector[T] def_pass_td = def_pass_td_raw - mean(def_pass_td_raw);
  vector[T] def_ret_td = def_ret_td_raw - mean(def_ret_td_raw);
  vector[T] def_def_td = def_def_td_raw - mean(def_def_td_raw);
  vector[T] def_safeties = def_safeties_raw - mean(def_safeties_raw);
  vector[T] def_fg = def_fg_raw - mean(def_fg_raw);
  
   vector[T] p_exp;
   vector[T] p_2p;

   for (t in 1:T) {
     p_exp[t] = p_attempts[t][1];
     p_2p[t] = p_attempts[t][2];
   }

}

model {
  //Priors
  home_advantage_pass ~ normal(0, 0.25);
  home_advantage_rush ~ normal(0, 0.25);
  home_advantage_ret ~ normal(0, 0.25);
  home_advantage_def ~ normal(0, 0.25);
  home_advantage_safety ~ normal(0, 0.25);
  home_advantage_fg ~ normal(0, 0.25);
  int_td_pass ~ normal(0, 0.25);
  int_td_rush ~ normal(0, 0.25);
  int_td_ret ~ normal(0, 0.25);
  int_td_def ~ normal(0, 0.25);
  int_safety ~ normal(0, 0.25);
  int_fg ~ normal(0, 0.25);

  p_attempts ~ dirichlet([9, 1]);

  // HyperPrior
  mu_rush ~ normal(0, 0.25);
  sigma_rush ~ exponential(1);
  att_rush_td_raw ~ normal(mu_rush,sigma_rush);
  def_rush_td_raw ~ normal(mu_rush,sigma_rush);
  
  mu_pass ~ normal(0, 0.25);
  sigma_pass ~ exponential(1);
  att_pass_td_raw ~ normal(mu_pass,sigma_pass);  
  def_pass_td_raw ~ normal(mu_pass,sigma_pass);

  mu_ret ~ normal(0, 0.25);
  sigma_ret ~ exponential(1);
  att_ret_td_raw ~ normal(mu_ret,sigma_ret);
  def_ret_td_raw ~ normal(mu_ret,sigma_ret);
  
  mu_def ~ normal(0, 0.25);
  sigma_def ~ exponential(1);
  att_def_td_raw ~ normal(mu_def,sigma_def);
  def_def_td_raw ~ normal(mu_def,sigma_def);

  mu_fg ~ normal(0, 0.25);
  sigma_fg ~ exponential(1);
  att_fg_raw ~ normal(mu_fg,sigma_fg);
  def_fg_raw ~ normal(mu_fg,sigma_fg);
  
  mu_safety ~ normal(0, 0.25);
  sigma_safety ~ exponential(1);
  att_safeties_raw ~ normal(mu_safety,sigma_safety);
  def_safeties_raw ~ normal(mu_safety,sigma_safety);


  bp_exp ~ beta(9,1);
  bp_2p ~ beta(1,1);
  
  // Likelihoods
  home_rush_td ~ poisson_log(att_rush_td[home_team] + def_rush_td[away_team] + home_advantage_rush + int_td_rush);
  home_pass_td ~ poisson_log(att_pass_td[home_team] + def_pass_td[away_team] + home_advantage_pass + int_td_pass);
  home_ret_td ~ poisson_log(att_ret_td[home_team] + def_ret_td[away_team] + home_advantage_ret + int_td_ret);
  home_def_td ~ poisson_log(att_def_td[home_team] + def_def_td[away_team] + home_advantage_def + int_td_def);
  home_fg ~ poisson_log(att_fg[home_team] + def_fg[away_team] + home_advantage_fg + int_fg);
  home_safeties ~ poisson_log(att_safeties[home_team] + def_safeties[away_team] + home_advantage_safety + int_safety);

  away_rush_td ~ poisson_log(att_rush_td[away_team] + def_rush_td[home_team] + int_td_rush);
  away_pass_td ~ poisson_log(att_pass_td[away_team] + def_pass_td[home_team] + int_td_pass);
  away_ret_td ~ poisson_log(att_ret_td[away_team] + def_ret_td[home_team]+ int_td_ret);
  away_def_td ~ poisson_log(att_def_td[away_team] + def_def_td[home_team] + int_td_def);
  away_fg ~ poisson_log(att_fg[away_team] + def_fg[home_team] + int_fg);
  away_safeties ~ poisson_log(att_safeties[away_team] + def_safeties[home_team] + int_safety);

  for (n in 1:N) {
  
    // 2P Attempts
    home_2p_attempt[n] ~ binomial(home_exp_attempt[n] + home_2p_attempt[n],
                                  p_attempts[home_team[n]][2]);
    away_2p_attempt[n] ~ binomial(away_exp_attempt[n] + away_2p_attempt[n],
                                  p_attempts[away_team[n]][2]);
  
    // Binned successes
    home_exp[n] ~ binomial(home_exp_attempt[n], bp_exp[home_team[n]]);
    away_exp[n] ~ binomial(away_exp_attempt[n], bp_exp[away_team[n]]);
    home_2p[n]  ~ binomial(home_2p_attempt[n],  bp_2p[home_team[n]]);
    away_2p[n]  ~ binomial(away_2p_attempt[n],  bp_2p[away_team[n]]);

  }
}






