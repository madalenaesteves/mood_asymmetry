function heatmap_cog(data,betas);
%this script requires manual change of the labels. It generates a heatmap
%of a linear model whose independent variables are LI, sex, mood, LI*mood
%interaction.

%data is a matrix that includes LI, mood (lines are subjects). 
%betas is a vector of the model's betas (intercept, LI, sex, mood, LI*mood)


%Created by Madalena Esteves: madalena.curva.esteves@gmail.com

%Cite as: Madalena Esteves (2021). heatmap_cog
%(https://github.com/madalenaesteves/mood_asymmetry/blob/main/heatmap_cog.m).



%determines x and y ranges
min_LI=min(data(:,1));
max_LI=max(data(:,1));

min_mood=min(data(:,2));
max_mood=max(data(:,2));

%generates values within defined ranges
x=linspace(min_LI,max_LI);
y=linspace(min_mood,max_mood);

%uses the linear model to predict the dependent variable
data_plot=zeros(length(y),length(x));
for i=1:length(y);
    for j=1:length(x);
        data_plot(i,j)=betas(1)+betas(2)*x(j)+betas(4)*y(i)+betas(5)*x(j)*y(i);
    end
end

%generates heatmap and saves as tiff
h=figure(1), clf
imagesc(x,y,data_plot);
%set(gca,'xdir','reverse') %comment for AI
set(gca,'ydir','normal')
colormap('jet')
colorbar
xlabel('rostral anterior cingulate AI'), ylabel('DASS-anxiety (mean-centered)')
a=colorbar;
ylabel(a,'predicted Stroop-Chafetz','FontSize',12,'Rotation',90);
hColourbar.Label.Position(1) = 20;

Figname = strcat('AI_rostralanteriorcingulate_Stroop_Chafetz_DASS_anxiety.tiff');
                saveas(h,Figname,'tiff');
                clf

end