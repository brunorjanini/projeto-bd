# Sistema de Gerenciamento de Transplantes

Sistema completo para gerenciamento de transplantes de órgãos, incluindo backend (Spring Boot), frontend (React) e banco de dados PostgreSQL.

---

## Estrutura do Projeto

```
projeto-bd/
├── app/              # Backend (Spring Boot + WebFlux)
├── interface/        # Frontend (React + TypeScript + Vite)
├── ddl/              # Schemas das tabelas do banco
├── nginx/            # Configuração do Nginx
├── docker-compose.yml
├── .env
├── final.sql         # Schema completo do banco
└── all_insertions.sql # Dados iniciais
```

---

## Requisitos

- Docker e Docker Compose
- Node.js 18+ (apenas para desenvolvimento local do frontend)
- Java 17+ (apenas para desenvolvimento local do backend)

---

## Configuração

### 1. Arquivo .env

O projeto já vem com um arquivo `.env` configurado. As principais variáveis são:

```properties
# Interface
VITE_TRANSPLANT_API_URL=http://localhost:8080/api

# Banco de Dados
POSTGRES_DB=bdtrab
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# API Spring Boot
SPRING_R2DBC_URL=r2dbc:postgresql://postgres-db:5432/bdtrab
SPRING_R2DBC_USERNAME=postgres
SPRING_R2DBC_PASSWORD=postgres
```

**Importante:** Se você alterar as credenciais do banco, atualize tanto as variáveis `POSTGRES_*` quanto `SPRING_R2DBC_*`.

---

## Como Executar

### Opção 1: Usando Docker Compose (Recomendado)

Inicia todos os serviços (Nginx, API, Frontend e PostgreSQL):

```bash
docker-compose up --build
```

Ou em modo detached (background):

```bash
docker-compose up -d --build
```

### Opção 2: Desenvolvimento Local

#### Backend (API)
```bash
cd app
./mvnw spring-boot:run
```

#### Frontend
```bash
cd interface
npm install
npm run dev
```

#### Banco de Dados
```bash
docker-compose up postgres
```

---

## Portas e Acesso

| Serviço    | Porta | URL                                    | Descrição                          |
|------------|-------|----------------------------------------|------------------------------------|
| **Nginx**  | 8080  | http://localhost:8080                  | Proxy reverso (Frontend + API)     |
| **Frontend** | -   | http://localhost:8080                  | Interface React (via Nginx)        |
| **API**    | -     | http://localhost:8080/api              | Backend Spring Boot (via Nginx)    |
| **PostgreSQL** | 5433 | localhost:5433                      | Banco de dados (mapeado para 5433) |

**Observações:**
- O Nginx roteia automaticamente:
  - `/` → Frontend (React)
  - `/api/*` → Backend (Spring Boot)
- O PostgreSQL está exposto na porta **5433** no host (para evitar conflitos com instâncias locais na porta 5432)
- Internamente na rede Docker, o PostgreSQL usa a porta 5432

---

## Comandos Úteis

### Parar os containers
```bash
docker-compose down
```

### Parar e remover volumes (limpa o banco de dados)
```bash
docker-compose down -v
```

### Ver logs de um serviço específico
```bash
docker-compose logs -f api      # Logs da API
docker-compose logs -f postgres # Logs do banco
docker-compose logs -f nginx    # Logs do Nginx
```

### Reconstruir imagens
```bash
docker-compose build --no-cache
```

### Acessar o container do PostgreSQL
```bash
docker exec -it postgres-db psql -U postgres -d bdtrab
```

---

## Banco de Dados

### Inicialização Automática

Ao iniciar o PostgreSQL pela primeira vez, os seguintes scripts são executados automaticamente:

1. `final.sql` - Cria todas as tabelas e estruturas
2. `all_insertions.sql` - Insere dados iniciais

### Conectar ao Banco

**Via container:**
```bash
docker exec -it postgres-db psql -U postgres -d bdtrab
```

**Via cliente local (porta 5433):**
```bash
psql -h localhost -p 5433 -U postgres -d bdtrab
```

Senha padrão: `postgres`

---

## Estrutura dos Serviços

### Backend (Spring Boot API)
- **Tecnologia:** Spring Boot 3.x + WebFlux + R2DBC
- **Linguagem:** Java 17+
- **Características:** 
  - API reativa (não bloqueante)
  - 4 endpoints principais (ver `app/README.md`)
  - Transações atômicas para operações críticas
  - Documentação JavaDoc completa

### Frontend (React)
- **Tecnologia:** React 19 + TypeScript + Vite
- **Estilo:** TailwindCSS 4
- **Componentes:**
  - Listar Hospitais
  - Inserir Hospital
  - Listar Transportes
  - Realizar Transplante

### Banco de Dados (PostgreSQL)
- **Versão:** PostgreSQL 16
- **Persistência:** Volume Docker (`postgres-data`)
- **Healthcheck:** Verifica disponibilidade a cada 30s


