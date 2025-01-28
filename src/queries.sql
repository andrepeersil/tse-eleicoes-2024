

with tb_partidos as (

    select SG_PARTIDO,
        SG_UF,
        NM_PARTIDO,
        count(SG_PARTIDO) as candidaturas

    from tb_candidaturas

    group by SG_PARTIDO

    order by SG_PARTIDO asc),

tb_genero as (
    
    select SG_PARTIDO,
        SG_UF,
        SQ_CANDIDATO,
        DS_GENERO,

    case
        when DS_GENERO = 'MASCULINO' then 1
        else 0
    end as masc,

    case
        when DS_GENERO = 'FEMININO' then 1
        else 0
    end as fem

    from tb_candidaturas

),

tb_cor_candidato as (
select SQ_CANDIDATO,
    SG_UF,
    SG_PARTIDO,
    case when DS_COR_RACA = 'BRANCA' then 1 else 0 end as cor_BRANCA,
    case when DS_COR_RACA = 'PARDA' then 1 else 0 end as cor_PARDA,
    case when DS_COR_RACA = 'PRETA' then 1 else 0 end as cor_PRETA,
    case when DS_COR_RACA = 'NÃO INFORMADO' then 1 else 0 end as cor_NAO_INFORMADO,
    case when DS_COR_RACA = 'INDÍGENA' then 1 else 0 end as cor_INDÍGENA,
    case when DS_COR_RACA = 'AMARELA' then 1 else 0 end as cor_AMARELA,
    case when DS_COR_RACA = 'NÃO DIVULGÁVEL' then 1 else 0 end as cor_DIVULGAVEL

from tb_candidaturas
),

tb_cor_genero as (
select t1.SQ_CANDIDATO,
        t1.SG_PARTIDO,
        t1.SG_UF,
        t1.masc,
        t1.fem,
        t2.cor_BRANCA,
        t2.cor_PARDA,
        t2.cor_PRETA,
        t2.cor_NAO_INFORMADO,
        t2.cor_INDÍGENA,
        t2.cor_AMARELA,
        t2.cor_DIVULGAVEL

from tb_genero as t1

left join tb_cor_candidato as t2
on t1.SQ_CANDIDATO = t2.SQ_CANDIDATO
)


select SG_PARTIDO,
    SG_UF,
    sum(fem),
    count(*),
    sum(fem) / (1.0 * count(*)) as txfem,
    
from tb_cor_genero
group by 1,2



