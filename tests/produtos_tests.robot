* Settings *
Documentation    Arquivo contendo os casos de teste para o endpoint /produtos.
Resource         ../keywords/produtos_keywords.robot

Suite Setup      Run Keywords    Criar Sessao
...              AND             Carregar JSON    ${produtos_json}

* Test Cases *
#########################
#         GET           #
#     CT-P01 ~ CT-P03   #
#########################
CT-P01: GET Todos Os Produtos 200
    [Documentation]        Teste de listar todos os produtos com sucesso.
    [Tags]                 GET    STATUS-2XX
    ##########
    # Teste
    ${response}            Enviar GET    /produtos

    Validar Status Code    200    ${response}
    Log To Console         ${response.json()}


CT-P02: GET Buscar Produto Existente 200
    [Documentation]        Teste de busca de produto existente por id.
    [Tags]                 GET    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}           Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}              Cadastrar Usuario               ${dados_usuario}
    ${token_auth}              Fazer Login                     ${id_usuario}

    ${dados_produto}           Set Variable                    ${json["dados_cadastro"]["produto_valido"]}
    ${id_produto}              Cadastrar Produto               ${dados_produto}    ${token_auth}

    ##########
    # Teste
    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    
    Validar Produto Valido     ${response.json()}

    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #########################
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                        AND             Deletar Usuario    ${id_usuario}


CT-P03: GET Tentar Buscar Produto Inexistente 400
    [Documentation]        Teste para tentativa de busca de produto por id inexistente.
    [Tags]                 GET    STATUS-4XX
    ##########
    # Setup
    ${id_produto}          Set Variable    naoexiste123

    ##########
    # Teste
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}


#########################
#         POST          #
#     CT-P04 ~ CT-P15   #
#########################
CT-P04: POST Cadastrar Novo Produto 201
    [Documentation]       Teste de cadastrar um novo produto com sucesso.
    [Tags]                POST    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}           Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}              Cadastrar Usuario               ${dados_usuario}
    ${token_auth}              Fazer Login                     ${id_usuario}
    &{headers}                 Create Dictionary               Authorization=${token_auth}
    
    ${dados_produto}           Set Variable    ${json["dados_cadastro"]["produto_valido"]}

    ##########
    # Teste
    ${response}                Enviar POST    /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    Should Not Be Empty        ${response.json()["_id"]}
    
    # Validar se o produto foi realmente criado
    ${id_produto}              Set Variable    ${response.json()["_id"]}

    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto Valido     ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #########################
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                        AND             Deletar Usuario    ${id_usuario}
    

CT-P05: POST Tentar Cadastrar Produto Com Nome Repetido 400
    [Documentation]          Teste para tentativa de cadastro de produto com nome já cadastrado.
    [Tags]                   POST    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}         Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}            Cadastrar Usuario               ${dados_usuario}
    ${token_auth}            Fazer Login                     ${id_usuario}
    &{headers}               Create Dictionary               Authorization=${token_auth}

    ${id_nome_repetido}      Cadastrar Produto               ${json["dados_cadastro"]["produto_valido"]}    ${token_auth}

    ${dados_produto}         Set Variable                    ${json["dados_cadastro"]["produto_nome_repetido"]}

    ##########
    # Teste
    ${response}              Enviar POST    /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code      400    ${response}
    Validar Mensagem         Já existe produto com esse nome    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]               Run Keywords    Deletar Produto    ${id_nome_repetido}    ${token_auth}
    ...                      AND             Deletar Usuario    ${id_usuario}


CT-P06: POST Tentar Cadastrar Produto Sem Login 401
    [Documentation]        Teste para tentativa de cadastro de produto sem ter feito login.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    ${dados_produto}       Set Variable     ${json["dados_cadastro"]["produto_valido"]}

    ##########
    # Teste
    ${response}            Enviar POST    /produtos    ${dados_produto}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


CT-P07: POST Tentar Cadastrar Produto Sem Ser Administrador 403
    [Documentation]        Teste para tentativa de cadastro de produto por usuário não-administrador.
    [Tags]                 POST    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=false
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    ${dados_produto}       Set Variable         ${json["dados_cadastro"]["produto_valido"]}

    ##########
    # Teste
    ${response}            Enviar POST    /produtos    ${dados_produto}    headers=${headers}

    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}


##############################################
# CT-P08 ~ CT-P15: Testes de dados inválidos #
##############################################
CT-P08: POST Tentar Cadastrar Produto Com Nome Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com nome em branco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_nome_em_branco"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P09: POST Tentar Cadastrar Produto Sem Nome 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de nome.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_sem_nome"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P10: POST Tentar Cadastrar Produto Com Preco Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com preco em branco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste  
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_preco_em_branco"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P11: POST Tentar Cadastrar Produto Sem Preco 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de preco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_sem_preco"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P12: POST Tentar Cadastrar Produto Com Descricao Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com descricao em branco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_descricao_em_branco"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P13: POST Tentar Cadastrar Produto Sem Descricao 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de descricao.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_sem_descricao"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P14: POST Tentar Cadastrar Produto Com Quantidade Em Branco 400
    [Documentation]        Teste para tentativa de cadastro de produto com quantidade em branco.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_quantidade_em_branco"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


CT-P15: POST Tentar Cadastrar Produto Sem Quantidade 400
    [Documentation]        Teste para tentativa de cadastro de produto sem campo de quantidade.
    [Tags]                 POST    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}     Tentar Cadastrar Produto    "produto_sem_quantidade"
    Validar Status Code              400    ${response}
    Log To Console                   ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]                       Deletar Usuario    ${id_usuario}


#########################
#         DELETE        #
#     CT-P16 ~ CT-P20   #
#########################
CT-P16: DELETE Excluir Produto Existente 200
    [Documentation]        Teste de excluir produto existente com sucesso.
    [Tags]                 DELETE    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ##########
    # Teste
    ${response}            Enviar DELETE    /produtos/${id_produto}    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro excluído com sucesso    ${response}
    
    # Verificar se o produto foi realmente excluído
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code    400    ${response}
    Validar Mensagem       Produto não encontrado    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}


CT-P17: DELETE Tentar Excluir Produto Inexistente 200
    [Documentation]        Teste de tentativa de excluir produto inexistente.
    [Tags]                 DELETE    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    ${id_produto}          Set Variable    naoexiste123

    ##########
    # Teste
    ${response}            Enviar DELETE    /produtos/${id_produto}    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Nenhum registro excluído    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_usuario}


CT-P18: DELETE Tentar Excluir Produto Em Carrinho 400
    [Documentation]        Teste de tentativa de excluir produto cadastrado em carrinho.
    [Tags]                 DELETE    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}          Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}             Cadastrar Usuario               ${dados_usuario}
    ${token_auth}             Fazer Login                     ${id_usuario}
    &{headers}                Create Dictionary               Authorization=${token_auth}

    ${dados_produto}          Set Variable                    ${json["dados_cadastro"]["produto_valido"]}
    ${id_produto}             Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${quantidade_carrinho}    Set Variable    ${3}
    ${id_carrinho}            Cadastrar Carrinho    ${id_produto}    ${token_auth}    quantidade=${quantidade_carrinho}

    ##########
    # Teste
    ${response}            Enviar DELETE    /produtos/${id_produto}    headers=${headers}

    Validar Status Code    400    ${response}
    Validar Mensagem       Não é permitido excluir produto que faz parte de carrinho    ${response}
    Should Not Be Empty    ${response.json()["idCarrinhos"]}
    Should Be Equal        ${response.json()["idCarrinhos"][0]}    ${id_carrinho}

    # Verificar se o produto realmente NÃO foi excluído
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto Valido     ${response.json()}
    
    # Dados do produto considerando a quantidade reduzida por ter sido colocado em carrinho
    &{dados_atualizados}   Create Dictionary    
    ...                    nome=${dados_produto["nome"]}    
    ...                    preco=${dados_produto["preco"]}
    ...                    descricao=${dados_produto["descricao"]}    
    ...                    quantidade=${${dados_produto["quantidade"]} - ${quantidade_carrinho}}

    Validar Produtos Iguais    ${response.json()}    ${dados_atualizados}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Cancelar Compra    ${token_auth}
    ...                    AND             Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P19: DELETE Tentar Excluir Produto Existente Sem Login 401
    [Documentation]        Teste de tentativa de excluir produto existente sem ter feito login.
    [Tags]                 DELETE    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}

    ${dados_produto}       Set Variable                    ${json["dados_cadastro"]["produto_valido"]}
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ##########
    # Teste
    ${response}            Enviar DELETE    /produtos/${id_produto}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    # Verificar se o produto realmente NÃO foi excluído
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code       200    ${response}
    Validar Produto Valido    ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P20: DELETE Tentar Excluir Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de tentativa de excluir produto existente por usuário não-administrador.
    [Tags]                 DELETE    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}           Criar Dados Usuario Dinamico    administrador=true
    ${id_user_admin}           Cadastrar Usuario               ${dados_usuario}
    ${token_auth_admin}        Fazer Login                     ${id_user_admin}
    
    ${dados_produto}           Set Variable                    ${json["dados_cadastro"]["produto_valido"]}
    ${id_produto}              Cadastrar Produto               ${dados_produto}    ${token_auth_admin}

    &{dados_usuario}           Criar Dados Usuario Dinamico    administrador=false
    ${id_user_padrao}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth_padrao}       Fazer Login                     ${id_user_padrao}
    &{headers}                 Create Dictionary               Authorization=${token_auth_padrao}

    ##########
    # Teste
    ${response}                Enviar DELETE    /produtos/${id_produto}    headers=${headers}

    Validar Status Code        403    ${response}
    Validar Mensagem           Rota exclusiva para administradores
    ...                        ${response}

    # Verificar se o produto realmente NÃO foi excluído
    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto Valido     ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #####
    # Limpeza dos dados
    [Teardown]                 Run Keywords    Deletar Produto    ${id_produto}    ${token_auth_admin}
    ...                        AND             Deletar Usuario    ${id_user_padrao}
    ...                        AND             Deletar Usuario    ${id_user_admin}


#########################
#         PUT           #
#     CT-P21 ~ CT-P44   #
#########################
CT-P21: PUT Editar Produto Existente 200
    [Documentation]        Teste de edição de um produto existente.
    [Tags]                 PUT    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}
    &{headers}             Create Dictionary               Authorization=${token_auth}

    ${dados_produto}       Set Variable                    ${json["dados_edicao"]["produto_inicial"]}
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${novos_dados}         Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ##########
    # Teste
    ${response}            Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code    200    ${response}
    Validar Mensagem       Registro alterado com sucesso    ${response}

    # Verificar se o produto foi realmente editado
    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${novos_dados}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P22: PUT Tentar Editar Produto Inexistente 201
    [Documentation]        Teste de edição de um produto inexistente.
    [Tags]                 PUT    STATUS-2XX
    ##########
    # Setup
    &{dados_usuario}           Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}              Cadastrar Usuario               ${dados_usuario}
    ${token_auth}              Fazer Login                     ${id_usuario}
    &{headers}                 Create Dictionary               Authorization=${token_auth}

    ${id_produto}              Set Variable    naoexiste9432

    ${novos_dados}             Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ##########
    # Teste
    ${response}                Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code        201    ${response}
    Validar Mensagem           Cadastro realizado com sucesso    ${response}
    Should Not Be Empty        ${response.json()["_id"]}

    # Verificar se o produto foi realmente criado
    ${id_produto}              Set Variable    ${response.json()["_id"]}

    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produtos Iguais    ${response.json()}    ${novos_dados}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P23: PUT Tentar Editar Produto Existente Com Nome Repetido 400
    [Documentation]        Teste de tentativa de edição de um produto existente com
    ...                    o nome de outro produto já cadastrado.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}                Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}                   Cadastrar Usuario               ${dados_usuario}
    ${token_auth}                   Fazer Login                     ${id_usuario}
    &{headers}                      Create Dictionary               Authorization=${token_auth}

    # Produto do qual o nome repetido será retirado
    ${id_produto_repetido}          Cadastrar Produto               ${json["dados_edicao"]["produto_nome_repetido"]}    ${token_auth}

    # Produto que será editado
    ${dados_iniciais}               Set Variable                    ${json["dados_edicao"]["produto_inicial"]}
    ${id_produto_editado}           Cadastrar Produto               ${dados_iniciais}    ${token_auth}

    ${novos_dados}                  Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    ##########
    # Teste
    ${response}                     Enviar PUT    /produtos/${id_produto_editado}    ${novos_dados}    headers=${headers}

    Validar Status Code             400    ${response}
    Validar Mensagem                Já existe produto com esse nome    ${response}

    # Verificar se o produto realmente NÃO foi editado
    ${response}                     Enviar GET    /produtos/${id_produto_editado}

    Validar Status Code             200    ${response}
    Validar Produto Valido          ${response.json()}
    Validar Produtos Iguais         ${response.json()}    ${dados_iniciais}

    #########################
    # Limpeza dos dados
    [Teardown]                      Run Keywords    Deletar Produto    ${id_produto_editado}    ${token_auth}
    ...                             AND             Deletar Produto    ${id_produto_repetido}    ${token_auth}
    ...                             AND             Deletar Usuario    ${id_usuario}


CT-P24: PUT Tentar Editar Produto Inexistente Com Nome Repetido 400    
    [Documentation]        Teste de tentativa de edição de um produto inexistente com
    ...                    o nome de outro produto já cadastrado.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}                Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}                   Cadastrar Usuario               ${dados_usuario}
    ${token_auth}                   Fazer Login                     ${id_usuario}
    &{headers}                      Create Dictionary               Authorization=${token_auth}

    # Produto do qual o nome repetido será retirado
    ${id_produto_repetido}          Cadastrar Produto               ${json["dados_edicao"]["produto_nome_repetido"]}    ${token_auth}

    # Produto que será editado
    ${id_produto_editado}           Set Variable    naoexiste123

    ${novos_dados}                  Set Variable    ${json["dados_edicao"]["edicao_nome_repetido"]}

    ##########
    # Teste
    ${response}                     Enviar PUT    /produtos/${id_produto_editado}    ${novos_dados}    headers=${headers}

    Validar Status Code             400    ${response}
    Validar Mensagem                Já existe produto com esse nome    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]                      Run Keywords    Deletar Produto    ${id_produto_repetido}    ${token_auth}
    ...                             AND             Deletar Usuario    ${id_usuario}


CT-P25: PUT Tentar Editar Produto Existente Sem Login 401
    [Documentation]        Teste de edição de um produto existente sem ter feito login.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}

    ${dados_produto}       Set Variable                    ${json["dados_edicao"]["produto_inicial"]}
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${novos_dados}         Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    ##########
    # Teste
    ${response}            Enviar PUT    /produtos/${id_produto}    ${novos_dados}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}

    # Verificar se o produto realmente NÃO foi editado
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto Valido     ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...                    AND             Deletar Usuario    ${id_usuario}


CT-P26: PUT Tentar Editar Produto Inexistente Sem Login 401
    [Documentation]        Teste de edição de um produto existente sem ter feito login.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    ${id_produto}          Set Variable    naoexiste1412

    ${novos_dados}         Set Variable    ${json["dados_edicao"]["edicao_valida"]}


    ##########
    # Teste
    ${response}            Enviar PUT    /produtos/${id_produto}    ${novos_dados}

    Validar Status Code    401    ${response}
    Validar Mensagem       Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...                    ${response}


CT-P27: PUT Tentar Editar Produto Existente Sem Ser Administrador 403
    [Documentation]        Teste de edição de um produto existente por usuário não-administrador.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    &{dados_usuario}         Criar Dados Usuario Dinamico    administrador=true
    ${id_user_admin}         Cadastrar Usuario               ${dados_usuario}
    ${token_auth_admin}      Fazer Login                     ${id_user_admin}

    ${dados_produto}         Set Variable                    ${json["dados_edicao"]["produto_inicial"]}
    ${id_produto}            Cadastrar Produto               ${dados_produto}    ${token_auth_admin}

    ${novos_dados}           Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    &{dados_usuario}         Criar Dados Usuario Dinamico    administrador=false
    ${id_user_padrao}        Cadastrar Usuario               ${dados_usuario}
    ${token_auth_padrao}     Fazer Login                     ${id_user_padrao}
    &{headers}               Create Dictionary               Authorization=${token_auth_padrao}

    ##########
    # Teste
    ${response}            Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}

    # Verificar se o produto realmente NÃO foi editado
    ${response}            Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto Valido     ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_produto}

    #########################
    # Limpeza dos dados
    [Teardown]             Run Keywords    Deletar Produto    ${id_produto}    ${token_auth_admin}
    ...                    AND             Deletar Usuario    ${id_user_padrao}
    ...                    AND             Deletar Usuario    ${id_user_admin}


CT-P28: PUT Tentar Editar Produto Inexistente Sem Ser Administrador 403
    [Documentation]        Teste de edição de um produto existente por usuário não-administrador.
    [Tags]                 PUT    STATUS-4XX
    ##########
    # Setup
    ${id_produto}            Set Variable    naoexiste10312

    ${novos_dados}           Set Variable    ${json["dados_edicao"]["edicao_valida"]}

    &{dados_usuario}         Criar Dados Usuario Dinamico    administrador=false
    ${id_user_padrao}        Cadastrar Usuario               ${dados_usuario}
    ${token_auth_padrao}     Fazer Login                     ${id_user_padrao}
    &{headers}               Create Dictionary               Authorization=${token_auth_padrao}

    ##########
    # Teste
    ${response}            Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    Validar Status Code    403    ${response}
    Validar Mensagem       Rota exclusiva para administradores
    ...                    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]             Deletar Usuario    ${id_user_padrao}


##############################################
# CT-P29 ~ CT-P44: Testes de dados inválidos #
##############################################
CT-P29: PUT Tentar Editar Produto Existente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com nome em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_nome_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P30: PUT Tentar Editar Produto Inexistente Com Nome Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com nome em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}
    ...    Tentar Editar Produto Inexistente    "edicao_nome_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P31: PUT Tentar Editar Produto Existente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de nome.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_sem_nome"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P32: PUT Tentar Editar Produto Inexistente Sem Nome 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de nome.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}
    ...    Tentar Editar Produto Inexistente    "edicao_sem_nome"

    Validar Status Code        400    ${response}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P33: PUT Tentar Editar Produto Existente Com Preco Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com preco em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}
    ...    Tentar Editar Produto Existente    "edicao_preco_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P34: PUT Tentar Editar Produto Inexistente Com Preco Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com preco em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}
    ...    Tentar Editar Produto Inexistente    "edicao_preco_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P35: PUT Tentar Editar Produto Existente Sem Preco 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de preco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth}
    ...    Tentar Editar Produto Existente    "edicao_sem_preco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P36: PUT Tentar Editar Produto Inexistente Sem Preco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de preco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario} 
    ...    Tentar Editar Produto Inexistente    "edicao_sem_preco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P37: PUT Tentar Editar Produto Existente Com Descricao Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com descricao em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_descricao_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P38: PUT Tentar Editar Produto Inexistente Com Descricao Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com descricao em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario} 
    ...    Tentar Editar Produto Inexistente    "edicao_descricao_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P39: PUT Tentar Editar Produto Existente Sem Descricao 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de descricao.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_sem_descricao"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P40: PUT Tentar Editar Produto Inexistente Sem Descricao 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de descricao.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}
    ...    Tentar Editar Produto Inexistente    "edicao_sem_descricao"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P41: PUT Tentar Editar Produto Existente Com Quantidade Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto existente com quantidade em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_quantidade_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P42: PUT Tentar Editar Produto Inexistente Com Quantidade Em Branco 400
    [Documentation]    Teste para tentativa de edição de produto inexistente com quantidade em branco.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}
    ...    Tentar Editar Produto Inexistente    "edicao_quantidade_em_branco"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


CT-P43: PUT Tentar Editar Produto Existente Sem Quantidade 400
    [Documentation]    Teste para tentativa de edição de produto existente sem campo de quantidade.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario}    ${id_produto}    ${token_auth} 
    ...    Tentar Editar Produto Existente    "edicao_sem_quantidade"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #####
    # Limpeza dos dados
    [Teardown]        Run Keywords    Deletar Produto    ${id_produto}    ${token_auth}
    ...               AND             Deletar Usuario    ${id_usuario}


CT-P44: PUT Tentar Editar Produto Inexistente Sem Quantidade 400
    [Documentation]    Teste para tentativa de edição de produto inexistente sem campo de quantidade.
    [Tags]             PUT    STATUS-4XX
    ####################
    # Setup & Teste
    ${response}    ${id_usuario} 
    ...    Tentar Editar Produto Inexistente    "edicao_sem_quantidade"

    Validar Status Code        400    ${response}
    Log To Console             ${response.json()}

    #########################
    # Limpeza dos dados
    [Teardown]        Deletar Usuario    ${id_usuario}


##########################################################################################
