# DVD Rental Database - Docker Setup

Este projeto configura um ambiente PostgreSQL com Docker e Docker Compose para a base de dados DVD Rental, incluindo PgAdmin para administração.

## Pré-requisitos

- Docker
- Docker Compose

## Estrutura do Projeto

```
.
├── docker-compose.yml          # Configuração dos serviços
├── Dockerfile                  # Imagem personalizada do PostgreSQL
├── dvdrental.tar              # Arquivo de dump da base de dados
├── init-db/
│   └── 01-import-dvdrental.sh # Script de inicialização
└── README.md                  # Este arquivo
```

## Como Usar

### 1. Iniciar os Serviços

```bash
# Construir e iniciar os containers
docker-compose up -d

# Verificar o status dos containers
docker-compose ps

# Visualizar logs
docker-compose logs -f postgres
```

### 2. Acesso aos Serviços

#### PostgreSQL
- **Host**: localhost
- **Porta**: 5432
- **Base de Dados**: dvdrental
- **Utilizador**: postgres
- **Palavra-passe**: postgres

#### PgAdmin (Interface Web)
- **URL**: http://localhost:8080
- **Email**: admin@admin.com
- **Palavra-passe**: admin

### 3. Conectar ao PostgreSQL

#### Via linha de comando
```bash
# Conectar diretamente ao container
docker exec -it dvdrental_postgres psql -U postgres -d dvdrental

# Ou usando psql local (se instalado)
psql -h localhost -p 5432 -U postgres -d dvdrental
```

#### Via PgAdmin
1. Acesse http://localhost:8080
2. Faça login com admin@admin.com / admin
3. Adicione um novo servidor:
   - **Nome**: DVD Rental
   - **Host**: postgres (nome do serviço no Docker Compose)
   - **Porta**: 5432
   - **Base de Dados**: dvdrental
   - **Utilizador**: postgres
   - **Palavra-passe**: postgres

**Importante**: Use "postgres" como host, não o IP do container!

## Comandos Úteis

```bash
# Parar os serviços
docker-compose down

# Parar e remover volumes (dados serão perdidos)
docker-compose down -v

# Reconstruir as imagens
docker-compose build --no-cache

# Verificar logs de um serviço específico
docker-compose logs postgres
docker-compose logs pgadmin

# Executar comandos no container PostgreSQL
docker exec -it dvdrental_postgres bash
```

## Verificação da Importação

Para verificar se a base de dados foi importada corretamente:

```sql
-- Listar todas as tabelas
\dt

-- Contar registos em algumas tabelas principais
SELECT 'actor' as table_name, count(*) as records FROM actor
UNION ALL
SELECT 'film', count(*) FROM film
UNION ALL
SELECT 'customer', count(*) FROM customer
UNION ALL
SELECT 'rental', count(*) FROM rental;
```

## Estrutura da Base de Dados

A base de dados DVD Rental contém as seguintes tabelas principais:
- `actor` - Atores
- `film` - Filmes
- `customer` - Clientes
- `rental` - Alugueres
- `payment` - Pagamentos
- `inventory` - Inventário
- `store` - Lojas
- `staff` - Funcionários
- `category` - Categorias
- `language` - Idiomas

## Troubleshooting

### Problema: PgAdmin não consegue conectar ao PostgreSQL

**Erro**: "connection failed: connection to server at "172.19.0.2", port 5432 failed"

**Solução**:
1. Use "postgres" como hostname, não o IP do container
2. Certifique-se de que ambos os containers estão na mesma rede
3. Verifique se o PostgreSQL está rodando:
   ```bash
   docker-compose ps
   docker-compose logs postgres
   ```

**Configuração correta no PgAdmin**:
- Host: `postgres` (nome do serviço)
- Porta: `5432`
- Utilizador: `postgres`
- Palavra-passe: `postgres`
- Base de Dados: `dvdrental`

### Problema: Container não inicia
```bash
# Verificar logs
docker-compose logs postgres

# Verificar se a porta 5432 está disponível
sudo netstat -tlnp | grep 5432
```

### Problema: Base de dados não foi importada
```bash
# Verificar se o arquivo dvdrental.tar existe
ls -la dvdrental.tar

# Verificar logs de inicialização
docker-compose logs postgres | grep -i dvdrental
```

### Problema: Permissões de arquivo
```bash
# Dar permissões corretas ao script
chmod +x init-db/01-import-dvdrental.sh
```

## Limpeza

Para remover completamente o ambiente:

```bash
# Parar e remover containers, redes e volumes
docker-compose down -v

# Remover imagens (opcional)
docker rmi dvdrental_postgres pgadmin4
```
