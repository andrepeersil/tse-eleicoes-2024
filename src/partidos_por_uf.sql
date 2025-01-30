

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
),

tb_taxas as(
    select SG_PARTIDO,
        SG_UF,

        sum(fem) as totalfem,
        count(*) totalcandidatos,
        sum(fem) / (1.0 * count(*)) as txfem,

        sum(cor_PRETA) as totalPretos,
        sum(cor_PRETA) / (1.0 * count(*)) as txPretos
        
    from tb_cor_genero
    group by 1,2

),

tb_checar as(
    select SG_PARTIDO,
        -- SG_UF,

        sum(fem) as totalfem,
        sum(fem) / (1.0 * count(*)) as txfem,

        sum(cor_PRETA) as totalPretos,
        sum(cor_PRETA) / (1.0 * count(*)) as txPretos
        
    from tb_cor_genero
    group by 1
    order by txfem

),

tb_infos as (select SG_PARTIDO,

    -- Porcentagem de candidaturas femininas
    (1.0 * sum(totalfem)) / (1.0 * sum(totalcandidatos)) as txfemBR,
    sum(case when SG_UF = 'AC' then txfem else 0 end) as txfemAC,
    sum(case when SG_UF = 'AL' then txfem else 0 end) as txfemAL,
    sum(case when SG_UF = 'AM' then txfem else 0 end) as txfemAM,
    sum(case when SG_UF = 'AP' then txfem else 0 end) as txfemAP,
    sum(case when SG_UF = 'BA' then txfem else 0 end) as txfemBA,
    sum(case when SG_UF = 'CE' then txfem else 0 end) as txfemCE,
    sum(case when SG_UF = 'ES' then txfem else 0 end) as txfemES,
    sum(case when SG_UF = 'GO' then txfem else 0 end) as txfemGO,
    sum(case when SG_UF = 'MA' then txfem else 0 end) as txfemMA,
    sum(case when SG_UF = 'MG' then txfem else 0 end) as txfemMG,
    sum(case when SG_UF = 'MS' then txfem else 0 end) as txfemMS,
    sum(case when SG_UF = 'MT' then txfem else 0 end) as txfemMT,
    sum(case when SG_UF = 'PA' then txfem else 0 end) as txfemPA,
    sum(case when SG_UF = 'PB' then txfem else 0 end) as txfemPB,
    sum(case when SG_UF = 'PE' then txfem else 0 end) as txfemPE,
    sum(case when SG_UF = 'PI' then txfem else 0 end) as txfemPI,
    sum(case when SG_UF = 'PR' then txfem else 0 end) as txfemPR,
    sum(case when SG_UF = 'RJ' then txfem else 0 end) as txfemRJ,
    sum(case when SG_UF = 'RN' then txfem else 0 end) as txfemRN,
    sum(case when SG_UF = 'RO' then txfem else 0 end) as txfemRO,
    sum(case when SG_UF = 'RR' then txfem else 0 end) as txfemRR,
    sum(case when SG_UF = 'RS' then txfem else 0 end) as txfemRS,
    sum(case when SG_UF = 'SC' then txfem else 0 end) as txfemSC,
    sum(case when SG_UF = 'SE' then txfem else 0 end) as txfemSE,
    sum(case when SG_UF = 'SP' then txfem else 0 end) as txfemSP,
    sum(case when SG_UF = 'TO' then txfem else 0 end) as txfemTO,

    -- Total de candidaturas femininas
    sum(totalfem) as sumfemBR,
    sum(case when SG_UF = 'AC' then totalfem else 0 end) as sumfemAC,
    sum(case when SG_UF = 'AL' then totalfem else 0 end) as sumfemAL,
    sum(case when SG_UF = 'AM' then totalfem else 0 end) as sumfemAM,
    sum(case when SG_UF = 'AP' then totalfem else 0 end) as sumfemAP,
    sum(case when SG_UF = 'BA' then totalfem else 0 end) as sumfemBA,
    sum(case when SG_UF = 'CE' then totalfem else 0 end) as sumfemCE,
    sum(case when SG_UF = 'ES' then totalfem else 0 end) as sumfemES,
    sum(case when SG_UF = 'GO' then totalfem else 0 end) as sumfemGO,
    sum(case when SG_UF = 'MA' then totalfem else 0 end) as sumfemMA,
    sum(case when SG_UF = 'MG' then totalfem else 0 end) as sumfemMG,
    sum(case when SG_UF = 'MS' then totalfem else 0 end) as sumfemMS,
    sum(case when SG_UF = 'MT' then totalfem else 0 end) as sumfemMT,
    sum(case when SG_UF = 'PA' then totalfem else 0 end) as sumfemPA,
    sum(case when SG_UF = 'PB' then totalfem else 0 end) as sumfemPB,
    sum(case when SG_UF = 'PE' then totalfem else 0 end) as sumfemPE,
    sum(case when SG_UF = 'PI' then totalfem else 0 end) as sumfemPI,
    sum(case when SG_UF = 'PR' then totalfem else 0 end) as sumfemPR,
    sum(case when SG_UF = 'RJ' then totalfem else 0 end) as sumfemRJ,
    sum(case when SG_UF = 'RN' then totalfem else 0 end) as sumfemRN,
    sum(case when SG_UF = 'RO' then totalfem else 0 end) as sumfemRO,
    sum(case when SG_UF = 'RR' then totalfem else 0 end) as sumfemRR,
    sum(case when SG_UF = 'RS' then totalfem else 0 end) as sumfemRS,
    sum(case when SG_UF = 'SC' then totalfem else 0 end) as sumfemSC,
    sum(case when SG_UF = 'SE' then totalfem else 0 end) as sumfemSE,
    sum(case when SG_UF = 'SP' then totalfem else 0 end) as sumfemSP,
    sum(case when SG_UF = 'TO' then totalfem else 0 end) as sumfemTO,

    -- Porcentagem de candidatos pretos

    (1.0 * sum(totalPretos)) / (1.0 * sum(totalcandidatos)) as txPretosBR,
    sum(case when SG_UF = 'AC' then txPretos else 0 end) as txPretosAC,
    sum(case when SG_UF = 'AL' then txPretos else 0 end) as txPretosAL,
    sum(case when SG_UF = 'AM' then txPretos else 0 end) as txPretosAM,
    sum(case when SG_UF = 'AP' then txPretos else 0 end) as txPretosAP,
    sum(case when SG_UF = 'BA' then txPretos else 0 end) as txPretosBA,
    sum(case when SG_UF = 'CE' then txPretos else 0 end) as txPretosCE,
    sum(case when SG_UF = 'ES' then txPretos else 0 end) as txPretosES,
    sum(case when SG_UF = 'GO' then txPretos else 0 end) as txPretosGO,
    sum(case when SG_UF = 'MA' then txPretos else 0 end) as txPretosMA,
    sum(case when SG_UF = 'MG' then txPretos else 0 end) as txPretosMG,
    sum(case when SG_UF = 'MS' then txPretos else 0 end) as txPretosMS,
    sum(case when SG_UF = 'MT' then txPretos else 0 end) as txPretosMT,
    sum(case when SG_UF = 'PA' then txPretos else 0 end) as txPretosPA,
    sum(case when SG_UF = 'PB' then txPretos else 0 end) as txPretosPB,
    sum(case when SG_UF = 'PE' then txPretos else 0 end) as txPretosPE,
    sum(case when SG_UF = 'PI' then txPretos else 0 end) as txPretosPI,
    sum(case when SG_UF = 'PR' then txPretos else 0 end) as txPretosPR,
    sum(case when SG_UF = 'RJ' then txPretos else 0 end) as txPretosRJ,
    sum(case when SG_UF = 'RN' then txPretos else 0 end) as txPretosRN,
    sum(case when SG_UF = 'RO' then txPretos else 0 end) as txPretosRO,
    sum(case when SG_UF = 'RR' then txPretos else 0 end) as txPretosRR,
    sum(case when SG_UF = 'RS' then txPretos else 0 end) as txPretosRS,
    sum(case when SG_UF = 'SC' then txPretos else 0 end) as txPretosSC,
    sum(case when SG_UF = 'SE' then txPretos else 0 end) as txPretosSE,
    sum(case when SG_UF = 'SP' then txPretos else 0 end) as txPretosSP,
    sum(case when SG_UF = 'TO' then txPretos else 0 end) as txPretosTO,

    -- Total de candidatos pretos
    sum(totalPretos) as totalPretosBR,
    sum(case when SG_UF = 'AC' then totalPretos else 0 end) as totalPretosAC,
    sum(case when SG_UF = 'AL' then totalPretos else 0 end) as totalPretosAL,
    sum(case when SG_UF = 'AM' then totalPretos else 0 end) as totalPretosAM,
    sum(case when SG_UF = 'AP' then totalPretos else 0 end) as totalPretosAP,
    sum(case when SG_UF = 'BA' then totalPretos else 0 end) as totalPretosBA,
    sum(case when SG_UF = 'CE' then totalPretos else 0 end) as totalPretosCE,
    sum(case when SG_UF = 'ES' then totalPretos else 0 end) as totalPretosES,
    sum(case when SG_UF = 'GO' then totalPretos else 0 end) as totalPretosGO,
    sum(case when SG_UF = 'MA' then totalPretos else 0 end) as totalPretosMA,
    sum(case when SG_UF = 'MG' then totalPretos else 0 end) as totalPretosMG,
    sum(case when SG_UF = 'MS' then totalPretos else 0 end) as totalPretosMS,
    sum(case when SG_UF = 'MT' then totalPretos else 0 end) as totalPretosMT,
    sum(case when SG_UF = 'PA' then totalPretos else 0 end) as totalPretosPA,
    sum(case when SG_UF = 'PB' then totalPretos else 0 end) as totalPretosPB,
    sum(case when SG_UF = 'PE' then totalPretos else 0 end) as totalPretosPE,
    sum(case when SG_UF = 'PI' then totalPretos else 0 end) as totalPretosPI,
    sum(case when SG_UF = 'PR' then totalPretos else 0 end) as totalPretosPR,
    sum(case when SG_UF = 'RJ' then totalPretos else 0 end) as totalPretosRJ,
    sum(case when SG_UF = 'RN' then totalPretos else 0 end) as totalPretosRN,
    sum(case when SG_UF = 'RO' then totalPretos else 0 end) as totalPretosRO,
    sum(case when SG_UF = 'RR' then totalPretos else 0 end) as totalPretosRR,
    sum(case when SG_UF = 'RS' then totalPretos else 0 end) as totalPretosRS,
    sum(case when SG_UF = 'SC' then totalPretos else 0 end) as totalPretosSC,
    sum(case when SG_UF = 'SE' then totalPretos else 0 end) as totalPretosSE,
    sum(case when SG_UF = 'SP' then totalPretos else 0 end) as totalPretosSP,
    sum(case when SG_UF = 'TO' then totalPretos else 0 end) as totalPretosTO,

    -- Numeros totais de Candidatos
    sum(totalcandidatos) as totalcandidatosBR,
    sum(case when SG_UF = 'AC' then totalcandidatos else 0 end) as totalcandidatosAC,
    sum(case when SG_UF = 'AL' then totalcandidatos else 0 end) as totalcandidatosAL,
    sum(case when SG_UF = 'AM' then totalcandidatos else 0 end) as totalcandidatosAM,
    sum(case when SG_UF = 'AP' then totalcandidatos else 0 end) as totalcandidatosAP,
    sum(case when SG_UF = 'BA' then totalcandidatos else 0 end) as totalcandidatosBA,
    sum(case when SG_UF = 'CE' then totalcandidatos else 0 end) as totalcandidatosCE,
    sum(case when SG_UF = 'ES' then totalcandidatos else 0 end) as totalcandidatosES,
    sum(case when SG_UF = 'GO' then totalcandidatos else 0 end) as totalcandidatosGO,
    sum(case when SG_UF = 'MA' then totalcandidatos else 0 end) as totalcandidatosMA,
    sum(case when SG_UF = 'MG' then totalcandidatos else 0 end) as totalcandidatosMG,
    sum(case when SG_UF = 'MS' then totalcandidatos else 0 end) as totalcandidatosMS,
    sum(case when SG_UF = 'MT' then totalcandidatos else 0 end) as totalcandidatosMT,
    sum(case when SG_UF = 'PA' then totalcandidatos else 0 end) as totalcandidatosPA,
    sum(case when SG_UF = 'PB' then totalcandidatos else 0 end) as totalcandidatosPB,
    sum(case when SG_UF = 'PE' then totalcandidatos else 0 end) as totalcandidatosPE,
    sum(case when SG_UF = 'PI' then totalcandidatos else 0 end) as totalcandidatosPI,
    sum(case when SG_UF = 'PR' then totalcandidatos else 0 end) as totalcandidatosPR,
    sum(case when SG_UF = 'RJ' then totalcandidatos else 0 end) as totalcandidatosRJ,
    sum(case when SG_UF = 'RN' then totalcandidatos else 0 end) as totalcandidatosRN,
    sum(case when SG_UF = 'RO' then totalcandidatos else 0 end) as totalcandidatosRO,
    sum(case when SG_UF = 'RR' then totalcandidatos else 0 end) as totalcandidatosRR,
    sum(case when SG_UF = 'RS' then totalcandidatos else 0 end) as totalcandidatosRS,
    sum(case when SG_UF = 'SC' then totalcandidatos else 0 end) as totalcandidatosSC,
    sum(case when SG_UF = 'SE' then totalcandidatos else 0 end) as totalcandidatosSE,
    sum(case when SG_UF = 'SP' then totalcandidatos else 0 end) as totalcandidatosSP,
    sum(case when SG_UF = 'TO' then totalcandidatos else 0 end) as totalcandidatosTO

from tb_taxas
group by 1),


tb_taxas_br as (select SG_PARTIDO,
        'BR' as SG_UF,
        sum(fem) as totalfem,

        count(*) totalcandidatos,
        sum(fem) / (1.0 * count(*)) as txfem,

        sum(cor_PRETA) as totalPretos,
        sum(cor_PRETA) / (1.0 * count(*)) as txPretos
    
from tb_cor_genero
group by 1) 

select * from tb_infos

