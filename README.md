# Desafio 01 - Cotações

## Descrição

Repositório com o código proposto como solução [deste desafio](https://github.com/zanfranceschi/desafio-01-cotacoes).
A ideia é construir uma API que consulta três serviços externos em busca de uma cotação.
Após obtidas as respostas, a API retorna a menor das três.

## Comentários sobre a implementação

O servidor foi feito usando a linguagem Dart com o pacote [Shelf](https://pub.dev/packages/shelf), recomendado oficialmente pelo Google e utiliza o pacote [Dio](https://pub.dev/packages/shelf) para efetuar as chamadas às APIs dos serviços externos.

Os serviços A e B foram os mais simples de implementar, pois o acesso à estes consiste em requisições HTTP.

Já o serviço C, este foi mais desafiador, pois consiste num retorno assíncrono. A estratégia utilizada para este serviço se baseia no uso de Streams, recurso nativo do Dart para programação assíncrona.
No controller do endpoint das cotação foi criado um StreamController que "escutará" a chegada de novas cotações disparadas pelo serviço C.
Estas novas cotações chegarão por um webhook configurado na rota `/cotacoes/callback`. Cada chamada à esta roda adicionará a cotação do serviço C à Stream. Que, por sua vez, será recebida no endpoint principal, que dará segmento às requisições aos outros serviços.

Como o foco foi resolver o caso do serviço C, pontos importantes como testes, boas práticas e tratamento detalhado de erros não foram devidamente incluídos.

## Executando a aplicação

### Pré-requisitos

Para executar este projeto localmente é necessário ter o Docker com o docker-compose instalado, pois a aplicação dos serviços externos será executada num container local.

Para iniciar os serviços, basta executar na raiz do projeto o seguinte comando:

```bash
docker-compose up -d
```

Para encerrar o container:

```bash
docker-compose down
```

### Executando o projeto usando o Dart SDK

Este projeto pode ser executado com o [Dart SDK](https://dart.dev/get-dart)
da seguinte forma:

```bash
$ dart run bin/server.dart
Server listening on port 3000
```

E a partir de um segundo terminal ou aplicação para testes de APIs (Como Insomnia e Postman):

```bash
$ curl http://0.0.0.0:3000/quotation/USD
{"data":{"quotation":{"currency":"USD","price":3.065}}}
```

### Executando o projeto usando Docker

Caso não deseje instalar o Dart, é possível criar e executar uma imagem Docker com o comando:

```bash
$ docker build . -t myserver
$ docker run -it -p 3000:3000 myserver
Server listening on port 3000
```

Alternativamente, caso opte por esta abordagem, o código para inicializar o servidor já está incluido no `docker-compose.yaml. Basta descomentar as linhas comentadas e executar o comando:

```bash
$ docker-compose up -d
```

E a partir de um segundo terminal ou aplicação para testes de APIs (Como Insomnia e Postman):

```bash
$ curl http://0.0.0.0:3000/quotation/USD
{"data":{"quotation":{"currency":"USD","price":3.065}}}
```
