#%% 

import pandas as pd
import sqlalchemy
import os

#%%

current_dir = os.path.dirname(__file__)
file_path = os.path.join(current_dir, 'queries.sql')

with open(file_path, 'r', encoding='utf-8') as open_file:
    query = open_file.read()

engine = sqlalchemy.create_engine('sqlite:///../data/database.db')

#%%

df = pd.read_sql_query(query, engine )

#%%
df_graf = df[['SG_PARTIDO', 'txfemBR', 'txPretosBR' ]]
# df_graf = df_graf.set_index('SG_PARTIDO')
#%%
import streamlit as st

#%%
import matplotlib
matplotlib.use('Qt5Agg')
import matplotlib.pyplot as plt
import seaborn as sns

#%%
df_graf
#%%
plt.figure(dpi=500)
sns.scatterplot(
    data=df_graf, 
    x='txfemBR', 
    y='txPretosBR')

for i in len(df_graf['SG_PARTIDO']): 
    plt.annotate(df_graf['SG_PARTIDO'][i], (df_graf['txfemBR'], df_graf['txPretosBR']))

plt.show()


# plt.savefig('../img/distribuicao.png' )
#%%

df_graf.loc[0]