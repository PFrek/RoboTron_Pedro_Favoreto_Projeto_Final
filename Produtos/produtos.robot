* Settings *
Documentation    Arquivo contendo os testes para o endpoint /produtos da API ServeRest.
Library          RequestsLibrary
Resource         ../keywords_comuns.robot


* Variables *
${dados_json}         produtos_dados.json

* Test Cases *

CT-P01: GET Todos Os Produtos 200
    [Documentation]        Teste de listar todos os produtos com sucesso.
    [Tags]                 GET-TODOS
    #####
    # Setup
    Criar Sessao

    #####
    # Teste
    ${response}=           Enviar GET    /produtos
    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


CT-P02: POST Cadastrar Novo Produto 201
    [Documentation]       Teste de cadastrar um novo produto com sucesso.
    [Tags]                POST
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}

    ${id_usuario}=             Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    
    ${token_auth}=             Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=                Create Dictionary    Authorization=${token_auth}
    
    ${dados_produto}=          Set Variable    ${json["dados_cadastro"]["produto_valido"]}

    #####
    # Teste
    ${response}=               Enviar POST    /produtos    ${dados_produto}    headers=${headers}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    Should Not Be Empty        ${response.json()["_id"]}

    
    # Validar que o produto foi realmente criado
    ${id_produto}=             Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    /produtos/${id_produto}
    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}


    #####
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                        AND             Deletar Usuario    ${id_usuario}
    

CT-P03: POST Tentar Cadastrar Produto Com Nome Repetido 400
    [Documentation]          Teste para tentativa de cadastro de produto com nome já cadastrado.
    [Tags]                   POST
    #####
    # Setup
    Criar Sessao
    ${json}=                 Carregar JSON    ${dados_json}

    ${id_usuario}=           Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    
    ${token_auth}=           Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${id_nome_repetido}=     Cadastrar Produto    ${json["dados_cadastro"]["produto_valido"]}    ${token_auth}

    ${dados_produto}=        Set Variable    ${json["dados_cadastro"]["produto_nome_repetido"]}

    &{headers}=              Create Dictionary    Authorization=${token_auth}

    #####
    # Teste
    ${response}=             Enviar POST    /produtos    ${dados_produto}    headers=${headers}
    Validar Status Code      400    ${response}
    Validar Mensagem         Já existe produto com esse nome    ${response}

    #####
    # Limpeza dos dados
    [Teardown]               Run Keywords    Deletar Produto    ${id_nome_repetido}    ${token_auth}
    ...                      AND             Deletar Usuario    ${id_usuario}


CT-P04: POST Tentar Cadastrar Produto Com Nome Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com nome em branco.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_nome_em_branco"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P05: POST Tentar Cadastrar Produto Sem Nome 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de nome.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_sem_nome"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P06: POST Tentar Cadastrar Produto Com Preco Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com preco em branco.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_preco_em_branco"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P07: POST Tentar Cadastrar Produto Sem Preco 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de preco.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_sem_preco"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P08: POST Tentar Cadastrar Produto Com Descricao Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com descricao em branco.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_descricao_em_branco"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P09: POST Tentar Cadastrar Produto Sem Descricao 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de descricao.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_sem_descricao"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P10: POST Tentar Cadastrar Produto Com Quantidade Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com quantidade em branco.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao
    
    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_quantidade_em_branco"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P11: POST Tentar Cadastrar Produto Sem Quantidade 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de quantidade.
    [Tags]                 POST
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=    Tentar Cadastrar Produto    "produto_sem_quantidade"
    Validar Status Code              400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}

CT-P12: POST Tentar Cadastrar Produto Sem Login 401
    [Documentation]        Teste para tentativa de cadastro de produto sem ter feito login.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${produto}=            Set Variable    ${json["dados_cadastro"]["produto_valido"]}

    #####
    # Teste
    ${response}=           Enviar POST    /produtos    ${produto}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


CT-P13: POST Tentar Cadastrar Produto Sem Ser Administrador 403
    [Documentation]        Teste para tentativa de cadastro de produto por usuário não-administrador.
    [Tags]                 POST
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_padrao"]}

    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_padrao_login"]}
    &{headers}=            Create Dictionary    Authorization=${token_auth}

    ${produto}=            Set Variable    ${json["dados_cadastro"]["produto_valido"]}

    #####
    # Teste
    ${response}=            Enviar POST    /produtos    ${produto}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}



CT-P14: GET Buscar Produto Existente 200
    [Documentation]        Teste de busca de produto existente por id.
    [Tags]                 GET
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}

    ${id_usuario}=             Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=             Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${dados_produto}=          Set Variable    ${json["dados_cadastro"]["produto_valido"]}
    ${id_produto}=             Cadastrar Produto    ${dados_produto}    ${token_auth}

    #####
    # Teste
    ${response}=               Enviar GET    /produtos/${id_produto}
    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #####
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                        AND             Deletar Usuario    ${id_usuario}


CT-P15: GET Tentar Buscar Produto Inexistente 400
    [Documentation]        Teste para tentativa de busca de produto por id inexistente.
    [Tags]                 GET
    #####
    # Setup
    Criar Sessao

    ${id_produto}=                 Set Variable    naoexiste123

    #####
    # Teste
    ${response}=           Enviar GET    /produtos/${id_produto}
    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}


CT-P16: DELETE Excluir Produto Existente 200
    [Documentation]        Teste de excluir produto existente com sucesso.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    
    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=            Create Dictionary    Authorization=${token_auth}

    ${id_produto}=         Cadastrar Produto    ${json["dados_cadastro"]["produto_valido"]}    ${token_auth}
    #####
    # Teste
    ${response}=           Enviar DELETE    /produtos/${id_produto}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verifica se o produto foi realmente excluído
    ${response}=           Enviar GET    /produtos/${id_produto}
    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}

CT-P17: DELETE Tentar Excluir Produto Em Carrinho 400
    [Documentation]        Teste de tentativa de excluir produto cadastrado em carrinho.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=            Create Dictionary    Authorization=${token_auth}

    ${id_produto}=         Cadastrar Produto    ${json["dados_cadastro"]["produto_valido"]}    ${token_auth}

    ${id_carrinho1}=        Cadastrar Carrinho    ${id_produto}    ${token_auth}
    

    #####
    # Teste
    ${response}=           Enviar DELETE    /produtos/${id_produto}    headers=${headers}
    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir produto que faz parte de carrinho    ${response}
    Should Not Be Empty    ${response.json()["idCarrinhos"]}
    Should Be Equal        ${response.json()["idCarrinhos"][0]}    ${id_carrinho1}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Cancelar Compra    ${token_auth}
    ...                    AND             Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P18: DELETE Tentar Excluir Produto Inexistente 200
    [Documentation]        Teste de tentativa de excluir produto inexistente.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=            Create Dictionary    Authorization=${token_auth}

    ${id_produto}=         Set Variable    naoexiste123

    #####
    # Teste
    ${response}=           Enviar DELETE    /produtos/${id_produto}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}


CT-P19: DELETE Tentar Excluir Produto Existente Sem Login 401
    [Documentation]        Teste de tentativa de excluir produto existente sem ter feito login.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${id_produto}=         Cadastrar Produto    ${json["dados_cadastro"]["produto_valido"]}    ${token_auth}

    #####
    # Teste
    ${response}=           Enviar DELETE    /produtos/${id_produto}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P20: DELETE Tentar Excluir Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de tentativa de excluir produto existente por usuário não-administrador.
    [Tags]                 DELETE
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}

    ${id_admin}=               Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth_admin}=       Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${id_produto}=             Cadastrar Produto    ${json["dados_cadastro"]["produto_valido"]}    ${token_auth_admin}

    ${id_user_padrao}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_padrao"]}

    ${token_auth_padrao}=      Fazer Login    ${json["dados_usuarios"]["user_padrao_login"]}
    &{headers}=                Create Dictionary    Authorization=${token_auth_padrao}

    #####
    # Teste
    ${response}=               Enviar DELETE    /produtos/${id_produto}    headers=${headers}
    Validar Status Code        403    ${response}
    Validar Mensagem           Rota exclusiva para administradores
    ...                        ${response}

    #####
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth_admin}
    ...                        AND             Deletar Usuario    ${id_user_padrao}
    ...                        AND             Deletar Usuario    ${id_admin}


CT-P21: PUT Editar Produto Existente 200
    [Documentation]        Teste de edição de um produto existente.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    
    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=            Create Dictionary    Authorization=${token_auth}

    ${id_produto}=         Cadastrar Produto    ${json["dados_edicao"]["produto_inicial"]}    ${token_auth}

    ${novos_dados}=        Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    #####
    # Teste
    ${response}=           Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    Validar Status Code    200    ${response}
    Validar Mensagem       Registro alterado com sucesso    ${response}

    # Verificar se o produto foi realmente editado
    ${response}=           Enviar GET    /produtos/${id_produto}
    Validar Status Code    200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${novos_dados}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P22: PUT Tentar Editar Produto Existente Com Nome Repetido 400
    [Documentation]        Teste de tentativa de edição de um produto existente com
    ...                    o nome de outro produto já cadastrado.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                        Carregar JSON    ${dados_json}

    ${id_usuario}=                  Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=                  Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=                     Create Dictionary    Authorization=${token_auth}

    # Produto que será editado
    ${id_produto_editado}=          Cadastrar Produto    ${json["dados_edicao"]["produto_inicial"]}    ${token_auth}

    # Produto do qual o nome repetido será retirado
    ${id_produto_repetido}=         Cadastrar Produto    ${json["dados_edicao"]["produto_nome_repetido"]}    ${token_auth}

    ${novos_dados}=                 Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    #####
    # Teste
    ${response}=                    Enviar PUT    /produtos/${id_produto_editado}    ${novos_dados}    headers=${headers}
    Validar Status Code             400    ${response}
    Validar Mensagem                Já existe produto com esse nome    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                      Run Keywords    Deletar Produto    ${id_produto_editado}    ${token_auth}
    ...                             AND             Deletar Produto    ${id_produto_repetido}    ${token_auth}
    ...                             AND             Deletar Usuario    ${id_usuario}


CT-P23: PUT Tentar Editar Produto Existente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com nome em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_nome_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P24: PUT Tentar Editar Produto Existente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de nome.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_sem_nome"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P25: PUT Tentar Editar Produto Existente Com Preco Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com preco em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_preco_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P26: PUT Tentar Editar Produto Existente Sem Preco 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de preco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_sem_preco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P27: PUT Tentar Editar Produto Existente Com Descricao Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com descricao em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_descricao_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P28: PUT Tentar Editar Produto Existente Sem Descricao 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de descricao.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_sem_descricao"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P29: PUT Tentar Editar Produto Existente Com Quantidade Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com quantidade em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_quantidade_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P30: PUT Tentar Editar Produto Existente Sem Quantidade 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de quantidade.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}=
    ...    Tentar Editar Produto Existente    "edicao_sem_quantidade"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}

CT-P31: PUT Tentar Editar Produto Existente Sem Login 401
    [Documentation]        Teste de edição de um produto existente sem ter feito login.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_usuario}=         Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=         Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${id_produto}=         Cadastrar Produto    ${json["dados_edicao"]["produto_inicial"]}    ${token_auth}

    ${novos_dados}=        Set Variable    ${json["dados_edicao"]["edicao_valida"]}


    #####
    # Teste
    ${response}=           Enviar PUT    /produtos/${id_produto}    ${novos_dados}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}

CT-P32: PUT Tentar Editar Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de edição de um produto existente por usuário não-administrador.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                 Carregar JSON    ${dados_json}

    ${id_admin}=             Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth_admin}=     Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}

    ${id_produto}=           Cadastrar Produto    ${json["dados_edicao"]["produto_inicial"]}    ${token_auth_admin}

    ${novos_dados}=          Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${id_user_padrao}=       Cadastrar Usuario    ${json["dados_usuarios"]["user_padrao"]}

    ${token_auth_padrao}=    Fazer Login    ${json["dados_usuarios"]["user_padrao_login"]}
    &{headers}=              Create Dictionary    Authorization=${token_auth_padrao}

    #####
    # Teste
    ${response}=           Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth_admin}
    ...                    AND             Deletar Usuario    ${id_user_padrao}
    ...                    AND             Deletar Usuario    ${id_admin}


CT-P33: PUT Tentar Editar Produto Inexistente 201
    [Documentation]        Teste de edição de um produto inexistente.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                   Carregar JSON    ${dados_json}

    ${id_usuario}=             Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    
    ${token_auth}=             Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=                Create Dictionary    Authorization=${token_auth}

    ${id_produto}=             Set Variable    naoexiste9432

    ${novos_dados}=            Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    #####
    # Teste
    ${response}=               Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}

    # Verificar se o produto foi realmente criado
    ${id_produto}=             Set Variable    ${response.json()["_id"]}
    ${response}=               Enviar GET    /produtos/${id_produto}
    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${novos_dados}

    #####
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P34: PUT Tentar Editar Produto Inexistente Com Nome Repetido 400    
    [Documentation]        Teste de tentativa de edição de um produto inexistente com
    ...                    o nome de outro produto já cadastrado.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                        Carregar JSON    ${dados_json}

    ${id_usuario}=                  Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=                  Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=                     Create Dictionary    Authorization=${token_auth}

    # Produto que será editado
    ${id_produto_editado}=          Set Variable    naoexiste123

    # Produto do qual o nome repetido será retirado
    ${id_produto_repetido}=         Cadastrar Produto    ${json["dados_edicao"]["produto_nome_repetido"]}    ${token_auth}

    ${novos_dados}=                 Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    #####
    # Teste
    ${response}=                    Enviar PUT    /produtos/${id_produto_editado}    ${novos_dados}    headers=${headers}
    Validar Status Code             400    ${response}
    Validar Mensagem                Já existe produto com esse nome    ${response}

    #####
    # Limpeza dos dados
    [Teardown]                      Run Keywords    Deletar Produto    ${id_produto_repetido}    ${token_auth}
    ...                             AND             Deletar Usuario    ${id_usuario}

CT-P35: PUT Tentar Editar Produto Inexistente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com nome em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_nome_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P36: PUT Tentar Editar Produto Inexistente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de nome.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_sem_nome"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P37: PUT Tentar Editar Produto Inexistente Com Preco Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com preco em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_preco_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P38: PUT Tentar Editar Produto Inexistente Sem Preco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de preco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_sem_preco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P39: PUT Tentar Editar Produto Inexistente Com Descricao Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com descricao em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_descricao_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P40: PUT Tentar Editar Produto Inexistente Sem Descricao 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de descricao.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_sem_descricao"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P41: PUT Tentar Editar Produto Inexistente Com Quantidade Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com quantidade em branco.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_quantidade_em_branco"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}

CT-P42: PUT Tentar Editar Produto Inexistente Sem Quantidade 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de quantidade.
    [Tags]             PUT
    #####
    # Setup & Teste
    Criar Sessao

    ${response}    ${id_usuario}=
    ...    Tentar Editar Produto Inexistente    "edicao_sem_quantidade"

    Validar Status Code        400    ${response}

    #####
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}



CT-P43: PUT Tentar Editar Produto Inexistente Sem Login 401
    [Documentation]        Teste de edição de um produto existente sem ter feito login.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=               Carregar JSON    ${dados_json}

    ${id_produto}=         Set Variable    naoexiste1412

    ${novos_dados}=        Set Variable    ${json["dados_edicao"]["edicao_valida"]}


    #####
    # Teste
    ${response}=           Enviar PUT    /produtos/${id_produto}    ${novos_dados}
    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


CT-P44: PUT Tentar Editar Produto Inexistente Sem Ser Administrador 403
    [Documentation]        Teste de edição de um produto existente por usuário não-administrador.
    [Tags]                 PUT
    #####
    # Setup
    Criar Sessao
    ${json}=                 Carregar JSON    ${dados_json}

    ${id_produto}=           Set Variable    naoexiste10312

    ${novos_dados}=          Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ${id_user_padrao}=       Cadastrar Usuario    ${json["dados_usuarios"]["user_padrao"]}

    ${token_auth_padrao}=    Fazer Login    ${json["dados_usuarios"]["user_padrao_login"]}
    &{headers}=              Create Dictionary    Authorization=${token_auth_padrao}

    #####
    # Teste
    ${response}=           Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}

    #####
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_user_padrao}



* Keywords *

# Listadas apenas keywords usadas unicamente nesta suíte de testes

Tentar Cadastrar Produto
    [Documentation]         Realiza uma tentativa de cadastro de produto com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de cadastro de usuário.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    [Arguments]             ${json_produto}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}
    ${produto}=             Set Variable    ${json["dados_cadastro"][${json_produto}]}

    ${id_usuario}=          Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}
    ${token_auth}=          Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=             Create Dictionary    Authorization=${token_auth}

    #####
    # Teste
    ${response}=            Enviar POST    /produtos    ${produto}    headers=${headers}
    [Return]                ${response}    ${id_usuario}

Tentar Editar Produto Existente
    [Documentation]         Realiza uma tentativa de edição de produto existente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nCria um produto que será editado, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de produto.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    ...                     \n\${id_produto} -- a id do produto criado para edição.
    ...                     \n\${token_auth} -- a token de autorização do usuário logado.
    [Arguments]             ${json_edicao}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}

    ${id_usuario}=          Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=          Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=             Create Dictionary    Authorization=${token_auth}

    ${id_produto}=          Cadastrar Produto    ${json["dados_edicao"]["produto_inicial"]}    ${token_auth}

    ${novos_dados}=         Set Variable    ${json["dados_edicao"][${json_edicao}]}

    #####
    # Teste
    ${response}=            Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    [Return]                ${response}    ${id_usuario}    ${id_produto}    ${token_auth}

Tentar Editar Produto Inexistente
    [Documentation]         Realiza uma tentativa de edição de produto inexistente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de produto.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    [Arguments]             ${json_edicao}
    #####
    # Setup
    ${json}=                Carregar JSON    ${dados_json}

    ${id_usuario}=          Cadastrar Usuario    ${json["dados_usuarios"]["user_admin"]}

    ${token_auth}=          Fazer Login    ${json["dados_usuarios"]["user_admin_login"]}
    &{headers}=             Create Dictionary    Authorization=${token_auth}

    ${id_produto}=          Set Variable    naoexiste234

    ${novos_dados}=         Set Variable    ${json["dados_edicao"][${json_edicao}]}

    #####
    # Teste
    ${response}=            Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}
    [Return]                ${response}    ${id_usuario}


Validar Produtos Iguais
    [Documentation]      Verifica se dois produtos serverest possuem todos os campos iguais.
    ...                  Ignora o campo de '_id'.

    [Arguments]          ${produto_1}    ${produto_2}
    Should Be Equal      ${produto_1["nome"]}    ${produto_2["nome"]}
    Should Be Equal      ${produto_1["preco"]}    ${produto_2["preco"]}
    Should Be Equal      ${produto_1["descricao"]}    ${produto_2["descricao"]}
    Should Be Equal      ${produto_1["quantidade"]}    ${produto_2["quantidade"]}
