

with tb_partidos as (

    select SG_PARTIDO,
        NM_PARTIDO,
        count(SG_PARTIDO) as candidaturas

    from tb_candidaturas

    group by SG_PARTIDO

    order by SG_PARTIDO asc),

tb_genero as (
    
    select SG_PARTIDO,
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

)

select SG_PARTIDO,
        sum(masc) as qtde_masc,
        sum(fem) as qtde_fem,
        count(SG_PARTIDO),
        round(cast(sum(fem) as real) / cast(count(SG_PARTIDO) as real),2) as tx_fem

from tb_genero

group by SG_PARTIDO

order by tx_fem desc




