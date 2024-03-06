# Requisitos

- Ruby 3.1.4
- sqlite3
- Redis 6.2+ (por conta do Sidekiq. Pode ser instalado via snap no Linux Ubuntu: `sudo snap install redis`)

# Como iniciar o back-end

Após clonar o projeto basta executar o comando abaixo para instalar as dependências e iniciar o banco de dados:

```
bundle install
rails db:migrate
rails db:seed
```

A API precisa rodar em localhost (127.0.0.1), mais especificamente na porta 3000, para isso execute o seguinte comando no diretório da API:

```
rails server -p 3000
```

Após executar este comando basta colar no navegador: `http://127.0.0.1:3000`

Também é preciso iniciar o Sidekiq para poder rodar os processos em segundo plano, para isso, também no repositório da API, execute:

```
bundle exec sidekiq
```

# Sobre a API

## O que não mudou

Nenhuma das classes/tabelas originais da aplicação template foram modificadas, uma vez que, nenhum dos desafios necessitou isso, sendo assim as mesmas ficaram desta forma na API:

![class_diagram](https://github.com/samuelfilipefaria/desafio-full-stack-oxeanbits-back-end/assets/102987906/de68b21d-8153-4193-bf53-5cb0e1cbcf41)

*Diagrama de classes*

Como é possível perceber, os relacionamentos originais foram mantidos, embora tenha pensado em modificar o nome da tabela UserMovie para Rating ou MovieRating (já que graças ao `score` ele é uma entitade à parte, mais do que apenas uma ferramenta para unir User e Movie em sua relação muitos para muitos), preferi manter pois não fazia parte do desafio.

## O que mudou

A aplicação template foi transformada em uma aplicação API-only (https://guides.rubyonrails.org/api_app.html), ou seja, sem front-end, apenas back, foi feito desta forma pois fazia mais sentido tendo em vista a natureza do projeto final (front-end em React), desta forma é mais fácil explorar o melhor das duas tecnologias e manter os repositórios separados.

Essa mudança impactou na autenticação dos usuários, que antes era feita com `sessions` mas na API atual está sendo feita com JSON Web Token (JWT) (https://jwt.io) uma estratégia bastante utilizada por API's para realizar a autenticação de forma segura e rápida.

A configuração de CORS da aplicação também precisou ser modificada pois agora precisava receber requisições externas, para isso usei a gem `rack-cors`

# Os desafios

Para avaliar os filmes em massa apenas pedi para o Job do Sidekiq fazer isto em segundo plano, atualizando as avaliações já existentes e criando as novas.

Para importar os filmes em massa utilizei juntamente com o Sidekiq uma gem chamada `activerecord-import` para fazer apenas uma requisição ao banco enviando todos os filmes de uma só vez.

# Detalhes adicionais

- Para os commits/branches utilizei a especificação "Conventional Commits" (https://www.conventionalcommits.org/en/v1.0.0-beta.4/#summary) com a ferramenta better-commits
