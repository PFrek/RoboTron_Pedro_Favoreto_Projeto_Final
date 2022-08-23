# RoboTron_Pedro_Favoreto_Projeto_Final
Repositório que contém os códigos referentes ao projeto final das Sprints 5 e 6 da trilha RoboTron.

## Apresentação

### Estrutura

O arquivo "keywords_comuns.robot", localizado na pasta raiz do projeto, contém várias keywords que foram
utilizadas em mais de um endpoint da API.

A pasta ".exemplos" contém os exemplos apresentados nos vídeos das MasterClass da Trilha.

Cada Endpoint da API ServeRest contém sua própria pasta, onde estão contidos os casos e cenários de teste das mesmas:
- **Raiz:**
    - **README.md:** arquivo readme do projeto.
    - **keywords_comuns.robot:** arquivo que contém keywords comuns utilizadas em vários endpoints.
    - **rodar_todos_testes.bat:** arquivo batch que executa os testes de todos os endpoints. Pode receber TAGs como argumento.
    - **/[Endpoint]:**
        - **[endpoint]-casos_e_cenarios.txt:** arquivo com as descrições utilizadas como base para a criação dos casos de teste.
        - **[endpoint]_dados.json:** arquivo com dados estáticos usados nos casos de teste.
        - **[endpoint].robot:** arquivo com os casos de teste e as keywords específicas do [endpoint].
        - **iniciar_testes.bat:** arquivo batch que executa os testes do [endpoint]. Pode receber TAGs como argumento.


### Pré-requisitos

- Python (versão utilizada 3.8.2)
- Robot Framework (versão utilizada 5.0.1)
- Robot Framework-Browser (versão utilizada 13.4.0)
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
# Comandos executados a partir da pasta raiz RoboTron_Pedro_Favoreto_Projeto_Final

# Rodar todos os testes de todos os endpoints
rodar_todos_testes.bat

# Rodar os testes POST de todos os endpoints
rodar_todos_testes.bat POST

# Rodar todos os testes do endpoint Produtos
cd Produtos
iniciar_testes.bat

# Rodar os testes DELETE do endpoint Produtos
cd Produtos
iniciar_testes.bat delete

# Rodar os testes PUT que contém código de sucesso (2XX) do endpoint Usuarios
cd Usuarios
iniciar_testes.bat putANDstatus-2xx
```

## Tecnologias utilizadas


- [VsCode](https://code.visualstudio.com/): IDE para edição de arquivos.
- [Python 3.8.2](https://www.python.org/downloads/release/python-382/): Linguagem utilizada nas soluções.
- [Robot Framework](https://robotframework.org/): Biblioteca para automação de testes.


## Autores

- Pedro Favoreto Gaya: <https://github.com/PFrek>


## Créditos

(Informações de créditos)