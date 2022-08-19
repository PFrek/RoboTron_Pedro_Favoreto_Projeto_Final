* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /login da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${arquivo_json}         login_dados.json



* Test Cases *
#########################
#         POST          #
#     CT-L01 ~ CT-L06   #
#########################
CT-L01: POST Fazer Login Com Sucesso 200
    [Documentation]        Teste de login de usuário com sucesso.
    [Tags]                 POST    STATUS-2XX
    ##########
    # Setup
    Criar Sessao
    ${json}                Carregar JSON        ${arquivo_json}
    
    ${usuario_id}          Cadastrar Usuario    ${json["dados_cadastro"]["user_valido"]}
    ${login}               Set Variable         ${json["dados_teste"]["user_valido"]}

    ##########
    # Teste
    ${response}            Enviar POST    /login    ${login}

    Validar Status Code    200    ${response}
    Validar Mensagem       Login realizado com sucesso    ${response}
    Should Not Be Empty    ${response.json()["authorization"]}

    #########################
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${usuario_id}


CT-L02: POST Tentar Fazer Login Com Usuario Inexistente 400
    [Documentation]         Teste para tentativa de login com informações de usuário inexistente.
    [Tags]                  POST    STATUS-4XX
    ####################
    # Setup & Teste
    Criar Sessao

    ${response}             Tentar Login    "user_inexistente"

    Validar Status Code     400    ${response}
    Validar Mensagem        Email e/ou senha inválidos    ${response}


##############################################
# CT-L03 ~ CT-L06: Testes de dados inválidos #
##############################################
CT-L03: POST Tentar Fazer Login Com Email Em Branco 400
    [Documentation]         Teste para tentativa de login com email em branco.
    [Tags]                  POST    STATUS-4XX
    ####################
    # Setup & Teste
    Criar Sessao

    ${response}             Tentar Login    "user_email_em_branco"

    Validar Status Code     400    ${response}
    Log To Console          ${response.json()}


CT-L04: POST Tentar Fazer Login Sem Email 400
    [Documentation]         Teste para tentativa de login sem campo de email.
    [Tags]                  POST    STATUS-4XX
    ####################
    # Setup & Teste
    Criar Sessao

    ${response}             Tentar Login    "user_sem_email"

    Validar Status Code     400    ${response}
    Log To Console          ${response.json()}


CT-L05: POST Tentar Fazer Login Com Senha Em Branco 400
    [Documentation]        Teste para tentativa de login com senha em braco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    Criar Sessao

    ${response}            Tentar Login    "user_senha_em_branco"

    Validar Status Code    400    ${response}
    Log To Console         ${response.json()}


CT-L06: POST Tentar Fazer Login Sem Senha 400
    [Documentation]        Teste para tentativa de login sem campo de senha.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    Criar Sessao

    ${response}            Tentar Login    "user_sem_senha"

    Validar Status Code    400    ${response}
    Log To Console         ${response.json()}


##########################################################################################

* Keywords *

Tentar Login
    [Documentation]         Realiza uma tentativa de login com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de login.
    [Arguments]             ${json_login}

    ${json}                 Carregar JSON    ${arquivo_json}
    ${login}                Set Variable     ${json["dados_teste"][${json_login}]}
    ${response}             Enviar POST      /login    ${login}
    [Return]                ${response}
