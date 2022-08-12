* Settings *
Documentation    Arquivo contendo os testes para o endpoint /login da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${endpoint}           /login



* Test Cases *
Cenario: POST Fazer Login Com Sucesso 200
    [Documentation]        Teste de login de usuario com sucesso.
    [Tags]                 POST

    Criar Sessao
    &{usuario}=            Obter Dados De Usuario Existente
    &{login}=              Obter Informacoes De Login    &{usuario}
    ${response}=           Enviar POST    ${endpoint}    &{login}
    Validar Status Code    200    ${response}
    Validar Mensagem       Login realizado com sucesso    ${response}


# Aviso: Atualmente não garante que o email não existe!
Cenario: POST Tentar Fazer Login Com Usuario Inexistente 401
    [Documentation]         Teste para tentativa de login com informações de usuário inexistente.
    [Tags]                  POST

    Criar Sessao
    &{login}=               Create Dictionary    email=naoexiste@nao.com    password=1234
    ${response}=            Enviar POST    ${endpoint}    &{login}
    Validar Status Code     401    ${response}
    Validar Mensagem        Email e/ou senha inválidos    ${response}
    

Cenario: POST Tentar Fazer Login Com Dados Inválidos 400
    [Documentation]         Teste para tentativa de login com informações de usuário faltando.
    [Tags]                  POST

    Criar Sessao
    &{login}=               Create Dictionary    email=teste@a.com    # Informações de login faltando a senha
    ${resposta}=            Enviar POST    ${endpoint}    &{login}
    Validar Status Code     400    ${resposta}


* Keywords *

# Todas as keywords obtidas do recurso keywords_comuns.robot