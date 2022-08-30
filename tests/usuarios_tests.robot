* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /usuarios.
Resource         ../keywords/usuarios_keywords.robot

Suite Setup      Run Keywords    Criar Sessao
...              AND             Carregar JSON    ${usuarios_json}

* Test Cases * 
#########################
#         GET           #
#     CT-U01 ~ CT-U03   #
#########################
CT-U01: GET Todos Os Usuarios 200
    [Documentation]         Teste de listar todos os usuários com sucesso.
    [Tags]                  GET    STATUS-2XX
    ##########
    # Teste
    ${response}             Enviar GET    /usuarios

    Validar Status Code     200    ${response}
    Log To Console          ${response.json()}


CT-U02: GET Buscar Usuario Existente 200
    [Documentation]        Teste de busca de usuário existente por id.
    [Tags]                 GET    STATUS-2XX
    ##########
    # Setup
    ${usuario}                 Set Variable         ${json["dados_cadastro"]["user_valido"]}
    ${id_usuario}              Cadastrar Usuario    ${usuario}

    ##########
    # Teste
    ${response}                Enviar GET    /usuarios/${id_usuario}

    Validar Status Code        200    ${response}
    Validar Usuario     ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${usuario}

    #########################
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}
    

CT-U03: GET Tentar Buscar Usuario Inexistente 400
    [Documentation]        Teste para tentativa de busca de produto por id inexistente.
    [Tags]                 GET    STATUS-4XX
    ##########
    # Setup
    ${id_usuario}          Set Variable    naoexiste123

    ##########
    # Teste
    ${response}            Enviar GET    /usuarios/${id_usuario}

    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}


#########################
#         POST          #
#     CT-U04 ~ CT-U06   #
#########################
CT-U04: POST Cadastrar Novo Usuario 201
    [Documentation]        Teste de cadastrar um novo usuário com sucesso.
    [Tags]                 POST    STATUS-2XX
    ##########
    # Setup
    ${usuario}                 Set Variable    ${json["dados_cadastro"]["user_valido"]}

    ##########
    # Teste
    ${response}                Enviar POST    /usuarios    ${usuario}

    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    Should Not Be Empty        ${response.json()["_id"]}
    
    # Verificar se o usuário foi realmente criado
    ${id_usuario}              Set Variable    ${response.json()["_id"]}

    ${response}                Enviar GET    /usuarios/${id_usuario}

    Validar Status Code        200    ${response}
    Validar Usuario     ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${usuario}
    
    #########################
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}
    

CT-U05: POST Tentar Cadastrar Usuario Com Email Repetido 400
    [Documentation]          Teste para tentativa de cadastro de usuário com email já cadastrado.
    [Tags]                   POST    STATUS-4XX
    ##########
    # Setup
    ${usuario}               Set Variable             ${json["dados_cadastro"]["user_valido"]}
    ${id_cadastrado}         Cadastrar Usuario        ${usuario}

    ${usuario}               Set Variable    ${json["dados_cadastro"]["user_email_repetido"]}

    ##########
    # Teste    
    ${response}              Enviar POST    /usuarios    ${usuario}

    Validar Status Code      400    ${response}
    Validar Mensagem         Este email já está sendo usado    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]               Deletar Usuario    ${id_cadastrado}


CT-U06: POST Tentar Cadastrar Usuario Com Dados Inválidos 400
    [Documentation]            Teste para tentativa de cadastro de usuário com dados inválidos.
    ...                        Os dados são gerados a partir de um modelo válido,
    ...                        mas com entradas em branco, ou faltando.
    [Tags]                     POST    STATUS-4XX

    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_cadastro"]["user_valido"]}

    FOR  ${usuario}  IN  @{dados_invalidos}
        Log To Console         Testando: ${usuario}
        ${response}            Enviar POST    /usuarios    ${usuario}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}
    END
    

#########################
#         DELETE        #
#     CT-U07 ~ CT-U09   #
#########################
CT-U07: DELETE Excluir Usuario Existente 200
    [Documentation]        Teste de excluir usuário existente com sucesso.
    [Tags]                 DELETE    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=false  
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}    

    ##########
    # Teste
    ${response}            Enviar DELETE    /usuarios/${id_usuario}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verificar se o usuário foi realmente excluído
    ${response}            Enviar GET    /usuarios/${id_usuario}

    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}


CT-U08: DELETE Tentar Excluir Usuario Inexistente 200
    [Documentation]        Teste de tentativa de excluir usuário inexistente.
    [Tags]                 DELETE    STATUS-2XX
    ##########
    # Setup
    ${id_usuario}          Set Variable    naoexiste123

    ##########
    # Teste
    ${response}            Enviar DELETE    /usuarios/${id_usuario}

    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}


CT-U09: DELETE Tentar Excluir Usuario Com Carrinho 400
    [Documentation]        Teste de tentativa de excluir usuário com carrinho cadastrado.
    [Tags]                 DELETE    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${id_carrinho}         Cadastrar Carrinho   ${id_produto}    ${token_auth}

    ##########
    # Teste
    ${response}            Enviar DELETE    /usuarios/${id_usuario}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir usuário com carrinho cadastrado    ${response}
    Should Be Equal        ${response.json()["idCarrinho"]}    ${id_carrinho}

    # Verificar se o usuário realmente NÃO foi excluído
    ${response}            Enviar GET    /usuarios/${id_usuario}

    Validar Status Code       200    ${response}
    Validar Usuario    ${response.json()}

    #########################
    # Limpeza de dados
    [Teardown]             Run Keywords    Cancelar Compra    ${token_auth}
    ...                    AND             Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}
    

#########################
#        PUT            #
#    CT-U10 ~ CT-U15    #
#########################
CT-U10: PUT Editar Usuario Existente 200
    [Documentation]        Teste de edição de um usuário existente com sucesso.
    [Tags]                 PUT    STATUS-2XX
    ##########
    # Setup
    ${id_usuario}              Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}             Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ##########
    # Teste
    ${response}                Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}

    Validar Status Code        200    ${response}
    Validar Mensagem           Registro alterado com sucesso    ${response}

    # Verificar se o usuário foi realmente editado
    ${response}                Enviar GET    /usuarios/${id_usuario}

    Validar Status Code        200    ${response}
    Validar Usuario     ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${novos_dados}

    #########################
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}


CT-U11: PUT Tentar Editar Usuário Inexistente 201
    [Documentation]        Teste de edição de um usuário inexistente com sucesso.
    [Tags]                 PUT    STATUS-2XX
    ##########
    # Setup    
    ${id_usuario}              Set Variable    naoexiste1241

    ${novos_dados}             Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ##########
    # Teste
    ${response}                Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}

    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}

    # Verificar se o usuário foi realmente criado
    ${id_usuario}              Set Variable    ${response.json()["_id"]}

    ${response}                Enviar GET    /usuarios/${id_usuario}

    Validar Status Code        200    ${response}
    Validar Usuario     ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${novos_dados}

    #########################
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}


CT-U12: PUT Tentar Editar Usuario Existente Com Email Repetido 400
    [Documentation]        Teste de tentativa de edição de um usuário existente com
    ...                    o email de outro usuário já cadastrado.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    ${id_usuario_email}         Cadastrar Usuario    ${json["dados_edicao"]["user_email_repetido"]}

    ${id_usuario_editado}       Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}              Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}
    
    ##########
    # Teste
    ${response}                 Enviar PUT    /usuarios/${id_usuario_editado}    ${novos_dados}

    Validar Status Code         400    ${response}
    Validar Mensagem            Este email já está sendo usado    ${response}

    # Verificar se o usuário realmente NÃO foi editado
    ${response}                Enviar GET    /usuarios/${id_usuario_editado}

    Validar Status Code        200    ${response}
    Validar Usuario     ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${json["dados_edicao"]["user_inicial"]}

    #########################
    # Limpeza dos dados
    [Teardown]                  Run Keywords    Deletar Usuario    ${id_usuario_email}
    ...                         AND             Deletar Usuario    ${id_usuario_editado}


CT-U13: PUT Tentar Editar Usuário Inexistente Com Email Repetido 400
    [Documentation]        Teste de tentativa de edição de um usuário inexistente com
    ...                    o email de outro usuário já cadastrado.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    ${id_usuario_email}         Cadastrar Usuario    ${json["dados_edicao"]["user_email_repetido"]}

    ${id_usuario_editado}       Set Variable    naoexiste124

    ${novos_dados}              Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}
    
    ##########
    # Teste
    ${response}                 Enviar PUT    /usuarios/${id_usuario_editado}    ${novos_dados}

    Validar Status Code         400    ${response}
    Validar Mensagem            Este email já está sendo usado    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]                  Deletar Usuario    ${id_usuario_email}


CT-U14: PUT Tentar Editar Usuario Existente Com Dados Inválidos 400
    [Documentation]            Teste para tentativa de edição de usuário existente com dados inválidos.
    ...                        Os dados são gerados a partir de um modelo válido,
    ...                        mas com entradas em branco, ou faltando.
    [Tags]                     PUT    STATUS-4XX
    ##########
    # Setup
    ${id_usuario}              Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ##########
    # Teste
    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_edicao"]["edicao_valida"]}

    FOR  ${edicao}  IN  @{dados_invalidos}
        Log To Console         Testando: ${edicao}
        ${response}            Enviar PUT    /usuarios/${id_usuario}    ${edicao}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}
    END

    #########################
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}


CT-U15: PUT Tentar Editar Usuario Inexistente Com Dados Inválidos 400
    [Documentation]            Teste para tentativa de edição de usuário inexistente com dados inválidos.
    ...                        Os dados são gerados a partir de um modelo válido,
    ...                        mas com entradas em branco, ou faltando.
    [Tags]                     PUT    STATUS-4XX
    ##########
    # Setup
    ${id_usuario}              Set Variable    nao_existe12341

    ##########
    # Teste
    @{dados_invalidos}         Gerar Dados Invalidos    ${json["dados_edicao"]["edicao_valida"]}

    FOR  ${edicao}  IN  @{dados_invalidos}
        Log To Console         Testando: ${edicao}
        ${response}            Enviar PUT    /usuarios/${id_usuario}    ${edicao}

        Validar Status Code    400    ${response}
        Log To Console         ${response.json()}
    END


##########################################################################################