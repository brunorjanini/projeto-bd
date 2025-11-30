# API de Relatórios e Operações de Transplantes

Esta API fornece consultas de relatórios e operações de inserção/atualização para um sistema de transplantes hospitalares.
Ela foi construída usando Spring WebFlux + R2DBC + PostgreSQL.

Todas as rotas assumem o prefixo:

```
/api
```

Se você não estiver usando `spring.webflux.base-path=/api`, remova esse prefixo das URLs.

---

## 1. Consultas (READ)

---

### 1.1 Listar hospitais e quantidade de órgãos disponíveis

**GET** `/api/relatorios/hospitais`

Lista hospitais de uma Central Estadual e conta quantos órgãos estão disponíveis em cada hospital.

**Parâmetros (query):**

* `central` (string) – sigla do estado (ex: SP, RJ)
* `status` (string) – status do órgão (ex: Disponível)

**Exemplo:**

```bash
curl "http://localhost:8080/api/relatorios/hospitais?central=SP&status=Disponível"
```

**Resposta:**

```json
[
  {
    "nomeHospital": "Hospital das Clínicas da FMUSP",
    "cidade": "São Paulo",
    "totalOrgaosDisponiveis": 2
  }
]
```

---

### 1.2 Profissionais em hospitais sem pacientes

**GET** `/api/relatorios/profissionais-sem-pacientes`

Lista profissionais que trabalham em hospitais que não possuem nenhum paciente registrado.

**Exemplo:**

```bash
curl "http://localhost:8080/api/relatorios/profissionais-sem-pacientes"
```

---

### 1.3 Receptores com mais de N transplantes e em fila

**GET** `/api/relatorios/receptores`

Lista receptores que possuem mais de um determinado número de transplantes e que estão ativos em alguma fila.

**Parâmetro (query):**

* `minTransplantes` (int) – valor mínimo de transplantes (default = 1)

**Exemplo:**

```bash
curl "http://localhost:8080/api/relatorios/receptores?minTransplantes=1"
```

---

### 1.4 Transportes entre hospitais

**GET** `/api/relatorios/transportes`

Lista transportes de órgãos entre hospitais informando tempo de trânsito, centro logístico e GPS utilizado.

**Parâmetros (query):**

* `origemLike` (string) – filtro SQL LIKE no hospital de origem
* `destinoLike` (string) – filtro SQL LIKE no hospital de destino
* `apenasConcluidos` (boolean) – true / false

**Exemplo:**

```bash
curl "http://localhost:8080/api/relatorios/transportes?origemLike=%Hosp%&destinoLike=%Hosp%&apenasConcluidos=true"
```

---

### 1.5 Profissionais que avaliaram todos os tipos de órgãos

**GET** `/api/relatorios/profissionais-avaliaram-todos`

Implementação de divisão relacional: retorna médicos que avaliaram TODOS os tipos de órgão/tecido cadastrados.

**Parâmetro (query):**

* `profissao` (string) – profissão do profissional (default = MÉDICO)

**Exemplo:**

```bash
curl "http://localhost:8080/api/relatorios/profissionais-avaliaram-todos?profissao=MÉDICO"
```

---

## 2. Operações de Escrita (WRITE)

---

### 2.1 Criar hospital

**POST** `/api/relatorios/hospitais`

Cria um novo hospital e retorna a lista atualizada da CONSULTA 1.

**Parâmetros (query):**

* `central` – estado usado para filtrar o retorno
* `status` – status do órgão usado para filtrar o retorno

**Body JSON:**

```json
{
  "nome": "Hospital Vital SP",
  "cnpj": "11.222.333/0001-44",
  "telefone": "(11) 4000-1234",
  "email": "contato@hospital.com",
  "rua": "Rua X",
  "numero": "100",
  "bairro": "Centro",
  "cidade": "São Paulo",
  "centralEstadual": "SP"
}
```

**Exemplo:**

```bash
curl -X POST "http://localhost:8080/api/relatorios/hospitais?central=SP&status=Disponível" \
  -H "Content-Type: application/json" \
  -d '{...}'
```

---

### 2.2 Inserir órgão ou tecido

**POST** `/api/orgaos`

Insere um órgão ou tecido associado a um doador.

**Body JSON:**

```json
{
  "idDoador": 7,
  "tipoOrgao": "Coração",
  "status": "Disponível",
  "dataCaptacao": "2025-11-29T10:00:00"
}
```

---

### 2.3 Registrar avaliação de órgão

**POST** `/api/avaliacoes/orgaos`

Registra avaliação médica e retorna a CONSULTA 5.

**Query param:**

* `profissao` (default = MÉDICO)

**Body JSON:**

```json
{
  "idMedico": 3,
  "idOrgao": 1,
  "dataHora": "2025-11-29T15:00:00"
}
```

---

### 2.4 Inserir histórico de fila

**POST** `/api/filas/historico`

Registra posição do paciente em uma fila e retorna a CONSULTA 3 atualizada.

**Query param:**

* `minTransplantes`

**Body JSON:**

```json
{
  "nomeFila": "Pulmão",
  "idPessoa": 2,
  "posicao": 2
}
```

---

### 2.5 Atualizar número de transplantes

**PUT** `/api/receptores/{idPessoa}/num-transplantes`

Atualiza o número de transplantes de um receptor e retorna a CONSULTA 3.

**Body JSON:**

```json
{
  "numTransplantes": 2
}
```

---

## 3. Estrutura da aplicação

A aplicação é separada por responsabilidade:

### Leitura (READ)

* `Queries` (repository)
* `GetQueriesService`
* `RelatorioTransplantesReadHandler`

### Escrita (WRITE)

* `CommandsRepository`
* `CommandsService`
* `RelatorioTransplantesWriteHandler`

### Roteamento

* `RouterConfiguration`

---

## 4. Observações finais

* Todas as queries usam parâmetros nomeados (`:param`) para evitar SQL Injection.
* O sistema é totalmente reativo usando Spring WebFlux + R2DBC.
* As rotas de escrita já devolvem relatórios atualizados, facilitando testes e debugging.
* Consultas vazias (`[]`) podem ser resultado esperado dependendo do estado dos dados.

