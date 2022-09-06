* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /login.
Resource         ../keywords/login_keywords.robot

Suite Setup      Run Keywords    Criar Sessao
...              AND             Carregar JSON    ${login_json}

* Test Cases *
#########################
#         POST          #
#     CT-L01 ~ CT-L03   #
#########################
CT-L01: POST Fazer Login Com Sucesso 200
    [Documentation]    Teste de login de usuário com sucesso.
    [Tags]             POST    STATUS-2XX
    
    [Setup]            Preparar Novo Usuario Estatico    user_valido    ${json["dados_cadastro"]["user_valido"]}
        
    ${login}                     Set Variable         ${json["dados_teste"]["user_valido"]}

    ${response}                  Enviar POST    /login    ${login}

    Validar Login Com Sucesso    ${response}

    Validar Token Valido         ${response.json()["authorization"]}

    [Teardown]         Limpar Registro De Usuarios


CT-L02: POST Tentar Fazer Login Com Usuario Inexistente 400
    [Documentation]         Teste para tentativa de login com informações de usuário inexistente.
    [Tags]                  POST    STATUS-4XX
    
    ${response}             Tentar Login    "user_inexistente"

    Validar Status Code     400    ${response}
    Validar Mensagem        Email e/ou senha inválidos    ${response}


CT-L03: POST Tentar Fazer Login Com Dados Inválidos 400
    [Documentation]            Teste para tentativa de login com dados inválidos.
    ...                        Os dados são gerados a partir de um modelo válido,
    ...                        mas com entradas em branco, ou faltando.
    [Tags]                     POST    STATUS-4XX

    @{dados_invalidos}         Gerar Dados Invalidos        ${json["dados_teste"]["user_valido"]}

    FOR  ${login}  IN  @{dados_invalidos}
        Log To Console         Testando: ${login}
        ${response}            Enviar POST    /login    ${login}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}
    END

##########################################################################################