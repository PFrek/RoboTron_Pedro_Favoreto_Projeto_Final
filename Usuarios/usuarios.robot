* Settings *
Documentation    Arquivo contendo os testes para o endpoint /usuarios da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${endpoint}           /usuarios
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
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}
    
    ${id_usuario}=             Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}=            Set Variable    ${json["dados_edicao"]["edicao_nome_em_branco"]}


    #####
    # Teste
    ${response}=               Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    Validar Status Code        400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

CT-U20: PUT Tentar Editar Usuário Existente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de usuário existente sem campo de nome.
    [Tags]             PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}
    
    ${id_usuario}=             Cadastrar Usuario    ${json["dados_edicao"]["user_inicial"]}

    ${novos_dados}=            Set Variable    ${json["dados_edicao"]["edicao_sem_nome"]}


    #####
    # Teste
    ${response}=               Enviar PUT    /usuarios/${id_usuario}    ${novos_dados}
    Validar Status Code        400    ${response}

    #####
    # Limpeza de dados
    [Teardown]                 Deletar Usuario    ${id_usuario}

# TODO: edicao_email_em_branco em frente, mesmo para Usuário inexistente

Cenario: PUT Tentar Editar Usuário Inexistente 201
    [Documentation]    Teste para tentativa de edição de usuário inexistente.
    [Tags]             PUT

    Criar Sessao

    &{usuario}=        Criar Dados De Usuario    nome=novo usuario    email=novo_usuario@qa.com.br
    ...                password=teste    administrador=false

    ${id}=             Set Variable    id_nao_existe

    ${response}=       Enviar PUT    /usuarios/${id}    ${usuario}
    Validar Status Code    201    ${response}
    Validar Mensagem    Cadastro realizado com sucesso    ${response}
    ${id}=             Set Variable    ${response.json()["_id"]}

    ${response}=       Enviar GET    /usuarios/${id}
    Validar Status Code    200    ${response}

    Validar Usuarios Iguais    ${response.json()}    ${usuario}

    ${response}=       Enviar DELETE    /usuarios/${id}
    Validar Status Code    200    ${response}


Cenario: PUT Tentar Editar Usuário Inexistente Com Email Repetido 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente utilizando email já cadastrado.
    [Tags]             PUT

    ${email}=          Obter Email Existente
    &{usuario}=        Criar Dados De Usuario    nome=novo usuario    email=${email}
    ...                password=123teste    administrador=false

    ${id}=             Set Variable    id_nao_existe

    ${response}=        Enviar PUT    /usuarios/${id}    ${usuario}
    Validar Status Code    400    ${response}
    Validar Mensagem   Este email já está sendo usado    ${response}


Cenario: PUT Tentar Editar Usuário Inexistente Com Dados Inválidos 400
    [Documentation]    Teste para tentativa de edição de usuário inexistente com dados inválidos.
    [Tags]             PUT

    Criar Sessao

    ${id}=                     Set Variable    id_nao_existe
    
    &{dados_invalidos}=        Create Dictionary    nome=Nome    idade=24

    ${response}=               Enviar PUT    /usuarios/${id}    ${dados_invalidos}
    Validar Status Code        400    ${response}


* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Tentar Cadastrar Usuario
    [Documentation]         Realiza uma tentativa de cadastro de usuário com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nReturn: \${response} -- a resposta da tentativa de cadastro de usuário.
    [Arguments]             ${json_usuario}

    ${json}=                Carregar JSON    ${dados_json}
    ${usuario}=             Set Variable    ${json["dados_cadastro"][${json_usuario}]}
    ${response}=            Enviar POST    /usuarios    ${usuario}
    [Return]                ${response}

Criar Dados De Usuario
    [Documentation]    Cria um usuário com as informações passadas por argumento.
    ...                Se nenhum argumento for passado, usa informações pré-definidas.
    ...                \nRetorna: \&{usuario}
    
    [Arguments]        ${nome}=nome_teste    ${email}=email_teste@teste.com.br    ${password}=1234    ${administrador}=true
    &{usuario}=        Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${administrador}
    [Return]           &{usuario}

Remover Campo ID
    [Documentation]    Remove o campo '_id' de um usuário, para facilitar o recadastramento.
    
    [Arguments]        ${usuario}
    &{usuario}=        Create Dictionary    nome=${usuario["nome"]}    
    ...                email=${usuario["email"]}    password=${usuario["password"]}
    ...                administrador=${usuario["administrador"]}
    [Return]           &{usuario}


Obter Email Existente
    [Documentation]      Obtém o email do primeiro usuário da lista de usuários registrados.
    ...                  Necessita que uma sessão com alias 'serverest' já tenha sido criada.
    ...                  \nRetorna: \${email}

    &{usuario}=          Obter Dados De Usuario Existente
    ${email}=            Set Variable    ${usuario["email"]}
    [Return]             ${email}

Validar Usuarios Iguais
    [Documentation]        Verifica se dois usuários serverest possuem todos os campos iguais.

    [Arguments]            ${usuario_1}    ${usuario_2}
    Should Be Equal        ${usuario_1["nome"]}             ${usuario_2["nome"]}
    Should Be Equal        ${usuario_1["email"]}            ${usuario_2["email"]}
    Should Be Equal        ${usuario_1["password"]}         ${usuario_2["password"]}
    Should Be Equal        ${usuario_1["administrador"]}    ${usuario_2["administrador"]}




Teardown-CT-U15
    [Arguments]    ${token_auth}    ${id_produto}    ${id_usuario}
    

Teardown-CT-U17
    [Arguments]    ${id_usuario}
    Deletar Usuario            ${id_usuario}

Teardown-CT-U18    
    [Arguments]        ${id_usuario_email}    ${id_usuario_editado}
    Deletar Usuario    ${id_usuario_email}
    Deletar Usuario    ${id_usuario_editado}

Teardown-CT-U19    
    [Arguments]        ${id_usuario}
    Deletar Usuario    ${id_usuario}