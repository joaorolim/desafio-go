# Etapa 1: Usando a imagem oficial do Go para compilar o código
FROM golang:alpine AS builder

# Definindo o diretório de trabalho dentro do container
WORKDIR /app

# Copiando o go.mod e go.sum, se existentes
COPY go.mod ./

# Baixando as dependências (mesmo que não tenhamos nenhuma, garante que tudo esteja correto)
RUN go mod download

# Copiando o código Go para dentro do container
COPY . .

# Compilando o programa Go com otimização para reduzir o tamanho
RUN go build -ldflags="-s -w" -o fullcycle

# Etapa 2: Usando a imagem mínima
FROM scratch

# Copiando o binário gerado para o novo container
COPY --from=builder /app/fullcycle /fullcycle

# Definindo o entrypoint para o binário
ENTRYPOINT ["/fullcycle"]
