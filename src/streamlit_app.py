#%%
import pandas as pd
import os
import streamlit as st
import matplotlib.pyplot as plt
import seaborn as sns
from adjustText import adjust_text
from sklearn.cluster import KMeans
 #%%

app_path = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.dirname(app_path)
base_path = os.path.dirname(src_path)
data_path = os.path.join(src_path, "data")

filmename = os.path.join(data_path, 'query_categorias_v2.parquet')

@st.cache_data(ttl=60*60*24)
def carregar_dados():
    df = pd.read_parquet(filmename)
    return df

df = carregar_dados()

ufs = df[['SG_UF']].drop_duplicates().reset_index(drop=True)

cargos = df[['DS_CARGO']].drop_duplicates()

#%%
colunas = {"TAXA FEMININO" : 'txfem', 
           "TAXA MASCULINO" : 'txmasc', 
           "TAXA PRETOS" : 'txPretos', 
           "TAXA BRANCOS" : 'txBrancos', 
           "TAXA PARDOS" : 'txtPardos', 
           "TAXA INDIGENA" : 'txtIndigena',
           "TAXA AMARELOS" : 'txAmarelo', 
           "TAXA CASSADOS" : 'txcassado', 
           "TAXA EDUCAÇÃO MÉDIO" : 'txEDUC_MEDIO',
           "TAXA EDUCAÇÃO SUPERIOR" : 'txEDUC_SUPERIOR',
           "TAXA EDUCAÇÃO FUNDAMENTAL" : 'txEDUC_FUNDAMENTAL',
           "TAXA SOLTEIRO" : 'txSOLTEIRO',
           "TAXA CASADO" : 'txCASADO',
           "TAXA DIVORCIADO" : 'txDIVORCIADO',
           "IDADE" : 'med_idade'}
#%%
chaves = ["TAXA FEMININO",
            "TAXA MASCULINO",        
            "TAXA PRETOS",          
            "TAXA BRANCOS",           
            "TAXA PARDOS",          
            "TAXA INDIGENA",
            "TAXA AMARELOS",           
            "TAXA CASSADOS",           
            "TAXA EDUCAÇÃO MÉDIO",
            "TAXA EDUCAÇÃO SUPERIOR",
            "TAXA EDUCAÇÃO FUNDAMENTAL",
            "TAXA SOLTEIRO",           
            "TAXA CASADO",        
            "TAXA DIVORCIADO",
            "IDADE"]

#%%
st.title('Eleições 2024 - Análise candidatos')

def about():

    st.markdown('''Este repositório tem como objetivo explorar 
                 ferramentas de análise de dados, utilizando 
                os dados abertos dos candidatos às eleições de 2024.
                ''')

    st.markdown('[Dados Abertos TSE](https://dadosabertos.tse.jus.br/dataset/candidatos-2024)')
    st.markdown('[Repositório GitHub](https://github.com/andrepeersil/tse-eleicoes-2024)')


with st.sidebar:
    uf = st.selectbox(
        "Estado:",
        (ufs),
    )

with st.sidebar:
    cargo = st.selectbox(
        "Cargo:",
        (cargos),
    )

with st.sidebar:
    x = st.selectbox(
        "Eixo X:",
        list(chaves),
    )
chaves.remove(x)
with st.sidebar:
    y = st.selectbox(
        "Eixo Y:",
        list(chaves),
        index=1
    )

with st.sidebar:
    bolhas = st.checkbox("Bolhas(Total Cand.)")

with st.sidebar:
    cluster = st.checkbox("Clusterização")

with st.sidebar:
    n_clusters = st.slider("Nº clusters?", 1, 8)

with st.sidebar:
    about()

#%%
df_select = df[(df['SG_UF']==uf) & (df['DS_CARGO']==cargo)]
df_select = df_select[['SG_PARTIDO', 'SG_UF', 'totalcandidatos', colunas[x], colunas[y]]]

st.write(f"Total candidatos: {df_select['totalcandidatos'].sum()}")

#%%

ymedio = df_select[colunas[y]].mean()
xmedio = df_select[colunas[x]].mean()

ymin = df_select[colunas[y]].min()
xmin = df_select[colunas[x]].min()

ymax = df_select[colunas[y]].max()
xmax = df_select[colunas[x]].max()

fig = plt.figure(figsize=(6, 6),dpi=100)

if bolhas:
    bolhas = 'totalcandidatos'

if cluster:
    X = df_select[[colunas[x], colunas[y]]]
    kmeans = KMeans(n_clusters=n_clusters, random_state=0, n_init="auto")
    kmeans.fit(X)
    cluster = kmeans.labels_
    
else:
    cluster = None

sns.scatterplot(
    data = df_select, 

    x = colunas[x],
    y = colunas[y],
    
    size=bolhas,
    alpha = .6,

    legend=False,
    sizes=(20, 200),

    hue = cluster,
    palette = 'Set2'
    )

nomes_partidos = df_select['SG_PARTIDO'].to_list()

x_nome = df_select[colunas[x]].to_list()
y_nome = df_select[colunas[y]].to_list()

texts = [plt.text(x_nome[i], y_nome[i], nomes_partidos[i], fontsize=10) for i in range(len(x_nome))]
adjust_text(texts,
        arrowprops=dict(arrowstyle='->', color='red',alpha=.5)
        );

plt.suptitle(f"{x.capitalize()} x {y.capitalize()}", fontsize=14) 
plt.title(f"Estado - {uf}", fontsize=12)  

plt.xlabel(x, fontsize=10) 
plt.ylabel(y, fontsize=10) 

if y == 'IDADE':
    media_y = f"{y}: {round(ymedio,1)} anos"
else:
    media_y = f"{y}: {round(100*ymedio,1)}%"

if x == 'IDADE':
    media_x = f"{x}: {round(xmedio,1)} anos"
else:
    media_x = f"{x}: {round(100*xmedio,1)}%"



plt.hlines(y=ymedio,xmin=xmin, xmax=xmax, linestyles='--', colors='green', label=media_y.capitalize())
plt.vlines(x=xmedio, ymin=ymin, ymax=ymax, linestyles='--', colors='orange',label=media_x.capitalize() )

plt.legend(loc="upper center", bbox_to_anchor=(0.5, -0.15)) 

plt.grid(True)

st.pyplot(fig=fig)
