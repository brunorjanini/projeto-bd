# API de Relatórios e Operações de Transplantes

Sistema de Gestão de Transplantes - API RESTful construída com Spring WebFlux + R2DBC + PostgreSQL para operações reativas e não bloqueantes.

## 🚀 Tecnologias

- **Spring Boot 3.x** com WebFlux (Programação Reativa)
- **R2DBC** (Reactive Relational Database Connectivity)
- **PostgreSQL** (Banco de Dados)
- **Java 17+** com Records

## 📋 Endpoints Disponíveis

Todas as rotas utilizam o prefixo `/api`.

---

## 1. 📖 Consultas (READ)

### 1.1 Listar Hospitais

**GET** `/api/relatorios/hospitais`

Lista hospitais com a quantidade de órgãos disponíveis. Permite filtrar por central estadual (UF) e status dos órgãos.

**Parâmetros de Query (opcionais):**

- `central` (string) – Sigla do estado (ex: `SP`, `RJ`, `MG`)
- `status` (string) – Status do órgão (ex: `Disponível`, `Em Transporte`, `Transplantado`)

**Exemplo de Requisição:**

```bash
curl "http://localhost:8080/api/relatorios/hospitais?central=SP&status=Disponível"
```

**Resposta (200 OK):**

```json
[
  {
    "nomeHospital": "Hospital das Clínicas da FMUSP",
    "cidade": "São Paulo",
    "totalOrgaosDisponiveis": 2
  },
  {
    "nomeHospital": "Hospital Municipal Souza Aguiar",
    "cidade": "Rio de Janeiro",
    "totalOrgaosDisponiveis": 0
  }
]
```

---

### 1.2 Listar Transportes

**GET** `/api/relatorios/transportes`

Lista transportes de órgãos entre hospitais com informações sobre tempo de trânsito, centro de transporte e GPS.

**Parâmetros de Query (opcionais):**

- `origemLike` (string) – Filtro por nome do hospital de origem (busca parcial)
- `destinoLike` (string) – Filtro por nome do hospital de destino (busca parcial)
- `apenasConcluidos` (boolean) – Se `true`, retorna apenas transportes com data de chegada

**Exemplo de Requisição:**

```bash
curl "http://localhost:8080/api/relatorios/transportes?origemLike=Clínicas&apenasConcluidos=true"
```

**Resposta (200 OK):**

```json
[
  {
    "idOrgao": 1,
    "tipoOrgao": "Rim",
    "hospitalOrigem": "Hospital Municipal Souza Aguiar",
    "hospitalDestino": "Hospital das Clínicas da FMUSP",
    "centroTransporte": "Terminal Logístico São Paulo",
    "serialGps": "GPS-X100-PRO",
    "tempoTransitoHoras": 1.5
  },
  {
    "idOrgao": 2,
    "tipoOrgao": "Coração",
    "hospitalOrigem": "Hospital das Clínicas da FMUSP",
    "hospitalDestino": "Hospital Municipal Souza Aguiar",
    "centroTransporte": "Terminal Logístico São Paulo",
    "serialGps": "GPS-Z500-LITE",
    "tempoTransitoHoras": null
  }
]
```

> **Nota:** `tempoTransitoHoras` será `null` para transportes ainda em andamento.

---

## 2. ✏️ Operações de Escrita (WRITE)

### 2.1 Criar Hospital

**POST** `/api/relatorios/hospitais`

Cadastra um novo hospital no sistema e retorna a lista atualizada de hospitais filtrada pelos parâmetros de query.

**Parâmetros de Query:**

- `central` (string) – Estado para filtrar o resultado do retorno
- `status` (string) – Status dos órgãos para filtrar o resultado do retorno

**Body (JSON):**

```json
{
  "nome": "Hospital Vital SP",
  "cnpj": "11.222.333/0001-44",
  "telefone": "(11) 4000-1234",
  "email": "contato@hospitalvital.com.br",
  "rua": "Av. Paulista",
  "numero": "1000",
  "bairro": "Bela Vista",
  "cidade": "São Paulo",
  "centralEstadual": "SP"
}
```

**Exemplo de Requisição:**

```bash
curl -X POST "http://localhost:8080/api/relatorios/hospitais?central=SP&status=Disponível" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Hospital Vital SP",
    "cnpj": "11.222.333/0001-44",
    "telefone": "(11) 4000-1234",
    "email": "contato@hospitalvital.com.br",
    "rua": "Av. Paulista",
    "numero": "1000",
    "bairro": "Bela Vista",
    "cidade": "São Paulo",
    "centralEstadual": "SP"
  }'
```

**Resposta (201 CREATED):**

Retorna a lista atualizada de hospitais (mesmo formato do GET).

---

### 2.2 Realizar Transplante

**POST** `/api/transplantes`

Realiza um transplante completo de forma transacional. Esta operação executa automaticamente:

1. Insere o registro do transplante
2. Atualiza o status do órgão para `Transplantado` e validade para `Aprovado`
3. Incrementa o contador de transplantes do receptor
4. Remove o receptor da fila de espera do tipo de órgão correspondente

**Body (JSON):**

```json
{
  "idOrgao": 1,
  "idReceptor": 2,
  "statusTransplante": "Realizado"
}
```

**Exemplo de Requisição:**

```bash
curl -X POST "http://localhost:8080/api/transplantes" \
  -H "Content-Type: application/json" \
  -d '{
    "idOrgao": 1,
    "idReceptor": 2,
    "statusTransplante": "Realizado"
  }'
```

**Resposta:**

- **201 CREATED** – Transplante realizado com sucesso
- **500 INTERNAL SERVER ERROR** – Erro durante o processo (com mensagem detalhada)

---

## 3. Arquitetura da Aplicação

A aplicação segue uma arquitetura em camadas com separação de responsabilidades:

### Estrutura de Pacotes

```
com.usp.app
├── config/              # Configurações (CORS, Transações)
│   └── WebServerConfigutarions.java
├── dto/                 # Data Transfer Objects
│   ├── Consulta1HospitalDTO.java
│   ├── Consulta4TransporteDTO.java
│   ├── NovoHospitalDTO.java
│   └── RealizarTransplanteDTO.java
├── handler/             # Handlers HTTP (WebFlux)
│   ├── RelatorioTransplantesHandler.java       (READ)
│   └── RelatorioTransplantesWriteHandler.java  (WRITE)
├── repository/          # Acesso a Dados (R2DBC)
│   ├── Queries.java                            (READ)
│   └── CommandsRepository.java                 (WRITE)
├── service/             # Lógica de Negócio
│   ├── GetQueriesService.java                  (READ)
│   └── CommandsService.java                    (WRITE)
├── RouterConfiguration.java  # Roteamento funcional
└── AppApplication.java       # Classe principal
```

### Fluxo de Requisição

```
Cliente HTTP
    ↓
RouterConfiguration (Define rotas)
    ↓
Handler (Processa requisição)
    ↓
Service (Lógica de negócio)
    ↓
Repository (Acesso ao banco)
    ↓
PostgreSQL (Banco de dados)
```

### Separação de Responsabilidades

#### **Leitura (READ)**
- `Queries.java` – Repositório com queries SELECT
- `GetQueriesService.java` – Serviço de consultas
- `RelatorioTransplantesHandler.java` – Handler GET endpoints

#### **Escrita (WRITE)**
- `CommandsRepository.java` – Repositório com INSERT/UPDATE/DELETE
- `CommandsService.java` – Serviço de comandos
- `RelatorioTransplantesWriteHandler.java` – Handler POST/PUT endpoints

---

## 4. Segurança e Boas Práticas

### Prevenção de SQL Injection
- ✅ Todas as queries utilizam **parâmetros nomeados** (`:param`)
- ✅ Nenhuma concatenação de strings em SQL

### Transações
- ✅ Operação de transplante é **totalmente transacional**
- ✅ Utiliza `TransactionalOperator` para garantir atomicidade
- ✅ Em caso de erro, todas as operações são revertidas (rollback)

### CORS
- ✅ Configurado para aceitar requisições de qualquer origem
- ✅ Permite todos os métodos HTTP
- ✅ Configurável em `WebServerConfigutarions.java`

---

## 5. Como Executar

### Pré-requisitos
- Java 17 ou superior
- PostgreSQL rodando
- Banco de dados configurado com as tabelas necessárias

### Executar a aplicação

```bash
cd app
./mvnw spring-boot:run
```

A API estará disponível em: `http://localhost:8080`

### Configuração do Banco

Configure as propriedades de conexão em `src/main/resources/application.yaml`:

```yaml
spring:
  r2dbc:
    url: r2dbc:postgresql://localhost:5432/projeto_bd
    username: seu_usuario
    password: sua_senha
```

---

## 6. Observações Importantes

### Comportamento das Consultas
- ✅ Filtros são **opcionais** – omitir retorna todos os registros
- ✅ Consultas vazias `[]` são **resultado esperado** quando não há dados
- ✅ Busca por nome usa **ILIKE** (case-insensitive)

### Formato de Dados
- ✅ Datas devem estar no formato ISO 8601: `YYYY-MM-DDTHH:mm:ss`
- ✅ CNPJ deve estar no formato: `XX.XXX.XXX/XXXX-XX`
- ✅ Telefone aceita formato livre: `(XX) XXXXX-XXXX`

### Performance
- ✅ Sistema totalmente **reativo** com Spring WebFlux
- ✅ Conexões **não bloqueantes** com R2DBC
- ✅ Suporta alta concorrência sem degradação de performance

---

## 7. Testando a API

### Usando cURL

**Listar todos os hospitais:**
```bash
curl http://localhost:8080/api/relatorios/hospitais
```

**Criar um hospital:**
```bash
curl -X POST http://localhost:8080/api/relatorios/hospitais?central=SP&status=Disponível \
  -H "Content-Type: application/json" \
  -d '{"nome":"Hospital Teste","cnpj":"12.345.678/0001-90","telefone":"(11)1234-5678","email":"teste@hospital.com","rua":"Rua A","numero":"100","bairro":"Centro","cidade":"São Paulo","centralEstadual":"SP"}'
```

**Listar transportes concluídos:**
```bash
curl "http://localhost:8080/api/relatorios/transportes?apenasConcluidos=true"
```

**Realizar um transplante:**
```bash
curl -X POST http://localhost:8080/api/transplantes \
  -H "Content-Type: application/json" \
  -d '{"idOrgao":1,"idReceptor":2,"statusTransplante":"Realizado"}'
```

---

## 8. Documentação JavaDoc

Todo o código está documentado com JavaDoc. Para gerar a documentação HTML:

```bash
./mvnw javadoc:javadoc
```

A documentação será gerada em: `target/site/apidocs/index.html`

