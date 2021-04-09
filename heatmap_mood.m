function heatmap_mood(data,betas);
%this script requires manual change of the labels. It generates a heatmap
%of a linear model whose independent variables are LI, sex, LI*sex
%interaction.

%data is a vector of LI (lines are subjects). 
%betas is a vector of the model's betas (intercept, LI, sex, LI*sex)


%Created by Madalena Esteves: madalena.curva.esteves@gmail.com

%Cite as: Madalena Esteves (2021). heatmap_mood
%(https://github.com/madalenaesteves/mood_asymmetry/blob/main/heatmap_mood.m).



%determines x range
min_LI=min(data(:,1));
max_LI=max(data(:,1));

%generates values within defined range
x=linspace(min_LI,max_LI);

%generates y (male vs female)
y=[-1,1];

%uses the linear model to predict the dependent variable
data_plot=zeros(length(y),length(x));
for i=1:length(y);
    for j=1:length(x);
        data_plot(i,j)=betas(1)+betas(2)*x(j)+betas(3)*y(i)+betas(4)*x(j)*y(i);
    end
end

%generates heatmap and saves as tiff
h=figure(1), clf
imagesc(x,y,data_plot);
set(gca,'xdir','reverse') %comment for AI
set(gca,'ydir','normal')
yticks([-1 1])
yticklabels({'female','male'})
colormap('jet')
colorbar
xlabel('fusiform LI')
a=colorbar;
ylabel(a,'predicted PSS','FontSize',12,'Rotation',90);
hColourbar.Label.Position(1) = 20;

Figname = strcat('LI_fusiform_PSS.tiff');
                saveas(h,Figname,'tiff');
                clf    
           
end