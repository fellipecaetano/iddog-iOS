# iddog-iOS

Este repositório abriga uma implementação iOS do [iddog](https://github.com/idwall/desafios-iddog), um app que exibe uma lista de cachorros filtrados por quatro raças para usuários autenticados.

## Índice

- [iddog-iOS](#iddog-iOS)
  - [Índice](#%C3%8Dndice)
  - [Estrutura do projeto](#Estrutura-do-projeto)
  - [Arquitetura](#Arquitetura)
  - [Dependencências de terceiros](#Dependenc%C3%AAncias-de-terceiros)
  - [Trade-offs](#Trade-offs)
    - [UI](#UI)
    - [Testes](#Testes)
  - [Stack](#Stack)
  - [Referências](#Refer%C3%AAncias)

## Estrutura do projeto

A estrutura do projeto se assemelha a uma divisão por módulos, com algumas ressalvas. Estruturas de projetos iOS modulares são mais comumente usadas em apps de grande porte, pois normalmente cada _feature_ pode ser seu próprio módulo, além dos componentes usuais como networking, autenticação, _core_ e eventuais bibliotecas desenvolvidas _in-house_.

Esta versão do iddog é um app bem pequeno, que por si só não justificaria uma estrutura modular completa. Apesar disso, esta versão quase não faz uso de dependências externas, optando pela implementação _in-house_ de eventuais bibliotecas necessárias. Por conta disso, tem-se os seguintes módulos:

- **Authentication**: persistência do token no keychain e modelo de credenciais
- **Networking**: camada de "serviço", com definição do _client_ da API de cachorros e dos modelos do _schema_ JSON dos retornos dos _endpoints_
- **Redux**: componentes necessários para a implementação de um fluxo de dados unidirecional, reativo e com gerenciamento de efeitos colaterais
- **Streams**: estruturas e operadores inspirados em RxSwift que implementam algumas noções de programação funcional reativa
- **Application**: código da aplicação de fato, com view controllers, views, coordinators, view models e outros componentes que fazem parte da camada de apresentação
- **Pods**: dependências de terceiros gerenciadas por CocoaPods

## Arquitetura

O app utiliza uma arquitura unidirecional de dados. Todos os dados consumidos pelas _features_ ficam em uma única árvore em memória, que atua como a fonte de verdade do app. Estes dados ficam armazenados e protegidos pela _store_, uma estrutura de dados que cumpre três requisitos:

1. Controla as mutações da árvore de estados através de _reducers_
2. Recebe assinaturas de _subscribers_
3. Publica todas as alterações na árvore de estados para todos os _subscribers_

Os _reducers_ são funções puras que calculam novos valores para o estado com base no estado atual e em **mensagens** que são emitidas pelos clientes da _store_. Estas mensagens, que chamaremos de _actions_, são a representação das interações entre o app e o mundo exterior, e são a única maneira fornecida pela _store_ para causar transformações no estudo. Desta forma, torna-se impossível modificar o estado sem passar pelos _reducers_, fazendo com que os dados consumidos por todo o app estejam sempre em dia, consistentes e previsíveis.

Esta estrutura exige um mecanismo de gerenciamento de efeitos colaterais para que o app possa se comunicar com o mundo exterior (como APIs, bancos de dados, _filesystems_ etc.). Este gerenciamento foi implementado nesta versão utilizando a noção de _efeitos_. Efeitos são unidades de código que podem se comunicar livremente com o mundo exterior, mas que só podem devolver os resultados dessa comunicação para a _store_ por meio de _actions_. A _store_ é o único componente da arquitetura capaz de executar estes efeitos, que são retornados pelos _reducers_ como parte do _pipeline_ de transformação do estado. Como os _reducers_ apenas definem os efeitos não os executam, eles permanecem puro e pode ser testados de forma unitária e previsível.

O "mundo exterior" é representado pelos _environments_, objetos encarregados da injeção de dependências. A _store_ recebe um _environment_ global e cada _reducer_ (em outras palavras, cada _feature_) recebe um _environment_ local que é um subconjunto do _environment_ global. Estes objetos nada mais são que _getters_ para objetos de serviço que se comunicam com o mundo exterior, como _clients_ de API ou de banco de dados, _location managers_, _loggers_ etc.

## Dependencências de terceiros

Esta versão do iddog tentou fazer o mínimo uso de dependências externas, apoiando-se na filosofia de que dependências externas são código que não conhecemos e que não temos controle, tornando-se assim um portal para complexidade possivelmente indesejada.

Seguindo as recomendações do enunciado do desafio, optamos por usar dependências externas para a camada de rede e para o _download_ e _cache_ das imagens, além de um terceiro caso de uso: geração de enumerações para _assets_ e _strings_. Geradores de código que enumeram _assets_, _strings_ e outros recursos estáticos consumidos pela aplicação são muito úteis pois diminuem a possibilidade de erros causados por referências a recursos inexistentes ou erros de nomenclatura, além de permitir a verificação dessas referências em tempo de compilação.

O app faz uso das seguintes dependências externas:

- [Alamofire](https://github.com/Alamofire/Alamofire): comunicação com a internet
- [Kingfisher](https://github.com/onevcat/Kingfisher): _download_ e _cache_ de imagens
- [SwiftGen](https://github.com/SwiftGen/SwiftGen): geração de código

Todas elas são baixadas, instaladas e gerenciadas utilizando CocoaPods.

## Trade-offs

Apesar de implementar um app muito simples, esta versão do iddog buscou ser um _showcase_ de noções de arquitura, de filosofias de desenvolvimento e de padrões de projeto. De fato, mais tempo foi gasto na estrutura e na arquitetura do que de fato na implementação das _features_ − uma decisão totalmente consciente.

Por conta disso, alguns _trade-offs_ precisaram ser assimilados.

### UI

A camada de apresentação buscou seguir boas práticas e consistência na definição dos _layouts_ e na organização da hierarquia de componentes, mas usou noções mínimas de _UI_ e _UX_. O foco foi muito mais forte na construção de uma _interface_ funcional que uma _interface_ bonita e usável.

### Testes

A base de código inclui apenas testes unitários e nenhum teste integrado nem testes _end-to-end_. Esta foi uma decisão tomada conforme o prazo foi chegando ao fim, utilizando os seguintes raciocínios:

- O app é muito simples e nenhuma das camadas implementa regras de negócio complexas
- Faltou organização e atenção ao cronograma durante o desenvolvimento, e os testes mais robustos foram despriorizados pela razão entre o custo de implementação e o valor agregado para o projeto.

## Stack

- macOS 10.14.6
- Xcode 11.3.1
- Swift 5.0
- Ruby 2.7.1
- CocoaPods 1.9.3

## Referências

- The Composable Architecture
  https://github.com/pointfreeco/swift-composable-architecture
- pointfree.co − Composable Architecture
  https://www.pointfree.co/collections/composable-architecture
- Modular Architecture in iOS
  https://medium.com/flawless-app-stories/a-modular-architecture-in-swift-aafd9026aa99