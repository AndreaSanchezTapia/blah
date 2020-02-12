# Script para manipulação de dados em bases relacionais ---#
# parte do curso Projetos de análise de dados em R
# dados originais extraídos de Jeliazkov et al 2020 Sci Data
# (https://doi.org/10.1038/s41597-019-0344-7)
# primeira versão em 2020-02-12
#-----------------------------------------------------------#

library("tidyr")
?list.files

files.path <- list.files(path = "data/cestes",
                         pattern = ".csv",
                         full.names = TRUE)

files.path


comm <- read.csv(files.path[1])
coord <- read.csv(files.path[2])
envir <- read.csv(files.path[3])
splist <- read.csv(files.path[4])
traits <- read.csv(files.path[5])

## Entendendo o objeto `comm`

head(comm)
dim(comm)
summary(comm)

## Entendendo o objeto `coord`

head(coord)
dim(coord)
summary(coord)

## Entendendo o objeto `envir`

head(envir)
dim(envir)
summary(envir)

## Entendendo o objeto `splist`

head(splist)
dim(splist)
summary(splist)

## Entendendo o objeto `traits`

head(traits)
dim(traits)
summary(traits)

# Sumário dos dados

nrow(splist)

nrow(comm)
nrow(envir)


# todas as variáveis exceto a primeira coluna com o id
names(envir)[-1]
# contando quantas variáveis
length(names(envir)[-1])

comm.pa <- comm[, -1] > 0
# vamos nomear as linhas das planilhas com o id dos sites
row.names(comm.pa) <- envir$Sites

sum(comm.pa[1, ])

rich <- apply(X = comm.pa, MARGIN = 1, FUN = sum)
summary(rich)

envir$Sites
summary(envir$Sites)


class(envir$Sites)

as.factor(envir$Sites)
envir$Sites <- as.factor(envir$Sites)

coord$Sites <- as.factor(coord$Sites)

## Juntando `coord` e `envir`

envir.coord <- merge(x = envir,
                     y = coord,
                     by = "Sites")

dim(envir)
dim(coord)
dim(envir.coord)
head(envir.coord)


# vetor contendo todos os Sites
Sites <- envir$Sites
length(Sites)

# vetor número de espécies
n.sp <- nrow(splist)
n.sp

# criando tabela com cada especie em cada area especies em linhas
comm.df <- tidyr::gather(comm[, -1])

dim(comm.df)
head(comm.df)

# nomes atuais
colnames(comm.df)
# modificando os nomes das colunas
colnames(comm.df) <-  c("TaxCode", "Abundance")
# checando os novos nomes
colnames(comm.df)

# primeiro criamos a sequência
seq.site <- rep(Sites, each = n.sp)
# checando a dimensão
length(seq.site)
# adicionando ao objeto comm.df
comm.df$Sites <- seq.site
# checando como ficou
head(comm.df)

comm.sp <- merge(comm.df, splist, by = "TaxCode")
head(comm.sp)

names(traits)
# renomeando o primeiro elemento
colnames(traits)[1] <- "TaxCode"


comm.traits <- merge(comm.sp, traits, by = "TaxCode")
head(comm.traits)

comm.total <- merge(comm.traits, envir.coord, by = "Sites")
head(comm.total)

write.csv(x = comm.total,
          file = "data/01_data_format_combined.csv",
          row.names = FALSE)
