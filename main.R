######Projet final STA203 - Apprentissage supervisé########
###########################################################

# Nom1 = Limes    
# Nom2 = Perdrix

rm(list=objects()); graphics.off()

setwd("C:/Users/lucie/OneDrive/Documents/Documents/ENSTA/2A/STA203/PROJETSTA203")

#Package
library(ggplot2)
library(GGally)
library(corrplot)
library(caret)


#Importation des données
df=read.table("Music_2023.txt",dec='.',header=TRUE,sep=';')

##########################################################################################################################################
##########################################################################################################################################
##########################################################Partie I########################################################################
##########################################################################################################################################
##########################################################################################################################################

################
### Q1
################

####Analyse univarié
summary(df)  #Toutes les variables sauf la dernière sont numériques
str(df)


####Analyse bivariée (à voir)
#ggpairs(df[,-192],ggplot2::aes(colour=df$GENRE))

#pairs(X[,-192])   #On enlève la première colonne pour l'analyse
#corrplot(cor(X[,-192]))


####Proportion de chacun des genres
p_classique=sum(df$GENRE=="Classical")/length(df$GENRE)  #0.53
p_jazz=sum(df$GENRE=="Jazz")/length(df$GENRE)            #0.47

####PAR_SC_V, PAR_ASC_V
summary(df$PAR_SC_V)
mean(df$PAR_SC_V)      #105222.8

summary(df$PAR_ASC_V)
mean(df$PAR_ASC_V)     #0.4251288
#Le passage au log peut-être judicieux pour normaliser les valeurs
df$PAR_SC_V=log(df$PAR_SC_V)
df$PAR_ASC_V=log(df$PAR_ASC_V)

####D'après l'annexe, les paramètres 148 à 167 sont les mêmes que les paramètres 128 à 147 donc on peut les supprimer
df=cbind(df[1:147],df[168:192])


####Variable très corrélées 
C=cor(df[,-172])

#Récupération des variables à supprimer(>.99)
highly_cor=findCorrelation(C,cutoff=0.99)

#Ajout d'un code poursupprimer la bonne variable dans le couple ? 

#Suppression des variables
df=df[,-highly_cor]

####Définition du modèle logistique

model = function(formule,data)
{
  return(glm(formule, family=binomial(link="logit"),data=data))
}
#Binomial car on veut expliquer une variable binaire 

################
### Q2
################
set.seed(103)
n=nrow(df)
train=sample(c(TRUE,FALSE),n,rep=TRUE,prob=c(2/3,1/3))

################
### Q3
################

df$GENRE=as.numeric(factor(df$GENRE))-1
####Modele0####
###############
formule0<-GENRE~PAR_TC + PAR_SC + PAR_SC_V + PAR_ASE_M + PAR_ASE_MV + PAR_SFM_M + PAR_SFM_MV
Mod0<-model(formule0,data=df[train==TRUE,])

####ModeleT####
###############
formuleT<-GENRE~.
ModT<-model(formuleT,data=df[train==TRUE,])

####Modele1####
###############

####Récupérations des variables significatives
library(stats)
ind_variables_nonsign=which(summary(ModT)$coefficients[,4]>=0.05)
names(df)[ind_variables_nonsign]

####Mis à jour du modèle en supprimant les variables significatives
formule1<-GENRE~.-PAR_TC-PAR_SC-PAR_SC_V-PAR_ASE1-PAR_ASS_V-PAR_SFMV2-PAR_SFMV3-PAR_SFMV4-PAR_SFMV5-PAR_SFMV6-PAR_SFMV7-PAR_SFMV8-PAR_SFMV9-PAR_SFMV10-
  PAR_SFMV11-PAR_SFMV12-PAR_SFMV13-PAR_SFMV14-PAR_SFMV15-PAR_SFMV16-PAR_SFMV17-PAR_SFMV18-PAR_SFMV19-PAR_SFMV20-PAR_SFMV21-PAR_SFMV22-PAR_SFMV23-PAR_SFMV24-
  PAR_SFM_MV-PAR_MFCC1-PAR_MFCC2-PAR_MFCC3-PAR_MFCC6-PAR_MFCC7-PAR_MFCC8-PAR_MFCC12-PAR_MFCC14-PAR_MFCC15-PAR_MFCC16-PAR_MFCC17-PAR_MFCC18-PAR_THR_3RMS_TOT-
  PAR_THR_1RMS_10FR_MEAN-PAR_THR_1RMS_10FR_VAR-PAR_THR_2RMS_10FR_MEAN-PAR_PEAK_RMS_TOT-PAR_PEAK_RMS10FR_MEAN-PAR_PEAK_RMS10FR_VAR-PAR_1RMS_TCD-PAR_2RMS_TCD-
  PAR_3RMS_TCD-PAR_ZCD_10FR_MEAN-PAR_ZCD_10FR_VAR-PAR_1RMS_TCD_10FR_MEAN-PAR_1RMS_TCD_10FR_VAR-PAR_2RMS_TCD_10FR_MEAN-PAR_2RMS_TCD_10FR_VAR-PAR_3RMS_TCD_10FR_MEAN-
  PAR_3RMS_TCD_10FR_VAR
Mod1=model(formule1,data=df[train==TRUE,])

####Modele2####
###############

####Récupérations des variables significatives
ind_variables_nonsign=which(summary(ModT)$coefficients[,4]>=0.2)
nom_variables_nonsign=names(df)[ind_variables_nonsign]

####Mis à jour du modèle en supprimant les variables significatives
formule2<-GENRE~.-PAR_SC-PAR_SC_V-PAR_ASE1-PAR_ASS_V-PAR_SFMV2-PAR_SFMV3-PAR_SFMV4-PAR_SFMV5-PAR_SFMV6-PAR_SFMV7-PAR_SFMV8-PAR_SFMV9-PAR_SFMV10-
  PAR_SFMV11-PAR_SFMV12-PAR_SFMV13-PAR_SFMV14-PAR_SFMV15-PAR_SFMV16-PAR_SFMV17-PAR_SFMV18-PAR_SFMV19-PAR_SFMV20-PAR_SFMV21-PAR_SFMV22-PAR_SFMV23-PAR_SFMV24-
  PAR_SFM_MV-PAR_MFCC1-PAR_MFCC6-PAR_MFCC8-PAR_MFCC15-PAR_MFCC16-PAR_MFCC17-
  PAR_THR_1RMS_10FR_MEAN-PAR_THR_2RMS_10FR_MEAN-PAR_PEAK_RMS_TOT-PAR_PEAK_RMS10FR_VAR-PAR_1RMS_TCD-
  PAR_ZCD_10FR_MEAN-PAR_ZCD_10FR_VAR-PAR_1RMS_TCD_10FR_MEAN-PAR_2RMS_TCD_10FR_MEAN-PAR_3RMS_TCD_10FR_MEAN-
  PAR_3RMS_TCD_10FR_VAR
Mod2=model(formule2,data=df[train==TRUE,])

####ModAIC####
###############
library(MASS)
#ModAIC=stepAIC(ModT,scope=list(upper=GENRE~.,lower=GENRE~1))

################
### Q4
################
library(ROCR)
library(pROC)

####Premier graph
#Echantillon apprentissage
pred=predict(ModT)
ROC_T_train=roc(df$GENRE[train==TRUE],pred)
plot(ROC_T_train, xlab="", col="blue",main="courbes ROC")

#Echantillon test
pred=predict(ModT,newdata=df[train==FALSE,])
ROC_T_test=roc(df$GENRE[train==FALSE],pred)
lines(ROC_T_test, xlab="", col="red",main="courbes ROC")

legend(0.4,0.2,legend=c("Apprentissage","Test"),col=c("blue","red"),lty=1)
#Règle parfaite
#lines(0:length(ROC_T_test)/1:length(ROC_T_test)) à voir comment faire

pred=predict(ModT,newdata=df[train==FALSE,])
ROC_T_test=roc(df$GENRE[train==FALSE],pred)
plot(ROC_T_test, xlab="", col=1,main="Superposition courbes ROC")

pred=predict(Mod1,newdata=df[train==FALSE,])
ROC_1_test=roc(df$GENRE[train==FALSE],pred)
lines(ROC_1_test, xlab="", col=2,main="Superposition courbes ROC")

pred=predict(Mod2,newdata=df[train==FALSE,])
ROC_2_test=roc(df$GENRE[train==FALSE],pred)
lines(ROC_2_test, xlab="", col=3,main="Superposition courbes ROC")

legend(0.6,0.2,legend=c(paste("ModT :",toString(auc(ROC_T_test))),paste("Mod1 :",toString(auc(ROC_1_test))),paste("Mod2 :",toString(auc(ROC_2_test)))), col=c(1:3),lty=1)
##########################################################################################################################################
##########################################################################################################################################
##########################################################Partie II#######################################################################
##########################################################################################################################################
##########################################################################################################################################
################
### Q1
################

################
### Q2
################
library(glmnet)
df=read.table("Music_2023.txt",dec='.',header=TRUE,sep=';')
grid = 10^seq(10,-2,length=100)
x = as.matrix(df[,-ncol(df)])
y = as.numeric(factor(df$GENRE))-1
ridge.fit = glmnet(x,y,alpha=0,lambda=grid)


