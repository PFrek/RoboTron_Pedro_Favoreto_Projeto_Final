* Settings *
Documentation    Arquivo contendo os testes para o endpoint /usuarios da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${dados_json}         usuarios_dados.json


* Test Cases * 

CT-U01: GET Todos Os Usuarios 200
    [Documentation]         Teste de listar todos os usuários com sucesso.
    [Tags]                  GET-TODOS
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=            Enviar GET    /usuarios
    Validar Status Code     200    ${response}
    Log To Console          ${response.json()}


CT-U02: POST Cadastrar Novo Usuario 201
    [Documentation]        Teste de cadastrar um novo usuário com sucesso.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}
    
    ${usuario}=                Set Variable    ${json["dados_cadastro"]["user_valido"]}

    #####
    # Teste
    ${response}=               Enviar POST    /usuarios    ${usuario}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    Should Not Be Empty        ${response.json()["_id"]}
    
    # Validar que o usuario foi realmente criado
    ${id}=                     Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    /usuarios/${id}
    Validar Status Code        200    ${response}
    Validar Usuarios Iguais    ${response.json()}    ${usuario}
    
    #####
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id}
    


CT-U03: POST Tentar Cadastrar Usuario Com Email Repetido 400
    [Documentation]          Teste para tentativa de cadastro de usuário com email já cadastrado.
    [Tags]                   POST
    #####
    # Setup
    Criar Sessao
    ${json}=                 Carregar JSON    ${dados_json}
    
    ${usuario}=              Set Variable    ${json["dados_cadastro"]["user_valido"]}
    ${id_cadastrado}=        Cadastrar Usuario        ${usuario}

    ${usuario}=              Set Variable    ${json["dados_cadastro"]["user_email_repetido"]}

    #####
    # Teste    
    ${response}=             Enviar POST    /usuarios    ${usuario}
    Validar Status Code      400    ${response}
    Validar Mensagem         Este email já está sendo usado    ${response}

    #####
    # Limpeza dos dados
    [Teardown]               Deletar Usuario    ${id_cadastrado}


CT-U04: POST Tentar Cadastrar Usuario Com Nome Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de usuário com nome em branco.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao
    
    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_nome_em_branco"
    Validar Status Code    400    ${response}

CT-U05: POST Tentar Cadastrar Usuario Sem Nome 400
    [Documentation]        Teste para tentativa de cadastro de usuário sem campo de nome.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_sem_nome"
    Validar Status Code    400    ${response}

CT-U06: POST Tentar Cadastrar Usuario Com Email Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de usuário com email em branco.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_email_em_branco"
    Validar Status Code    400    ${response}

CT-U07: POST Tentar Cadastrar Usuario Sem Email 400
    [Documentation]        Teste para tentativa de cadastro de usuário sem campo de email.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_sem_email"
    Validar Status Code    400    ${response}

CT-U08: POST Tentar Cadastrar Usuario Com Password Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de usuário com password em branco.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_password_em_branco"
    Validar Status Code    400    ${response}

CT-U09: POST Tentar Cadastrar Usuario Sem Password 400
    [Documentation]        Teste para tentativa de cadastro de usuário sem campo de password.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_sem_password"
    Validar Status Code    400    ${response}

CT-U10: POST Tentar Cadastrar Usuario Com Administrador Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de usuário com administrador em branco.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_administrador_em_branco"
    Validar Status Code    400    ${response}

CT-U11: POST Tentar Cadastrar Usuario Sem Administrador 400
    [Documentation]        Teste para tentativa de cadastro de usuário sem campo de administrador.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Tentar Cadastrar Usuario    "user_sem_administrador"
    Validar Status Code    400    ${response}


CT-U12: GET Buscar Usuario Existente 200
    [Documentation]        Teste de busca de usuário existente por id.
    [Tags]                 GET
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}

    ${usuario}=                Set Variable    ${json["dados_cadastro"]["user_valido"]}
    ${id_usuario}=             Cadastrar Usuario    ${usuario}

    #####
    # Teste
    ${response}=               Enviar GET    /usuarios/${id_usuario}
    Log To Console             ${response.json()}
    Validar Status Code        200    ${response}
    Should Not Be Empty        ${response.json()["nome"]}
    Should Not Be Empty        ${response.json()["email"]}
    Should Not Be Empty        ${response.json()["password"]}
    Should Not Be Empty        ${response.json()["administrador"]}
    Should Not Be Empty        ${response.json()["_id"]}

    Validar Usuarios Iguais    ${response.json()}    ${usuario}

    #####
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}
    


CT-U13: GET Tentar Buscar Usuario Inexistente 400
    [Documentation]        Teste para tentativa de busca de produto por id inexistente.
    [Tags]                 GET
    #####
    # Setup
    Criar Sessao

    ${id}=                 Set Variable    naoexiste123

    #####
    # Teste
    ${response}=           Enviar GET    /usuarios/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}



CT-U14: DELETE Excluir Usuario Existente 200
    [Documentation]        Teste de excluir usuário existente.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${usuario}=            Set Variable    ${json["dados_cadastro"]["user_valido"]}
    ${id}=                 Cadastrar Usuario    ${usuario}

    #####
    # Teste
    ${response}=           Enviar DELETE    /usuarios/${id}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verifica se o usuário foi realmente excluído
    ${response}=           Enviar GET    /usuarios/${id}
    Validar Status Code    400    ${response}
    Validar Mensagem       Usuário não encontrado    ${response}


CT-U15: DELETE Tentar Excluir Usuario Com Carrinho 400
    [Documentation]        Teste de tentativa de excluir usuário com carrinho cadastrado.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_delete"]["user_cadastro"]}

    ${token_auth}=         Fazer Login    ${json["dados_delete"]["user_login"]}

    ${id_produto}=         Cadastrar Produto    ${json["dados_delete"]["produto"]}    ${token_auth}

    ${id_carrinho}=        Cadastrar Carrinho    ${id_produto}    ${token_auth}

    #####
    # Teste
    ${response}=           Enviar DELETE    /usuarios/${id_usuario}
    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir usuário com carrinho cadastrado    ${response}

    #####
    # Limpeza de dados
    [Teardown]             Run Keywords    Cancelar Compra    ${token_auth}
    ...                    AND             Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}
    


CT-U16: DELETE Tentar Excluir Usuario Inexistente 200
    [Documentation]        Teste de tentativa de excluir usuário inexistente.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao

    ${id}=                 Set Variable    naoexiste123

    #####
    # Teste
    ${response}=           Enviar DELETE    /usuarios/${id}
    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}



CT-U17: PUT Editar Usuario Existente 200
    [Documentation]        Teste de edição de um usuário existente.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}
    
    ${id_usuario}=             Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}=            Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    #####
    # Teste
    ${response}=               Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    Validar Status Code        200    ${response}
    Validar Mensagem           Registro alterado com sucesso    ${response}

    # Verificar se o usuário foi realmente editado
    ${response}=               Enviar GET    /usuarios/${id_usuario}
    Validar Status Code        200    ${response}
    Validar Usuarios Iguais    ${response.json()}    ${novos_dados}

    #####
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}
    


CT-U18: PUT Tentar Editar Usuario Existente Com Email Repetido 400
    [Documentation]        Teste de tentativa de edição de um usuário existente com
    ...                    o email de outro usuário já cadastrado.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                    Carregar JSON    ${dados_json}

    ${id_usuario_email}=        Cadastrar Usuario    ${json["dados_edicao"]["user_email_repetido"]}

    ${id_usuario_editado}=      Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}=             Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}
    
    #####
    # Teste
    ${response}=                Enviar PUT    /usuarios/${id_usuario_editado}    ${novos_dados}
    Validar Status Code         400    ${response}
    Validar Mensagem            Este email já está sendo usado    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                  Run Keywords    Deletar Usuario    ${id_usuario_email}
    ...                         AND             Deletar Usuario    ${id_usuario_editado}


CT-U19: PUT Tentar Editar Usuário Existente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário existente com nome em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=       Tentar Editar Usuario Existente    "edicao_nome_em_branco"
    Validar Status Code                 400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U20: PUT Tentar Editar Usuário Existente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de usuário existente sem campo de nome.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_sem_nome"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U21: PUT Tentar Editar Usuário Existente Com Email Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário existente com email em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_email_em_branco"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U22: PUT Tentar Editar Usuário Existente Sem Email 400
    [Documentation]    Teste para tentativa de edição de usuário existente sem campo de email.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_sem_email"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U23: PUT Tentar Editar Usuário Existente Com Password Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário existente com password em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_password_em_branco"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U24: PUT Tentar Editar Usuário Existente Sem Password 400
    [Documentation]    Teste para tentativa de edição de usuário existente sem campo de password.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_sem_password"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U25: PUT Tentar Editar Usuário Existente Com Administrador Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário existente com administrador em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_administrador_em_branco"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U26: PUT Tentar Editar Usuário Existente Sem Administrador 400
    [Documentation]    Teste para tentativa de edição de usuário existente sem campo de administrador.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=     Tentar Editar Usuario Existente    "edicao_sem_administrador"
    Validar Status Code               400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}


CT-U27: PUT Tentar Editar Usuário Inexistente 201
    [Documentation]        Teste de edição de um usuário inexistente.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}
    
    ${id_usuario}=             Set Variable    naoexiste1241

    ${novos_dados}=            Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    #####
    # Teste
    ${response}=               Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}

    # Verificar se o usuário foi realmente criado
    ${id_usuario}=             Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    /usuarios/${id_usuario}
    Validar Status Code        200    ${response}
    Validar Usuarios Iguais    ${response.json()}    ${novos_dados}

    #####
    # Limpeza dos dados
    [Teardown]                 Deletar Usuario    ${id_usuario}


CT-U28: PUT Tentar Editar Usuário Inexistente Com Email Repetido 400
    [Documentation]        Teste de tentativa de edição de um usuário inexistente com
    ...                    o email de outro usuário já cadastrado.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                    Carregar JSON    ${dados_json}

    ${id_usuario_email}=        Cadastrar Usuario    ${json["dados_edicao"]["user_email_repetido"]}

    ${id_usuario_editado}=      Set Variable    naoexiste124

    ${novos_dados}=             Set Variable    ${json["dados_edicao"]["edicao_email_repetido"]}
    
    #####
    # Teste
    ${response}=                Enviar PUT    /usuarios/${id_usuario_editado}    ${novos_dados}
    Validar Status Code         400    ${response}
    Validar Mensagem            Este email já está sendo usado    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                  Deletar Usuario    ${id_usuario_email}
    
CT-U29: PUT Tentar Editar Usuário Inexistente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com nome em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_nome_em_branco"
    Validar Status Code                 400    ${response}


CT-U30: PUT Tentar Editar Usuário Inexistente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente sem campo de nome.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_sem_nome"
    Validar Status Code                 400    ${response}


CT-U31: PUT Tentar Editar Usuário Inexistente Com Email Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com email em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_email_em_branco"
    Validar Status Code                 400    ${response}


CT-U32: PUT Tentar Editar Usuário Inexistente Sem Email 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente sem campo de email.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_sem_email"
    Validar Status Code                 400    ${response}


CT-U33: PUT Tentar Editar Usuário Inexistente Com Password Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com password em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_password_em_branco"
    Validar Status Code                 400    ${response}


CT-U34: PUT Tentar Editar Usuário Inexistente Sem Password 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente sem campo de password.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_sem_password"
    Validar Status Code                 400    ${response}


CT-U35: PUT Tentar Editar Usuário Inexistente Com Administrador Em Branco 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com administrador em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_administrador_em_branco"
    Validar Status Code                 400    ${response}


CT-U36: PUT Tentar Editar Usuário Inexistente Sem Administrador 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente sem campo de administrador.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}                         Tentar Editar Usuario Inexistente    "edicao_sem_administrador"
    Validar Status Code                 400    ${response}



* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Tentar Cadastrar Usuario
    [Documentation]         Realiza uma tentativa de cadastro de usuário com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de cadastro de usuário.
    [Arguments]             ${json_usuario}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}
    ${usuario}=             Set Variable    ${json["dados_cadastro"][${json_usuario}]}

    #####
    # Teste
    ${response}=            Enviar POST    /usuarios    ${usuario}
    [Return]                ${response}

Tentar Editar Usuario Existente
    [Documentation]         Realiza uma tentativa de edição de usuário existente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário que será editado, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de usuário.
    ...                     \n\${id_usuario} -- a id do usuário criado para edição.
    [Arguments]             ${json_edicao}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}
    ${id_usuario}=          Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}
    ${novos_dados}=         Set Variable    ${json["dados_edicao"][${json_edicao}]}


    #####
    # Teste
    ${response}=            Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    [Return]                ${response}    ${id_usuario}

Tentar Editar Usuario Inexistente
    [Documentation]         Realiza uma tentativa de edição de usuário inexistente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de usuário.
    [Arguments]             ${json_edicao}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}
    ${id_usuario}=          Set Variable    naoexiste321
    ${novos_dados}=         Set Variable    ${json["dados_edicao"][${json_edicao}]}


    #####
    # Teste
    ${response}=            Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    [Return]                ${response}


Validar Usuarios Iguais
    [Documentation]        Verifica se dois usuários serverest possuem todos os campos iguais.
    ...                    Ignora o campo de '_id'.

    [Arguments]            ${usuario_1}    ${usuario_2}
    Should Be Equal        ${usuario_1["nome"]}             ${usuario_2["nome"]}
    Should Be Equal        ${usuario_1["email"]}            ${usuario_2["email"]}
    Should Be Equal        ${usuario_1["password"]}         ${usuario_2["password"]}
    Should Be Equal        ${usuario_1["administrador"]}    ${usuario_2["administrador"]}

