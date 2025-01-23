#%% 

import pandas as pd
import sqlalchemy

#%%


path  = "../data/consulta_cand_2024/consulta_cand_2024_BRASIL.csv"

df = pd.read_csv(path, encoding='latin-1', sep= ';')

print(df)
#%%
