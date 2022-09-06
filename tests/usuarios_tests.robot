* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /usuarios.
Resource         ../keywords/usuarios_keywords.robot

Suite Setup      Run Keywords    Criar Sessao
...              AND             Carregar JSON    ${usuarios_json}
...              AND             Set Suite Variable    &{registro_usuarios}    &{EMPTY}

* Test Cases * 
#########################
#         GET           #
#     CT-U01 ~ CT-U03   #
#########################
CT-U01: GET Todos Os Usuarios 200
    [Documentation]    Teste de listar todos os usuários com sucesso.
    [Tags]             GET    STATUS-2XX

    ${response}             Enviar GET    /usuarios

    Validar Status Code     200    ${response}
    Log To Console          ${response.json()}


CT-U02: GET Buscar Usuario Existente 200
    [Documentation]    Teste de busca de usuário existente por id.
    [Tags]             GET    STATUS-2XX

    [Setup]            Preparar Novo Usuario Estatico    user_valido    ${json["dados_cadastro"]["user_valido"]}

    ${response}                Enviar GET    /usuarios/${registro_usuarios.user_valido}

    Validar Status Code        200    ${response}
    Validar Usuario            ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${json["dados_cadastro"]["user_valido"]}

    [Teardown]         Limpar Registro De Usuarios
    

CT-U03: GET Tentar Buscar Usuario Inexistente 400
    [Documentation]    Teste para tentativa de busca de produto por id inexistente.
    [Tags]             GET    STATUS-4XX

    ${id_usuario}          Set Variable    naoexiste123

    ${response}            Enviar GET    /usuarios/${id_usuario}

    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}


#########################
#         POST          #
#     CT-U04 ~ CT-U06   #
#########################
CT-U04: POST Cadastrar Novo Usuario 201
    [Documentation]    Teste de cadastrar um novo usuário com sucesso.
    [Tags]             POST    STATUS-2XX

    ${dados_usuario}              Set Variable    ${json["dados_cadastro"]["user_valido"]}

    ${response}                   Enviar POST    /usuarios    ${dados_usuario}

    Validar Status Code           201    ${response}
    Validar Mensagem              Cadastro realizado com sucesso    ${response}
    Should Not Be Empty           ${response.json()["_id"]}
    
    # Verifica se o usuário foi realmente criado.
    ${id_usuario}                 Set Variable    ${response.json()["_id"]}
    Validar Dados De Usuario    ${id_usuario}    ${dados_usuario}
    
    [Teardown]         Deletar Usuario    ${id_usuario}
    

CT-U05: POST Tentar Cadastrar Usuario Com Email Repetido 400
    [Documentation]    Teste para tentativa de cadastro de usuário com email já cadastrado.
    [Tags]             POST    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Estatico    user_valido    ${json["dados_cadastro"]["user_valido"]}
    
    ${dados_usuario}               Set Variable    ${json["dados_cadastro"]["user_email_repetido"]}

    ${num_users_inicial}           Obter Quantidade De Usuarios

    ${response}                    Enviar POST    /usuarios    ${dados_usuario}

    Validar Status Code            400    ${response}
    Validar Mensagem               Este email já está sendo usado    ${response}

    # Verifica se a quantidade de usuários permanece a mesma.
    ${num_users_final}             Obter Quantidade De Usuarios
    Should Be Equal As Integers    ${num_users_inicial}    ${num_users_final}

    [Teardown]         Limpar Registro De Usuarios


CT-U06: POST Tentar Cadastrar Usuario Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de cadastro de usuário com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             POST    STATUS-4XX

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_cadastro"]["user_valido"]}

    FOR  ${usuario}  IN  @{dados_invalidos}

        Log To Console         Testando: ${usuario}

        ${num_users_inicial}           Obter Quantidade De Usuarios

        ${response}            Enviar POST    /usuarios    ${usuario}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}

        # Verifica se a quantidade de usuários permanece a mesma.
        ${num_users_final}             Obter Quantidade De Usuarios
        Should Be Equal As Integers    ${num_users_inicial}    ${num_users_final}
    
    END
    

#########################
#         DELETE        #
#     CT-U07 ~ CT-U09   #
#########################
CT-U07: DELETE Excluir Usuario Existente 200
    [Documentation]    Teste de excluir usuário existente com sucesso.
    [Tags]             DELETE    STATUS-2XX

    [Setup]            Preparar Novo Usuario Dinamico    user_admin    administrador=true

    ${response}            Enviar DELETE    /usuarios/${registro_usuarios.user_admin}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verifica se o usuário foi realmente excluído
    ${response}            Enviar GET    /usuarios/${registro_usuarios.user_admin}

    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}

    [Teardown]         Remover Usuario Do Registro    user_admin


CT-U08: DELETE Tentar Excluir Usuario Inexistente 200
    [Documentation]    Teste de tentativa de excluir usuário inexistente.
    [Tags]             DELETE    STATUS-2XX
    
    ${id_usuario}                  Set Variable    naoexiste123

    ${num_users_inicial}           Obter Quantidade De Usuarios

    ${response}                    Enviar DELETE    /usuarios/${id_usuario}

    Validar Status Code            200    ${response}
    Validar Mensagem               Nenhum registro excluído    ${response}

    # Verifica se a quantidade de usuários permanece a mesma.
    ${num_users_final}             Obter Quantidade De Usuarios
    Should Be Equal As Integers    ${num_users_inicial}    ${num_users_final}


CT-U09: DELETE Tentar Excluir Usuario Com Carrinho 400
    [Documentation]    Teste de tentativa de excluir usuário com carrinho cadastrado.
    [Tags]             DELETE    STATUS-4XX

    [Setup]            Preparar Usuario Com Carrinho

    ${response}            Enviar DELETE    /usuarios/${registro_usuarios.user_carrinho}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir usuário com carrinho cadastrado    ${response}

    # Verifica se o usuário realmente NÃO foi excluído
    ${response}            Enviar GET    /usuarios/${registro_usuarios.user_carrinho}

    Validar Status Code    200    ${response}
    Validar Usuario        ${response.json()}

    [Teardown]         Limpar Usuario Com Carrinho
    

#########################
#        PUT            #
#    CT-U10 ~ CT-U15    #
#########################
CT-U10: PUT Editar Usuario Existente 200
    [Documentation]    Teste de edição de um usuário existente com sucesso.
    [Tags]             PUT    STATUS-2XX

    [Setup]            Preparar Novo Usuario Estatico    user_inicial    ${json["dados_edicao"]["user_inicial"]}
    
    ${novos_dados}             Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${response}                Enviar PUT    /usuarios/${registro_usuarios.user_inicial}    ${novos_dados}

    Validar Status Code        200    ${response}
    Validar Mensagem           Registro alterado com sucesso    ${response}

    # Verifica se o usuário foi realmente editado
    Validar Dados De Usuario    ${registro_usuarios.user_inicial}    ${novos_dados}

    [Teardown]         Limpar Registro De Usuarios


CT-U11: PUT Tentar Editar Usuário Inexistente 201
    [Documentation]    Teste de edição de um usuário inexistente com sucesso.
    [Tags]             PUT    STATUS-2XX
    
    ${id_usuario}              Set Variable    naoexiste1241
    
    ${novos_dados}             Set Variable    ${json["dados_edicao"]["edicao_valida"]}
    
    ${response}                Enviar PUT      /usuarios/${id_usuario}    ${novos_dados}

    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}

    # Verifica se o usuário foi realmente criado
    ${id_usuario}              Set Variable    ${response.json()["_id"]}
    Validar Dados De Usuario    ${id_usuario}    ${novos_dados}

    [Teardown]         Deletar Usuario    ${id_usuario}


CT-U12: PUT Tentar Editar Usuario Existente Com Email Repetido 400
    [Documentation]    Teste de tentativa de edição de um usuário existente com
    ...                o email de outro usuário já cadastrado.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Run Keywords
    ...                Preparar Novo Usuario Estatico    user_email_repetido    ${json["dados_edicao"]["user_email_repetido"]}
    ...    AND         Preparar Novo Usuario Estatico    user_inicial           ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}              Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}
    
    ${response}                 Enviar PUT    /usuarios/${registro_usuarios.user_inicial}    ${novos_dados}

    Validar Status Code         400    ${response}
    Validar Mensagem            Este email já está sendo usado    ${response}

    # Verificar se o usuário realmente NÃO foi editado
    Validar Dados De Usuario    ${registro_usuarios.user_inicial}    ${json["dados_edicao"]["user_inicial"]}

    [Teardown]         Limpar Registro De Usuarios


CT-U13: PUT Tentar Editar Usuário Inexistente Com Email Repetido 400
    [Documentation]    Teste de tentativa de edição de um usuário inexistente com
    ...                o email de outro usuário já cadastrado.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Estatico    user_email_repetido    ${json["dados_edicao"]["user_email_repetido"]}

    ${id_usuario_editado}          Set Variable    naoexiste124

    ${novos_dados}                 Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}

    ${num_users_inicial}           Obter Quantidade De Usuarios

    ${response}                    Enviar PUT    /usuarios/${id_usuario_editado}    ${novos_dados}

    Validar Status Code            400    ${response}
    Validar Mensagem               Este email já está sendo usado    ${response}

    # Verifica se a quantidade de usuários permanece a mesma.
    ${num_users_final}             Obter Quantidade De Usuarios
    Should Be Equal As Integers    ${num_users_inicial}    ${num_users_final}

    [Teardown]         Limpar Registro De Usuarios


CT-U14: PUT Tentar Editar Usuario Existente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de usuário existente com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             PUT    STATUS-4XX
    
    [Setup]            Preparar Novo Usuario Estatico    user_inicial    ${json["dados_edicao"]["user_inicial"]}

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_edicao"]["edicao_valida"]}

    FOR  ${edicao}  IN  @{dados_invalidos}
        Log To Console                 Testando: ${edicao}

        ${response}                    Enviar PUT    /usuarios/${registro_usuarios.user_inicial}    ${edicao}

        Validar Status Code            400    ${response}
        Log To Console                 ${response.json()}

        # Verifica se o usuário realmente NÃO foi editado
        Validar Dados De Usuario    ${registro_usuarios.user_inicial}    ${json["dados_edicao"]["user_inicial"]}
        
    END

    [Teardown]         Limpar Registro De Usuarios


CT-U15: PUT Tentar Editar Usuario Inexistente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com dados inválidos.
    ...                Os dados são gerados a partir de um modelo válido,
    ...                mas com entradas em branco, ou faltando.
    [Tags]             PUT    STATUS-4XX

    ${id_usuario}              Set Variable    nao_existe12341

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_edicao"]["edicao_valida"]}

    FOR  ${edicao}  IN  @{dados_invalidos}
        Log To Console         Testando: ${edicao}
        ${num_users_inicial}           Obter Quantidade De Usuarios

        ${response}            Enviar PUT    /usuarios/${id_usuario}    ${edicao}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}

        # Verifica se a quantidade de usuários permanece a mesma.
        ${num_users_final}             Obter Quantidade De Usuarios
        Should Be Equal As Integers    ${num_users_inicial}    ${num_users_final}
    END


##########################################################################################