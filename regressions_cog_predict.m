function [results,mood_,LINaN]= regressions_cog_predict (LI,cog,sex,mood);

%this script generates linear regression where the dependent variable is
%cog and the independent variables are LI, sex, mood, and LI*mood
%interaction.

%inputs:
%LI - matrix of n subjects by n regions
%cog - vector of n subjects
%sex - vector of n subjects codified as 1 and 2
%mood - vector of n subjects

%outputs:
%results - matrix containing the regression metrics for each region in LI
%(columns). Lines 1 to 5 show p-values (intercept, LI, sex, mood, LI*mood),
%lines 7 to 11 show Bonferroni-Holm corrected p-values (intercept, LI, sex,
%mood, LI*mood), lines 13 to 17 show betas (intercept, LI, sex, mood,
%LI*mood), line 19 shows R2, line 21 shows adjusted R2, line 23 shows
%normality of the residues
%mood_ - center-normalized mood, without outliers
%LINaN - LI without outliers


%Created by Madalena Esteves: madalena.curva.esteves@gmail.com

%Cite as: Madalena Esteves (2021). regressions_cog_predict
%(https://github.com/madalenaesteves/mood_asymmetry/blob/main/regressions_cog_predict.m).


%remove outliers from cog
cog_=cog;
NaNs=[];
NaNs=isnan(cog_);
yNaN=[];
yNaN=find(NaNs==1);
nNaN=[];
nNaN=find(NaNs==0);
A=[];
A(yNaN)=NaN;
A(nNaN)=abs(zscore(cog_(nNaN)));
B=[];
B=find(A>=3);
C=isempty(B);
if C==0;
    cog_(B)=NaN;
else
end

%remove outliers from LI
LINaN=LI;
for i=1:size(LINaN,2);
    NaNs=[];
    NaNs=isnan(LINaN(:,i));
    yNaN=[];
    yNaN=find(NaNs==1);
    nNaN=[];
    nNaN=find(NaNs==0);
    A=[];
    A(yNaN)=NaN;
    A(nNaN)=abs(zscore(LINaN(nNaN,i)));
    B=[];
    B=find(A>=3);
    C=isempty(B);
    if C==0;
    LINaN(B,i)=NaN;
    else
    end
end

%center sex on 0
sex_=sex;
A=[];
A=find(sex==2);
sex_(A)=1;
B=[];
B=find(sex==1);
sex_(B)=-1;

%center mood on its average
A=[];
A=isnan(mood);
B=[];
B=find(A==0);
mood_=mood-mean(mood(B));

%initiate variables
beta_=[];
 p_=[];
 r2_= [];
 r2_adj_=[];
 res_ = [];
 data=[];
 s=[];
 normality=[];

%generate matrix of cog values of the same size as LI (useful for later) 
 cog__=[];
 for i=1:size(LINaN,2); 
 cog__(1:size(cog_,1),i)=cog_;
 end

%for each region... 
for i=1:size(LINaN,2); 
    
    %perform linear regression
    s=regstats(cog__(:,i),[LINaN(:,i) sex_ mood_ mood_.*LINaN(:,i)]);
    res_=[];
    res_=abs(s.standres);
 
    %find outliers
    B=[];
    B=find(res_>=3);
    C=isempty(B);
    if C==0;
        %remove outliers in the cog matrix
        cog__(B,i)=NaN;

        %repeat regression
        s=regstats(cog__(:,i),[LINaN(:,i) sex_ mood_ mood_.*LINaN(:,i)]);
        else
    end
 
 %store metrics   
 p_(1:size(s.tstat.pval,1), i)=s.tstat.pval (1:end);
 beta_(1:size(s.tstat.pval,1), i)=s.beta(1:end);
 r2_ (i)= s.rsquare;
 r2_adj_(i)= s.adjrsquare;
 res_(1:size(LINaN,1),i)=s.standres;
 
 normality(i)=kstest(res_(1:size(res_,1),i));
  
end

%calculate Bonferroni-Holm-corrected p-value
 for j=1:size(p_,1); 
     [cor_p, h]=bonf_holm(p_(j,:),.05);
     alpha_(j, 1:size(cor_p,2))=cor_p;
 end
B=zeros (1,size(LINaN,2));

%create table of metrics
results=[p_;B;alpha_;B;beta_;B;r2_;B;r2_adj_;B;normality];

end