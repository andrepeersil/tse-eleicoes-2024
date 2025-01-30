#%% 

import pandas as pd
import sqlalchemy
import os

#%%

current_dir = os.path.dirname(__file__)
file_path = os.path.join(current_dir, 'partidos_por_uf.sql')

with open(file_path, 'r', encoding='utf-8') as open_file:
    query = open_file.read()

engine = sqlalchemy.create_engine('sqlite:///../data/database.db')

#%%

df = pd.read_sql_query(query, engine )

#%%
df_graf = df[['SG_PARTIDO', 'txfemBR', 'txPretosBR', 'totalcandidatosBR']]
# df_graf = df_graf.set_index('SG_PARTIDO')

#%%
import matplotlib
matplotlib.use('Qt5Agg')
import matplotlib.pyplot as plt
import seaborn as sns
#%%
from adjustText import adjust_text

#%%

ymedio = df_graf['txPretosBR'].mean()
xmedio = df_graf['txfemBR'].mean()

ymin = df_graf['txPretosBR'].min()
xmin = df_graf['txfemBR'].min()

ymax = df_graf['txPretosBR'].max()
xmax = df_graf['txfemBR'].max()

#%%
from sklearn.cluster import KMeans


X = df_graf[['txfemBR', 'txPretosBR']]

kmeans = KMeans(n_clusters=6, random_state=0, n_init="auto")
kmeans.fit(X)
kmeans.labels_

#%%
plt.figure(figsize=(15, 8),dpi=120)

sns.scatterplot(
    data=df_graf, 
    x='txfemBR', 
    y='txPretosBR',
    
    size='totalcandidatosBR',
    legend=False,
    sizes=(5, 200),
    
    hue = kmeans.labels_,
    palette = 'Set2',
    alpha = .6,
    )

nomes_partidos = df_graf['SG_PARTIDO'].to_list()
x = df_graf['txfemBR'].to_list()
y = df_graf['txPretosBR'].to_list()

texts = [plt.text(x[i], y[i], nomes_partidos[i], fontsize=10) for i in range(len(x))]
adjust_text(texts,
        arrowprops=dict(arrowstyle='->', color='red')
        );

plt.xticks(fontsize=10) 
plt.yticks(fontsize=10) 

plt.suptitle("Candidaturas de Mulheres x Candidaturas de Pessoas Pretas", fontsize=14) 
plt.title("Eleições Municipais - 2024 - Brasil", fontsize=12)  

plt.xlabel("Candidaturas de Mulheres", fontsize=10) 
plt.ylabel("Candidaturas de Pessoas Pretas", fontsize=10) 

plt.hlines(y=ymedio,xmin=xmin, xmax=xmax, linestyles='--', colors='green', label=f"Média Pessoas Pretas: {round(100*ymedio,1)}%")
plt.vlines(x=xmedio, ymin=ymin, ymax=ymax, linestyles='--', colors='orange',label=  f"Média Mulheres: {round(100* xmedio,1)}%")

plt.legend() 

plt.grid(True)

plt.savefig('../img/grafico_mulherxpretos_v3.png',format='png')

plt.show()

#%%