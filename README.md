# RoboTron_Pedro_Favoreto_Projeto_Final
Repositório que contém os testes da API ServeRest automatizados com Robot.

## Apresentação

### Estrutura

O projeto segue o padrão Service-Objects na sua estrutura.

- **keywords/**: contém os arquivos robot com as keywords específicas para cada endpoint.
    - carrinhos_keywords.robot
    - login_keywords.robot
    - produtos_keywords.robot
    - usuarios_keywords.robot
    
- **support/**: contém arquivos de suporte variados.
    - **common/**:
        - common.robot: contém a maior parte das keywords do projeto, que são reutilizadas por todos os endpoints.
    - **fixtures/**:
        - **static/**: contém as massas de dados estáticos para os testes, em formato json.
            - login_dados.json
            - produtos_dados.json
            - usuarios_dados.json
        - dynamics.robot: contém keywords para geração de dados dinâmicos.
        - Gerador_Dados_Invalidos.py: library python para geração de dados inválidos para as requisições.
    - **variables/**:
        - variables.robot: contém as definições de variáveis utilizadas pelas suites de testes.
    - base.robot: contém keywords para preparação e limpeza de recursos.
- **tests/**: contém os arquivos das suites de testes para cada endpoint.
    - carrinhos_tests.robot
    - login_tests.robot
    - produtos_tests.robot
    - usuarios_tests.robot
- iniciar_testes.bat: arquivo para execução de uma suite de testes individualmente.
- rodar_todos_testes.bat: arquivo para execução de todos as suites de testes. Os reports são gerados individualmente para cada suite.

### Casos de Teste

Os casos de teste estão identificados seguindo o seguinte modelo:  
CT-**[A][##]**  
**[A]**: Letra identificadora do endpoint:

- L: /login
- U: /usuarios
- P: /produtos
- C: /carrinhos

**[##]**: número do caso de teste para esse endpoint.

Exemplos:
- CT-L01: primeiro caso de teste do endpoint /login.
- CT-P03: terceiro caso de teste do endpoint /produtos.

## Mapa Mental

### Completo:

![mapa-mental-serverest](https://user-images.githubusercontent.com/16858378/188157232-889856cb-a7f2-4380-88ec-9db660c566c7.png "Mapa mental da API ServeRest")

### /login: CT-L01 ~ CT-L03

![mapa-mental-login](https://user-images.githubusercontent.com/16858378/188158203-596a4f3d-62dc-4e15-b484-7e3ccbc0c8c9.png "Mapa mental do endpoint login")

### /usuarios: CT-U01 ~ CT-U15

![mapa-mental-usuarios](https://user-images.githubusercontent.com/16858378/188158758-134f3590-7e6d-477d-abfc-8a5777eb1eb2.png "Mapa mental do endpoint usuarios")

### /produtos: CT-P01 ~ CT-P23

![mapa-mental-produtos](https://user-images.githubusercontent.com/16858378/188159267-e3bde3fe-51b0-4c41-9479-c85818e4b440.png "Mapa mental do endpoint produtos")

### /carrinhos: CT-C01 ~CT-C18

![mapa-mental-carrinhos](https://user-images.githubusercontent.com/16858378/188159572-e5bf76bd-54b8-427d-82de-1788d1a49f36.png "Mapa mental do endpoint carrinhos")


### Pré-requisitos

- Python (versão utilizada 3.8.2)
- Robot Framework (versão utilizada 5.0.1)
- Robot Framework-requests (versão utilizada 0.9.3)
- Robot Framework-faker (versão utilizada 5.0.0)

### Instalação

```bash

# 1. Clonar repositório
git clone https://github.com/PFrek/RoboTron_Pedro_Favoreto_Projeto_Final

# 2. Ir até o diretório do projeto
cd RoboTron_Pedro_Favoreto_Projeto_Final

```

### Exemplos de execução dos testes

```bash

# Rodar todos os testes de todos os endpoints
rodar_todos_testes.bat

# Rodar os testes POST de todos os endpoints
rodar_todos_testes.bat post 

# Rodar todos os testes do endpoint Produtos
iniciar_testes.bat produtos

# Rodar os testes DELETE do endpoint Produtos
iniciar_testes.bat produtos delete

# Rodar os testes PUT que contém código de sucesso (2XX) do endpoint Usuarios
iniciar_testes.bat usuarios putANDstatus-2xx
```

## Tecnologias utilizadas


- [VsCode](https://code.visualstudio.com/): IDE para edição de arquivos.
- [Python 3.8.2](https://www.python.org/downloads/release/python-382/): Linguagem utilizada para library.
- [Robot Framework](https://robotframework.org/): Biblioteca para automação de testes.
- [XMind](https://www.xmind.app/): Ferramenta para construção do mapa mental.
- [Postman](https://www.postman.com/): Utilizado para manipulações e reparos manuais nos recursos da API.


## Autores

- Pedro Favoreto Gaya: <https://github.com/PFrek>
