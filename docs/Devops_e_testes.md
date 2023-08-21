# Boas Práticas de Git Flow, Versionamento de Código e Escrita de Testes
O desenvolvimento de software eficaz e colaborativo depende de práticas sólidas de controle de versão, gestão de código e garantia de qualidade através de testes adequados. Neste artigo, exploraremos as boas práticas do Git Flow, estratégias de versionamento de código e dicas para escrever testes de qualidade.

##Git Flow: Gerenciando o Fluxo de Desenvolvimento
O Git Flow é um modelo de fluxo de trabalho popular que define uma estrutura robusta para o desenvolvimento colaborativo com o Git. Ele estabelece papéis e processos claros para diferentes estágios do ciclo de vida de um projeto. As principais ramificações incluem:

- **Master**: Esta é a ramificação principal que reflete o estado do projeto em produção. Commits nesta ramificação são estáveis e bem testados.

- **Develop**: Esta ramificação serve como uma base para o desenvolvimento contínuo. As novas funcionalidades e correções são mescladas nesta ramificação antes de serem testadas e consolidadas.

- **Feature Branches**: Para cada nova funcionalidade, uma ramificação separada é criada a partir de develop. Após a implementação, ela é mesclada de volta à develop.

- **Release Branches**: Ramificações de lançamento são criadas para preparar uma nova versão. Correções de bugs menores são aplicadas nesta ramificação antes de serem fundidas em master e develop.

- **Hotfix Branches**: Para correções urgentes em produção, cria-se uma ramificação de correção. Esta é mesclada tanto em master quanto em develop.

## Versionamento de Código: Mantendo o Controle do seu projeto
O versionamento de código é crucial para a rastreabilidade e o gerenciamento de alterações. A Semantic Versioning (SemVer) é uma convenção popular para nomear versões de software:

**Major**: Mudanças incompatíveis com versões anteriores.
**Minor**: Adição de funcionalidades, mantendo compatibilidade.
**Patch**: Correções de bugs, mantendo compatibilidade.
Adotar o [SemVer](https://semver.org/) facilita a compreensão do impacto das atualizações para outros desenvolvedores e usuários.

## Boas Práticas de Escrita de Testes
Testes bem escritos garantem a qualidade do código e evitam regressões. Aqui estão algumas boas práticas:

- **Testes Unitários**: Teste unidades isoladas de código. Use estruturas como JUnit (Java), Pytest (Python) ou Jasmine (JavaScript) para escrever testes independentes.

- **Testes de Integração**: Garanta que componentes trabalhem bem juntos. Teste integrações de módulos, APIs e serviços.

- **Testes Automatizados**: Automatize a execução de seus testes. Isso permite que eles sejam executados de maneira rápida e consistente sempre que houver uma mudança no código. Ferramentas como Jenkins, Travis CI e GitLab CI podem ser integradas para executar testes automaticamente.

- **Test-Driven Development (TDD)**: Escreva testes antes de implementar funcionalidades. Isso guia o desenvolvimento e ajuda a evitar código desnecessário. Vamos abordar um pouco mais sobre este modelo de TDD abaixo.

- **Testes Unitários Adequados com estrutura organizada**:Testes unitários devem focar em unidades individuais de código, como funções ou métodos.  Certifique-se de testar todos os cenários possíveis, incluindo casos de borda e condições especiais. Mantenha os testes pequenos, independentes e de fácil entendimento. Organize seus testes em uma estrutura clara, geralmente seguindo a estrutura do código fonte. Use pastas e módulos separados para diferentes componentes e funcionalidades. Uma boa leitura é o livro [Código Limpo](https://www.amazon.com.br/C%C3%B3digo-limpo-Robert-C-Martin/dp/8576082675) de Robert C. Martin.

- **Nomenclatura Significativa: Dê nomes significativos aos seus testes. Um nome bem escolhido deve indicar qual comportamento está sendo testado. Isso ajuda a entender rapidamente o propósito do teste quando ele falha.

- **Compreensão dos Requisitos
Antes de escrever um teste, certifique-se de entender completamente os requisitos do componente ou funcionalidade que está sendo testado. Isso garante que você esteja testando os cenários corretos.

- **Testes de Regressão
Sempre que você encontrar um bug, crie um teste automatizado que reproduza esse bug. Isso ajuda a evitar a regressão do bug no futuro.

- **Mocking e Stubs
Use ferramentas de simulação, como mocks e stubs, para isolar as partes do sistema que não estão sendo testadas. Isso ajuda a controlar o comportamento das dependências externas.

- **Testes Exploratórios
Além dos testes automatizados, realize testes exploratórios manuais para explorar diferentes cenários e identificar possíveis problemas que os testes automatizados podem ter perdido.

- **Refatoração dos Testes
Assim como você refatora o código-fonte, é importante refatorar os testes. Isso mantém os testes limpos, legíveis e alinhados com as mudanças no código.

- **Avaliação da Cobertura de Código
Use ferramentas de cobertura de código para identificar partes do código que não estão sendo testadas. A cobertura de código ajuda a garantir que os testes estejam abordando adequadamente todas as partes do código. Uma boa opção do mercado é o SonarQube.

:purple_heart:
---

# Test-Driven Development (TDD): Conceito e Processo
O TDD segue um ciclo de três etapas: Red-Green-Refactor.

**Red (Vermelho)**: Comece escrevendo um teste automatizado que inicialmente falhará. Isso define o comportamento desejado do código que você ainda não implementou.

**Green (Verde)**: Escreva o código mínimo necessário para que o teste passe. O objetivo é fazer o teste passar o mais rápido possível.

**Refactor (Refatorar)**: Agora que o teste passa, você pode refatorar o código para melhorar sua estrutura, clareza e eficiência, sempre garantindo que os testes continuem passando.

## Exemplo de TDD com Node.js e Jest
Vamos considerar um cenário simples: você deseja implementar uma função de soma em um módulo Node.js e deseja aplicar TDD a essa implementação usando o framework de teste Jest.

### Configuração

Certifique-se de ter Node.js instalado e, em seguida, crie um diretório para o projeto e execute:

```sh
npm init -y
npm install --save-dev jest
```

### Escrever o Primeiro Teste

Crie um arquivo chamado sum.test.js na pasta do seu projeto:

```javascript
// sum.test.js
const sum = require('./sum');

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});
```

Neste ponto, você não tem a função sum implementada ainda, mas

### Passo 3: Implementar o Código

Crie um arquivo chamado sum.js na mesma pasta e escreva a função sum:

```javascript
// sum.js
function sum(a, b) {
  return a + b;
}
```

module.exports = sum;
Agora a implementação básica da função sum está completa.

### Passo 4: Executar os Testes

Execute os testes usando o Jest:

```sh
npx jest
```

Se tudo estiver correto, o teste que você escreveu no arquivo sum.test.js deve passar.

### Passo 5: Refatoração (Opcional)

Neste exemplo simples, a função sum é tão direta que a refatoração pode não ser necessária. Mas em cenários mais complexos, a refatoração é onde você pode melhorar a estrutura do código e garantir que os testes continuem passando.

## Mocking e Stubs
Use ferramentas para simular partes do sistema que não estão sendo testadas. Aqui está um exemplo de como fazer mocking e stubs usando o Jest em um cenário de teste de uma função que faz uma requisição HTTP utilizando o módulo `axios`.

Suponhamos que temos uma função `fetchData` que faz uma requisição *HTTP* e retorna os dados obtidos:

```javascript
// fetchData.js
const axios = require('axios');

async function fetchData(url) {
  try {
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    throw new Error('Erro na requisição');
  }
}

module.exports = fetchData;
```

Agora, vamos escrever testes para essa função, usando mocking para simular a requisição HTTP.

### Instalação das Dependências

Certifique-se de ter o Jest instalado no seu projeto:

```sh
npm install --save-dev jest
```

### Escrevendo o Teste com Mocking

Aqui está um exemplo de teste usando mocking para simular a requisição HTTP usando o módulo axios:

``` javascript
// fetchData.test.js
const axios = require('axios');
const fetchData = require('./fetchData');

jest.mock('axios');

test('fetchData should fetch successfully data from an API', async () => {
  const data = { data: 'data' };
  axios.get.mockResolvedValue(data);

  await expect(fetchData('https://example.com')).resolves.toEqual(data);
});

test('fetchData should throw an error if request fails', async () => {
  axios.get.mockRejectedValue(new Error('Network Error'));

  await expect(fetchData('https://example.com')).rejects.toThrow('Erro na requisição');
});
```

Nesse exemplo, estamos usando `jest.mock('axios')` para criar um *mock* do módulo *axios*. Em seguida, estamos usando `axios.get.mockResolvedValue` para simular uma resposta bem-sucedida e `axios.get.mockRejectedValue` para simular um erro na requisição.

### Executando os Testes

Execute os testes usando o Jest:

```sh
npx jest
```

Se tudo estiver configurado corretamente, os testes usando mocking devem passar.

## Testes de Regressão
Ao corrigir um bug, adicione um teste para prevenir regressões. (Pauta para um novo artigo, aguarde <3)

## Testes Exploratórios
Além de testes automatizados, realize testes manuais exploratórios para encontrar cenários não cobertos. (Pauta para um novo artigo, aguarde <3)

## Code Coverage
Utilize ferramentas para avaliar a cobertura de código por testes. Isso ajuda a identificar partes não testadas. O SonarQube é uma ferramenta popular de análise estática de código que ajuda a manter a qualidade do código, identificando problemas de código, vulnerabilidades e fornecendo insights sobre as boas práticas. Vou mostrar como integrar o exemplo de *Test-Driven Development (TDD)* que mencionamos anteriormente com o SonarQube para melhorar ainda mais a qualidade do código.

### Escrevendo Testes Usando o Jest e o SonarQube
Vamos começar definindo um cenário de teste mais abrangente para a função sum e depois veremos como integrar o SonarQube para analisar a qualidade do código.

#### Passo 1: Escrever um Teste Mais Abrangente

Vamos escrever um teste que verifica o comportamento da função sum para números positivos, negativos e zero:

```javascript
// sum.test.js
const sum = require('./sum');

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

test('adds -1 + 2 to equal 1', () => {
  expect(sum(-1, 2)).toBe(1);
});

test('adds 0 + 0 to equal 0', () => {
  expect(sum(0, 0)).toBe(0);
});
```

#### Passo 2: Configurar o SonarQube para Testes Jest

Para permitir que o SonarQube analise os resultados dos testes, é importante configurar o caminho dos relatórios dos testes. No seu arquivo `sonar-project.properties`, você já definiu `sonar.javascript.jstest.reportsPath=test`.

#### Passo 3: Executar os Testes e Analisar com o SonarQube

Agora você pode executar os testes e analisar o código usando o SonarQube. Certifique-se de ter o ambiente do SonarQube configurado e acessível.

Execute os testes e gere os relatórios no formato esperado pelo SonarQube:

```sh
npm run test:sonar
```

Execute a análise do SonarQube para seu projeto:
```sh
sonar-scanner
```
Acesse a interface do SonarQube para ver os resultados da análise. Lá, você poderá ver as métricas de qualidade do código, incluindo a cobertura de testes.

## Conclusão
O uso adequado do Git Flow, versionamento de código e práticas de teste pode melhorar significativamente a qualidade do seu código, facilitar a colaboração entre equipes e garantir um ciclo de desenvolvimento mais eficiente. Adotar essas boas práticas ajuda a criar um ambiente confiável e robusto para o desenvolvimento de software.

Lembre-se de que a adaptação dessas práticas às necessidades específicas do seu projeto é essencial. A medida que você se familiariza com essas práticas, estará bem equipado para criar software de alta qualidade e confiabilidade.

-----
